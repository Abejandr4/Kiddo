import Foundation
import SwiftData
import SwiftUI

@Model
class CalendarEvent {
    var id: UUID = UUID()
    var title: String
    var typeRawValue: String
    var date: Date
    var startTime: String
    var endTime: String?
    var eventDescription: String?
    var hexColor: String
    var isTaken: Bool = false
    
    
    @Transient
    var type: EventType {
        get { EventType(rawValue: typeRawValue) ?? .medication }
        set { typeRawValue = newValue.rawValue }
    }
    
    enum EventType: String, Codable, CaseIterable {
        case medication = "Medicamento"
        case appointment = "Cita Médica"
    }
    
    init(title: String, type: EventType, date: Date, startTime: String, endTime: String? = nil, eventDescription: String? = nil, hexColor: String = "87CEEB", isTaken: Bool = false) {
        self.title = title
        self.typeRawValue = type.rawValue
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.eventDescription = eventDescription
        self.hexColor = hexColor
        self.isTaken = isTaken
    }
}

