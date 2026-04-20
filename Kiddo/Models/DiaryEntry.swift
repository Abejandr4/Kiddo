import Foundation
import SwiftData

@Model
final class DiaryEntry {
    var id: UUID
    var timestamp: Date
    var villains: [String] = []
    var fatigueLevel: Int
    var painLevel: Int
    var wellbeingRaw: String

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

// MARK: - Extension para ML y Lógica de Negocio
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

    // Esta propiedad busca el archivo en tus Assets
    var imageName: String {
        switch self {
        case .veryGood: return "Muy_bien"
        case .good:     return "Bien"
        case .neutral:  return "Meh"
        case .bad:      return "Mal"
        case .veryBad:  return "Muy_mal"
        }
    }
}

