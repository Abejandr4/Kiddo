import Foundation

enum RecipientType {
    case child   // sugerencias para el niño
    case parent  // sugerencias para el padre/tutor
}

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


    /// Genera sugerencias personalizadas en base al contexto actual del usuario.
    func suggestions(for context: SuggestionContext, recipient: RecipientType = .child) -> [Suggestion] {
        var result: [Suggestion] = []

        result += suggestionsForCurrentState(context, recipient: recipient)
        result += suggestionsForUpcomingHours(context, recipient: recipient)
        result += trendBasedSuggestions(context, recipient: recipient)

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

    private func suggestionsForCurrentState(_ ctx: SuggestionContext, recipient: RecipientType) -> [Suggestion] {
        var suggestions: [Suggestion] = []
        let fatigue   = ctx.currentFatigue
        let pain      = ctx.currentPain
        let wellbeing = ctx.currentWellbeing

        if fatigue >= 4.0 && pain >= 4.0 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Hoy tu cuerpo necesita descanso 💙"
                    : "Tu pequeño necesita descansar hoy 💙",
                detail: recipient == .child
                    ? "Está bien no estar bien. Tu cuerpo está trabajando muy duro y merece un descanso. Recuéstate un ratito y respira tranquilo."
                    : "Su cuerpo está trabajando muy duro. Ayúdalo a encontrar un lugar cómodo para descansar y hazle saber que está bien tomarse una pausa.",
                emoji: "🛋️",
                category: .rest,
                urgency: .strong
            ))
        }

        if fatigue >= 4.0 && pain < 3.0 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Los superhéroes también descansan"
                    : "Tu héroe necesita recargar energía",
                detail: recipient == .child
                    ? "Hasta los más valientes necesitan recargar energía. Una siesta corta de 20 minutos te hará sentir mucho mejor, ¡te lo prometemos!"
                    : "Tu niño está bastante agotado. Una siesta de 20 minutos puede hacer una gran diferencia. Es buen momento para crear un ambiente tranquilo en casa.",
                emoji: "😴",
                category: .rest,
                urgency: .strong
            ))
        }

        if pain >= 4.0 && fatigue < 3.0 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Sabemos que duele, y está bien decirlo"
                    : "Tu niño tiene dolor elevado ahora",
                detail: recipient == .child
                    ? "No tienes que aguantar solo. Cuéntale a alguien de confianza cómo te sientes. Mientras tanto, intenta cambiar de postura o poner algo calientito donde duela."
                    : "Es un buen momento para preguntarle cómo se siente y ofrecerle consuelo. Calor local o un cambio de postura pueden ayudar. Si persiste, considera contactar a su médico.",
                emoji: "🩹",
                category: .selfCare,
                urgency: .strong
            ))
        }

        if fatigue <= 2.0 && pain <= 2.0 && wellbeing >= 4.0 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "¡Hoy te ves con mucha energía! ⚡️"
                    : "¡Tu niño está con mucha energía hoy! ⚡️",
                detail: recipient == .child
                    ? "Tu cuerpo está contento ahora mismo. ¡Aprovecha para hacer algo que te encante — jugar, dibujar, lo que tú quieras!"
                    : "Este es uno de sus mejores momentos del día. Ideal para hacer algo juntos — salir a caminar, jugar, o simplemente disfrutar su buena energía.",
                emoji: "✨",
                category: .productivity,
                urgency: .moderate
            ))
        }

        if fatigue <= 3.0 && pain <= 2.0 && wellbeing >= 3.5 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Un momento tranquilo para ti"
                    : "Buen momento para actividades ligeras",
                detail: recipient == .child
                    ? "No estás al 100% pero tampoco mal. Qué tal si haces algo que te relaje, como escuchar música, colorear o ver tu serie favorita."
                    : "Tu niño no está al 100% pero se encuentra estable. Actividades tranquilas como leer juntos, ver una película o colorear son ideales ahora.",
                emoji: "🎨",
                category: .lightActivity,
                urgency: .gentle
            ))
        }

        if (13...15).contains(ctx.currentHour) && fatigue >= 3.0 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "La hora mágica de la siesta ☀️"
                    : "Hora ideal para que descanse",
                detail: recipient == .child
                    ? "A esta hora el cuerpo de casi todos baja el ritmo, ¡no solo el tuyo! Una siestita de 15-20 minutos puede hacer magia."
                    : "A esta hora su energía naturalmente baja. Si es posible, ayúdalo a tomar una siesta corta de 15-20 minutos en un lugar tranquilo.",
                emoji: "☀️",
                category: .rest,
                urgency: .moderate
            ))
        }

        if ctx.currentHour >= 22 && fatigue >= 3.0 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Es hora de darle las buenas noches a tu cuerpo"
                    : "Tu niño debería estar descansando ya",
                detail: recipient == .child
                    ? "Ya hiciste mucho hoy, ¡eres increíble! Prepárate para dormir y mañana será un nuevo día lleno de posibilidades."
                    : "Es tarde y su nivel de fatiga es alto. Iniciar la rutina de dormir ahora le ayudará a descansar mejor esta noche.",
                emoji: "🌙",
                category: .rest,
                urgency: .moderate
            ))
        }

        return suggestions
    }

    private func suggestionsForUpcomingHours(_ ctx: SuggestionContext, recipient: RecipientType) -> [Suggestion] {
        var suggestions: [Suggestion] = []
        let predictions = ctx.insight.allPredictions

        let upcomingGoodHours = predictions
            .filter { $0.hour > ctx.currentHour && $0.hour <= ctx.currentHour + 4 }
            .filter { $0.isGoodHour }

        if let nextGood = upcomingGoodHours.first {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "¡Se viene un buen momento a las \(formatHour(nextGood.hour))!"
                    : "Ventana de energía a las \(formatHour(nextGood.hour))",
                detail: recipient == .child
                    ? "Según tu historial, en un par de horas te vas a sentir mejor. Guarda un poco de energía para ese momento y úsala en algo que disfrutes."
                    : "Según el historial de tu niño, debería sentirse mejor alrededor de las \(formatHour(nextGood.hour)). Puedes planear algo especial para ese momento.",
                emoji: "🔆",
                category: .productivity,
                urgency: .gentle
            ))
        }

        let upcomingBadHours = predictions
            .filter { $0.hour > ctx.currentHour && $0.hour <= ctx.currentHour + 3 }
            .filter { $0.isBadHour }

        if let nextBad = upcomingBadHours.first, ctx.currentFatigue < 3.5 {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Aprovecha que te sientes bien ahora"
                    : "Prepara a tu niño para las \(formatHour(nextBad.hour))",
                detail: recipient == .child
                    ? "A las \(formatHour(nextBad.hour)) tu cuerpo suele cansarse más. Haz algo padre ahorita que tienes energía, y luego descansas sin culpa."
                    : "Su historial indica que alrededor de las \(formatHour(nextBad.hour)) suele tener más fatiga o dolor. Considera tener lista una actividad tranquila para ese momento.",
                emoji: "⏰",
                category: .selfCare,
                urgency: .gentle
            ))
        }

        let peakHour = ctx.insight.peakEnergyHour
        if peakHour > ctx.currentHour {
            suggestions.append(Suggestion(
                title: recipient == .child
                    ? "Tu momento estrella es a las \(formatHour(peakHour)) ⭐️"
                    : "Mejor hora de tu niño: \(formatHour(peakHour)) ⭐️",
                detail: recipient == .child
                    ? "Esa es tu hora pico según lo que has registrado. Guárdala para algo especial o para lo que más ganas tengas de hacer."
                    : "Esa es su hora de mayor energía según sus registros. Es el mejor momento para actividades que requieran más concentración o esfuerzo.",
                emoji: "⚡️",
                category: .productivity,
                urgency: .gentle
            ))
        }

        return suggestions
    }

    private func trendBasedSuggestions(_ ctx: SuggestionContext, recipient: RecipientType) -> [Suggestion] {
        switch ctx.recentTrend {
        case .worsening:
            return [Suggestion(
                title: recipient == .child
                    ? "Has tenido días difíciles, y eso es válido"
                    : "Tu niño ha tenido días difíciles",
                detail: recipient == .child
                    ? "Notamos que has estado luchando más de lo normal. No tienes que ser fuerte todo el tiempo. Descansa, pide ayuda si la necesitas, y recuerda que no estás solo."
                    : "Su tendencia reciente muestra más fatiga y dolor de lo habitual. Es buen momento para hablar con él, reforzar que puede expresar cómo se siente, y considerar comentarlo con su médico.",
                emoji: "💙",
                category: .rest,
                urgency: .moderate
            )]
        case .improving:
            return [Suggestion(
                title: recipient == .child
                    ? "¡Vas mejorando, campeón! 🏆"
                    : "¡Tu niño va mejorando! 🏆",
                detail: recipient == .child
                    ? "Tus últimas entradas muestran que te has sentido mejor. Eso es increíble. Sigue escuchando a tu cuerpo y celebra cada pequeño avance."
                    : "Su tendencia reciente es positiva — se ha sentido mejor en sus últimas entradas. Celebra este avance con él, los pequeños logros importan mucho.",
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
