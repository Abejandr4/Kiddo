import Foundation
import CoreML

final class MLTrainer {

    static let shared = MLTrainer()
    private init() {}

    var fatigueModelURL: URL? {
        Bundle.main.url(forResource: "FatigueModel", withExtension: "mlmodelc")
    }

    var painModelURL: URL? {
        Bundle.main.url(forResource: "PainModel", withExtension: "mlmodelc")
    }

    var fatigueModelExists: Bool { fatigueModelURL != nil }
    var painModelExists: Bool    { painModelURL != nil }

    // Exporta datos reales del usuario para re-entrenar en el futuro
    func exportTrainingCSV(entries: [DiaryEntry]) throws -> URL {
        var csv = "hour,dayOfWeek,wellbeingScore,fatigueLevel,painLevel\n"
        for entry in entries {
            csv += "\(Int(entry.hour)),\(Int(entry.dayOfWeek)),"
            csv += "\(entry.wellbeingScore),\(entry.fatigueLevel),\(entry.painLevel)\n"
        }
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("training_data_\(Date().timeIntervalSince1970).csv")
        try csv.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
}
