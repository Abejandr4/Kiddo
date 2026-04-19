import Foundation
import SwiftData

@Model
final class DiaryEntry {
    var id: UUID
    var timestamp: Date
    var fatigueLevel: Int
    var painLevel: Int
    var wellbeingRaw: String   // ← guardamos el rawValue del enum, no el enum directo

    // Propiedad computada para acceder al enum — @Transient la excluye de SwiftData
    @Transient
    var wellbeing: Wellbeing {
        get { Wellbeing(rawValue: wellbeingRaw) ?? .neutral }
        set { wellbeingRaw = newValue.rawValue }
    }

    init(fatigueLevel: Int, painLevel: Int, wellbeing: Wellbeing, timestamp: Date = .now) {
        self.id = UUID()
        self.timestamp = timestamp
        self.fatigueLevel = fatigueLevel
        self.painLevel = painLevel
        self.wellbeingRaw = wellbeing.rawValue
    }
}

// MARK: - Computed properties para ML (fuera del @Model, en extension)
// Ponerlas en extension evita que SwiftData intente persistirlas

extension DiaryEntry {
    var hour: Double {
        Double(Calendar.current.component(.hour, from: timestamp))
    }

    var dayOfWeek: Double {
        Double(Calendar.current.component(.weekday, from: timestamp))
    }

    var wellbeingScore: Double {
        wellbeing.numericValue
    }
}

// MARK: - Wellbeing Enum

enum Wellbeing: String, Codable, CaseIterable {
    case veryGood = "Muy bien"
    case good     = "Bien"
    case neutral  = "Regular"
    case bad      = "Mal"
    case veryBad  = "Muy mal"

    var numericValue: Double {
        switch self {
        case .veryGood: return 5.0
        case .good:     return 4.0
        case .neutral:  return 3.0
        case .bad:      return 2.0
        case .veryBad:  return 1.0
        }
    }

    var emoji: String {
        switch self {
        case .veryGood: return "😄"
        case .good:     return "🙂"
        case .neutral:  return "😐"
        case .bad:      return "😔"
        case .veryBad:  return "😞"
        }
    }
}
