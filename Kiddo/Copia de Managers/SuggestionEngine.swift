import Foundation

// MARK: - Tipos

struct Suggestion: Identifiable {
    let id = UUID()
    let title: String
    let detail: String
    let emoji: String
    let category: SuggestionCategory
    let urgency: SuggestionUrgency
}

enum SuggestionCategory {
    case rest           // descanso / sueño
    case lightActivity  // actividad suave
    case enjoyment      // ocio / juego
    case social         // socializar
    case selfCare       // autocuidado
    case productivity   // aprovechar energía
}

enum SuggestionUrgency {
    case gentle     // recomendación suave
    case moderate   // recomendación clara
    case strong     // recomendación fuerte
}

struct SuggestionContext {
    let currentHour: Int
    let currentFatigue: Double
    let currentPain: Double
    let currentWellbeing: Double
    let insight: DailyInsight        // predicciones del día
    let recentTrend: Trend           // tendencia de las últimas entradas
}

enum Trend {
    case improving   // mejorando
    case stable      // estable
    case worsening   // empeorando
}

// MARK: - SuggestionEngine

final class SuggestionEngine {

    static let shared = SuggestionEngine()
    private init() {}

    // MARK: - API principal

    /// Genera sugerencias personalizadas en base al contexto actual del usuario.
    func suggestions(for context: SuggestionContext) -> [Suggestion] {
        var result: [Suggestion] = []

        result += suggestionsForCurrentState(context)
        result += suggestionsForUpcomingHours(context)
        result += trendBasedSuggestions(context)

        // Ordenar por urgencia y limitar a 4 sugerencias para no abrumar
        return result
            .sorted { $0.urgency.priority > $1.urgency.priority }
            .prefix(4)
            .map { $0 }
    }

    /// Construye el contexto automáticamente desde las entradas recientes + insight del día.
    func buildContext(
        recentEntries: [DiaryEntry],
        insight: DailyInsight,
        at date: Date = .now
    ) -> SuggestionContext? {
        guard let latest = recentEntries.first else { return nil }

        let hour = Calendar.current.component(.hour, from: date)
        let trend = calculateTrend(from: recentEntries)

        return SuggestionContext(
            currentHour: hour,
            currentFatigue: Double(latest.fatigueLevel),
            currentPain: Double(latest.painLevel),
            currentWellbeing: latest.wellbeingScore,
            insight: insight,
            recentTrend: trend
        )
    }

    // MARK: - Sugerencias por estado actual

    private func suggestionsForCurrentState(_ ctx: SuggestionContext) -> [Suggestion] {
        var suggestions: [Suggestion] = []
        let fatigue   = ctx.currentFatigue
        let pain      = ctx.currentPain
        let wellbeing = ctx.currentWellbeing

        // Fatiga y dolor altos → descanso urgente
        if fatigue >= 4.0 && pain >= 4.0 {
            suggestions.append(Suggestion(
                title: "Tómatelo con mucha calma",
                detail: "Tu cuerpo está enviando señales claras. Este es buen momento para recostarte y dejar que descanse.",
                emoji: "🛋️",
                category: .rest,
                urgency: .strong
            ))
        }

        // Solo fatiga alta
        if fatigue >= 4.0 && pain < 3.0 {
            suggestions.append(Suggestion(
                title: "Hora de recargar energía",
                detail: "Estás bastante agotado/a. Una siesta corta de 20 minutos puede hacer una gran diferencia.",
                emoji: "😴",
                category: .rest,
                urgency: .strong
            ))
        }

        // Solo dolor alto
        if pain >= 4.0 && fatigue < 3.0 {
            suggestions.append(Suggestion(
                title: "Cuida tu cuerpo ahora",
                detail: "El dolor está alto. Prueba con calor local, estiramiento suave o simplemente cambiar de postura.",
                emoji: "🩹",
                category: .selfCare,
                urgency: .strong
            ))
        }

        // Buen momento general
        if fatigue <= 2.0 && pain <= 2.0 && wellbeing >= 4.0 {
            suggestions.append(Suggestion(
                title: "¡Te sientes muy bien ahora!",
                detail: "Este es uno de tus mejores momentos del día. ¡Aprovéchalo para algo que te guste o te importe!",
                emoji: "✨",
                category: .productivity,
                urgency: .moderate
            ))
        }

        // Estado neutral con bienestar bueno
        if fatigue <= 3.0 && pain <= 2.0 && wellbeing >= 3.5 {
            suggestions.append(Suggestion(
                title: "Momento tranquilo disponible",
                detail: "No estás al 100%, pero tampoco mal. Buen momento para actividades ligeras o creativas.",
                emoji: "🎨",
                category: .lightActivity,
                urgency: .gentle
            ))
        }

        // Hora de siesta natural (1–3pm)
        if (13...15).contains(ctx.currentHour) && fatigue >= 3.0 {
            suggestions.append(Suggestion(
                title: "La siesta de la tarde te espera",
                detail: "Tu cuerpo naturalmente baja el ritmo a esta hora. Un descanso de 15–20 min puede revitalizarte.",
                emoji: "☀️",
                category: .rest,
                urgency: .moderate
            ))
        }

        // Noche tardía con fatiga media
        if ctx.currentHour >= 22 && fatigue >= 3.0 {
            suggestions.append(Suggestion(
                title: "Tu cuerpo pide descanso nocturno",
                detail: "Es tarde y ya estás cansado/a. Considera prepararte para dormir pronto.",
                emoji: "🌙",
                category: .rest,
                urgency: .moderate
            ))
        }

        return suggestions
    }

    // MARK: - Sugerencias basadas en predicción de las próximas horas

    private func suggestionsForUpcomingHours(_ ctx: SuggestionContext) -> [Suggestion] {
        var suggestions: [Suggestion] = []
        let predictions = ctx.insight.allPredictions

        // Buscar la próxima buena ventana (dentro de las próximas 4 horas)
        let upcomingGoodHours = predictions
            .filter { $0.hour > ctx.currentHour && $0.hour <= ctx.currentHour + 4 }
            .filter { $0.isGoodHour }

        if let nextGood = upcomingGoodHours.first {
            suggestions.append(Suggestion(
                title: "Buena ventana se acerca a las \(formatHour(nextGood.hour))",
                detail: "Según tu patrón, en un par de horas te sentirás mejor. Guarda algo de energía para ese momento.",
                emoji: "🔆",
                category: .productivity,
                urgency: .gentle
            ))
        }

        // Advertir sobre la próxima hora difícil
        let upcomingBadHours = predictions
            .filter { $0.hour > ctx.currentHour && $0.hour <= ctx.currentHour + 3 }
            .filter { $0.isBadHour }

        if let nextBad = upcomingBadHours.first, ctx.currentFatigue < 3.5 {
            suggestions.append(Suggestion(
                title: "Prepárate para las \(formatHour(nextBad.hour))",
                detail: "Tu historial indica que esta hora suele ser más difícil. Aprovecha que ahora te sientes mejor.",
                emoji: "⏰",
                category: .selfCare,
                urgency: .gentle
            ))
        }

        // Mostrar la mejor hora del día si aún no ha pasado
        let peakHour = ctx.insight.peakEnergyHour
        if peakHour > ctx.currentHour {
            suggestions.append(Suggestion(
                title: "Tu mejor hora: \(formatHour(peakHour))",
                detail: "Esa suele ser tu hora pico de energía. Ideal para tareas que requieran más de ti.",
                emoji: "⚡️",
                category: .productivity,
                urgency: .gentle
            ))
        }

        return suggestions
    }

    // MARK: - Sugerencias basadas en tendencia reciente

    private func trendBasedSuggestions(_ ctx: SuggestionContext) -> [Suggestion] {
        switch ctx.recentTrend {
        case .worsening:
            return [Suggestion(
                title: "Has tenido un día difícil",
                detail: "Tus últimas entradas muestran que has empeorado. Prioriza el descanso sobre cualquier otra cosa.",
                emoji: "💙",
                category: .rest,
                urgency: .moderate
            )]
        case .improving:
            return [Suggestion(
                title: "¡Vas mejorando!",
                detail: "Tu tendencia reciente es positiva. Mantén el ritmo suave y sigue escuchando a tu cuerpo.",
                emoji: "📈",
                category: .lightActivity,
                urgency: .gentle
            )]
        case .stable:
            return []
        }
    }

    // MARK: - Calcular tendencia

    private func calculateTrend(from entries: [DiaryEntry]) -> Trend {
        guard entries.count >= 3 else { return .stable }

        // Comparar el promedio de las últimas 2 vs las 2 anteriores
        let recent   = entries.prefix(2).map { Double($0.fatigueLevel + $0.painLevel) }
        let previous = entries.dropFirst(2).prefix(2).map { Double($0.fatigueLevel + $0.painLevel) }

        let recentAvg   = recent.reduce(0, +) / Double(recent.count)
        let previousAvg = previous.reduce(0, +) / Double(previous.count)

        let delta = recentAvg - previousAvg

        if delta > 0.7 {
            return .worsening
        } else if delta < -0.7 {
            return .improving
        } else {
            return .stable
        }
    }

    // MARK: - Helpers

    private func formatHour(_ hour: Int) -> String {
        let formatted = hour % 12 == 0 ? 12 : hour % 12
        let period    = hour < 12 ? "am" : "pm"
        return "\(formatted)\(period)"
    }
}

// MARK: - Urgency priority helper

private extension SuggestionUrgency {
    var priority: Int {
        switch self {
        case .strong:   return 3
        case .moderate: return 2
        case .gentle:   return 1
        }
    }
}

extension Suggestion {
    var urgencyLabel: String {
        switch urgency {
        case .strong:   return "Ahora mismo"
        case .moderate: return "En los próximos minutos"
        case .gentle:   return "Cuando puedas"
        }
    }
}
