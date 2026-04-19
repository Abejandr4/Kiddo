import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [CalendarEvent] // Recibe la lista del padre
    
    @State private var title = ""
    @State private var selectedDate = Date()
    @State private var description = ""
    @State private var type: CalendarEvent.EventType = .medication

    var body: some View {
        NavigationStack {
            Form {
                Section("Información") {
                    TextField("Nombre (ej. Paracetamol)", text: $title)
                    TextField("Dosis o Notas", text: $description)
                    Picker("Tipo", selection: $type) {
                        Text("Medicamento").tag(CalendarEvent.EventType.medication)
                        Text("Cita").tag(CalendarEvent.EventType.appointment)
                    }
                }
                
                Section("Horario") {
                    DatePicker("Fecha y Hora", selection: $selectedDate)
                }
            }
            .navigationTitle("Añadir Evento")
            .toolbar {
                Button("Guardar") {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    
                    let newEvent = CalendarEvent(
                        title: title,
                        type: type,
                        date: selectedDate,
                        startTime: formatter.string(from: selectedDate),
                        endTime: nil,
                        description: description,
                        color: type == .medication ? .blue : .orange
                    )
                    
                    events.append(newEvent)
                    dismiss()
                }
                .disabled(title.isEmpty)
            }
        }
    }
}
