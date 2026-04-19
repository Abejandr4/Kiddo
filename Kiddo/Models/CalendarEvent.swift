import Foundation
import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID() // Esto ayuda a SwiftUI a identificar cada evento único
    var title: String
    var type: EventType
    var date: Date
    var startTime: String
    var endTime: String?
    var description: String?
    var color: Color
    
    // El enum se declara DENTRO del struct
    enum EventType: String, CaseIterable {
        case medication = "Medicamento"
        case appointment = "Cita Médica"
    }
}

