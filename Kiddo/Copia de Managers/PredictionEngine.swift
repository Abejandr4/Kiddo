import Foundation
import CoreML

// MARK: - Tipos

struct HourlyPrediction {
    let hour: Int
    let predictedFatigue: Double   // 1.0–5.0
    let predictedPain: Double      // 1.0–5.0

    /// Nivel de energía compuesto (inverso de fatiga+dolor, normalizado 0–1)
    var energyScore: Double {
        let combined = (predictedFatigue + predictedPain) / 2.0
        return (5.0 - combined) / 4.0  // 0 = peor, 1 = mejor
    }

    var isBadHour: Bool  { predictedFatigue >= 4.0 || predictedPain >= 4.0 }
    var isGoodHour: Bool { predictedFatigue <= 2.0 && predictedPain <= 2.0 }
}

struct DailyInsight {
    let bestHours: [Int]       // horas con menor fatiga/dolor
    let worstHours: [Int]      // horas con mayor fatiga/dolor
    let peakEnergyHour: Int    // la mejor hora del día
    let allPredictions: [HourlyPrediction]
}

enum PredictionEngineError: LocalizedError {
    case modelNotFound
    case predictionFailed(String)
    case notEnoughData

    var errorDescription: String? {
        switch self {
        case .modelNotFound:
            return "No se encontró un modelo entrenado. Agrega más entradas al diario."
        case .predictionFailed(let reason):
            return "Error al predecir: \(reason)"
        case .notEnoughData:
            return "Necesitas más entradas para generar predicciones."
        }
    }
}

// MARK: - PredictionEngine

final class PredictionEngine {

    static let shared = PredictionEngine()
    private init() {}

    private var fatigueModel: MLModel?
    private var painModel: MLModel?

    // MARK: - Carga de modelos

    /// Carga los modelos compilados desde disco. Llama esto después de entrenar.
    func loadModels() throws {
        guard let fatigueURL = MLTrainer.shared.fatigueModelURL,
              let painURL    = MLTrainer.shared.painModelURL else {
            throw PredictionEngineError.modelNotFound
        }

        fatigueModel = try MLModel(contentsOf: fatigueURL)
        painModel    = try MLModel(contentsOf: painURL)
    }

    var modelsLoaded: Bool {
        fatigueModel != nil && painModel != nil
    }

    // MARK: - Predicción por hora

    /// Predice fatiga y dolor para una hora específica del día
    func predict(hour: Int, dayOfWeek: Int, recentWellbeing: Double = 3.0) throws -> HourlyPrediction {
        guard let fatigueModel, let painModel else {
            throw PredictionEngineError.modelNotFound
        }

        let input = buildInput(hour: hour, dayOfWeek: dayOfWeek, wellbeing: recentWellbeing)

        do {
            let fatigueOutput  = try fatigueModel.prediction(from: input)
            let painOutput     = try painModel.prediction(from: input)

            let fatigue  = extractDouble(from: fatigueOutput, key: "fatigueLevel").clamped(to: 1...5)
            let pain     = extractDouble(from: painOutput,    key: "painLevel").clamped(to: 1...5)

            return HourlyPrediction(hour: hour, predictedFatigue: fatigue, predictedPain: pain)

        } catch {
            throw PredictionEngineError.predictionFailed(error.localizedDescription)
        }
    }

    // MARK: - Predicción del día completo (las 24 horas)

    /// Genera predicciones para todas las horas del día y calcula el insight diario.
    /// Usa el día de hoy y el bienestar promedio reciente del usuario.
    func generateDailyInsight(
        recentEntries: [DiaryEntry],
        targetDate: Date = .now
    ) throws -> DailyInsight {

        guard modelsLoaded else { throw PredictionEngineError.modelNotFound }
        guard !recentEntries.isEmpty else { throw PredictionEngineError.notEnoughData }

        let dayOfWeek = Calendar.current.component(.weekday, from: targetDate)

        // Bienestar promedio de las últimas 5 entradas como contexto
        let recentWellbeing = recentEntries.prefix(5)
            .map { $0.wellbeingScore }
            .reduce(0, +) / Double(min(recentEntries.count, 5))

        // Predecir las 24 horas
        var predictions: [HourlyPrediction] = []
        for hour in 0..<24 {
            let prediction = try predict(
                hour: hour,
                dayOfWeek: dayOfWeek,
                recentWellbeing: recentWellbeing
            )
            predictions.append(prediction)
        }

        // Clasificar horas
        let sorted = predictions.sorted { $0.energyScore > $1.energyScore }
        let bestHours  = Array(sorted.prefix(4).map { $0.hour }.sorted())
        let worstHours = Array(sorted.suffix(4).map { $0.hour }.sorted())
        let peakHour   = sorted.first!.hour

        return DailyInsight(
            bestHours: bestHours,
            worstHours: worstHours,
            peakEnergyHour: peakHour,
            allPredictions: predictions
        )
    }

    // MARK: - Fallback sin modelo (heurístico con promedios)

    /// Cuando no hay modelo entrenado aún, usa promedios históricos simples.
    func generateHeuristicInsight(averagesByHour: [Int: (fatigue: Double, pain: Double, wellbeing: Double)]) -> DailyInsight {

        let predictions: [HourlyPrediction] = (0..<24).map { hour in
            if let avg = averagesByHour[hour] {
                return HourlyPrediction(hour: hour, predictedFatigue: avg.fatigue, predictedPain: avg.pain)
            } else {
                // Sin datos para esa hora: asumir valores neutros
                return HourlyPrediction(hour: hour, predictedFatigue: 3.0, predictedPain: 3.0)
            }
        }

        let sorted     = predictions.sorted { $0.energyScore > $1.energyScore }
        let bestHours  = Array(sorted.prefix(4).map { $0.hour }.sorted())
        let worstHours = Array(sorted.suffix(4).map { $0.hour }.sorted())
        let peakHour   = sorted.first!.hour

        return DailyInsight(
            bestHours: bestHours,
            worstHours: worstHours,
            peakEnergyHour: peakHour,
            allPredictions: predictions
        )
    }

    // MARK: - Privados

    private func buildInput(hour: Int, dayOfWeek: Int, wellbeing: Double) -> MLDictionaryFeatureProvider {
        let features: [String: MLFeatureValue] = [
            "hour":           MLFeatureValue(double: Double(hour)),
            "dayOfWeek":      MLFeatureValue(double: Double(dayOfWeek)),
            "wellbeingScore": MLFeatureValue(double: wellbeing)
        ]
        // Force try es seguro aquí porque las keys son literales correctas
        return try! MLDictionaryFeatureProvider(dictionary: features)
    }

    private func extractDouble(from output: MLFeatureProvider, key: String) -> Double {
        output.featureValue(for: key)?.doubleValue ?? 3.0
    }
}

// MARK: - Helpers

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
