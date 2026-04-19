import SwiftUI

// MARK: - Modelo de Datos
struct CalendarEvent: Identifiable {
    let id = UUID()
    let title: String
    let type: EventType
    let date: Date
    let startTime: String
    let endTime: String?
    let description: String?
    let color: Color
    
    enum EventType {
        case medication, appointment
    }
}

struct CalendarioView: View {
    @State private var selectedDate = Date()
    
    // Colores convertidos a RGB estándar (0.0 a 1.0)
    let themeYellow = Color(red: 249/255, green: 231/255, blue: 132/255)
    let themeGreen  = Color(red: 123/255, green: 198/255, blue: 126/255)
    let themeBlue   = Color(red: 135/255, green: 206/255, blue: 235/255)
    let themeOrange = Color(red: 255/255, green: 179/255, blue: 102/255)
    let themePurple = Color(red: 180/255, green: 167/255, blue: 214/255)

    var events: [CalendarEvent] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return [
            CalendarEvent(title: "Prednisona", type: .medication, date: today, startTime: "08:00", endTime: nil, description: "10 mg", color: themeBlue),
            CalendarEvent(title: "Cita Oncología", type: .appointment, date: today, startTime: "10:00", endTime: "11:00", description: "Dr. García - Revisión", color: themeOrange),
            CalendarEvent(title: "Ondansetrón", type: .medication, date: today, startTime: "12:00", endTime: nil, description: "4 mg", color: themeBlue),
            CalendarEvent(title: "Metotrexato", type: .medication, date: calendar.date(byAdding: .day, value: 1, to: today)!, startTime: "18:00", endTime: nil, description: "Quimio semanal", color: themePurple)
        ]
    }

    var filteredEvents: [CalendarEvent] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
            .sorted { $0.startTime < $1.startTime }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header con Icono y Título
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.title)
                        .foregroundColor(themeYellow)
                    Text("Mi Agenda")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding([.horizontal, .top])

                // Selector de días horizontal
                HStack(spacing: 10) {
                    ForEach(0..<7) { index in
                        let date = getDateFor(index: index)
                        DaySelectorItem(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            activeColor: themeGreen
                        ) {
                            withAnimation(.spring()) {
                                selectedDate = date
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)

            // Contenido del Día
            ScrollView {
                VStack(spacing: 16) {
                    if filteredEvents.isEmpty {
                        VStack(spacing: 20) {
                            Spacer(minLength: 50)
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundColor(themeYellow)
                            Text("¡Día libre de tareas!")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        ForEach(filteredEvents) { event in
                            EventRow(event: event)
                        }
                    }
                }
                .padding()
            }
            .background(Color(UIColor.secondarySystemBackground))
        }
    }

    func getDateFor(index: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return calendar.date(byAdding: .day, value: index, to: startOfWeek)!
    }
}

// MARK: - Componentes Visuales
struct DaySelectorItem: View {
    let date: Date
    let isSelected: Bool
    let activeColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(date.format("EEE").uppercased())
                    .font(.system(size: 10, weight: .bold))
                Text(date.format("d"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? activeColor : Color.clear)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct EventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Columna de hora
            VStack {
                Text(event.startTime)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 50)
            
            // Tarjeta de información
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label(event.title, systemImage: event.type == .medication ? "pill.fill" : "stethoscope")
                        .font(.headline)
                    Spacer()
                    if let end = event.endTime {
                        Text("Hasta \(end)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                if let desc = event.description {
                    Text(desc)
                        .font(.subheadline)
                        .opacity(0.85)
                }
            }
            .padding()
            .background(event.color)
            .foregroundColor(.white)
            .cornerRadius(18)
            .shadow(color: event.color.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Helpers
extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: self)
    }
}

// MARK: - Preview
#Preview {
    CalendarioView()
}
