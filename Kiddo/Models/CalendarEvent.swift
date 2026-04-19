import Foundation
import SwiftUI

struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let type: EventType
    let date: Date
    let startTime: String
    let endTime: String?
    let description: String?
    let color: Color
    
    enum EventType: String, CaseIterable {
        case medication = "Medicamento"
        case appointment = "Cita Médica"
    }
}
