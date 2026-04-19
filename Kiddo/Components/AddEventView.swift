import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [CalendarEvent]
    
    // Estados para el formulario
    @State private var type: CalendarEvent.EventType = .medication
    @State private var selectedMedication: Medication? // Medicina seleccionada
    @State private var customTitle = "" // Para citas médicas
    @State private var selectedDate = Date()
    @State private var notes = ""
    @State private var searchText = "" // Para el buscador
    
    // Dentro de AddEventView
    let daysOfWeek = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"]
    @State private var selectedDays: Set<String> = [] // Guarda los días seleccionados
    @State private var isRecurring = false // Switch para activar repetición
    
    // Filtrar la lista de medicinas según lo que escriba el usuario
    var filteredMedications: [Medication] {
        if searchText.isEmpty {
            return medicationList
        } else {
            return medicationList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Tipo de Registro") {
                    Picker("Tipo", selection: $type) {
                        Text("Medicamento").tag(CalendarEvent.EventType.medication)
                        Text("Cita Médica").tag(CalendarEvent.EventType.appointment)
                    }
                    .pickerStyle(.segmented)
                }
                
                if type == .medication {
                    Section("Selecciona el Medicamento") {
                        NavigationLink {
                            // Pantalla de búsqueda de medicinas
                            List {
                                ForEach(filteredMedications) { med in
                                    Button {
                                        selectedMedication = med
                                    } label: {
                                        HStack {
                                            Text(med.emoji ?? "💊")
                                            VStack(alignment: .leading) {
                                                Text(med.name).font(.headline)
                                                Text(med.genericName).font(.caption).foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            if selectedMedication?.id == med.id {
                                                Image(systemName: "checkmark").foregroundColor(.blue)
                                            }
                                        }
                                    }
                                    .foregroundColor(.primary)
                                }
                            }
                            .navigationTitle("Buscar Medicina")
                            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
                        } label: {
                            HStack {
                                Text("Medicina:")
                                Spacer()
                                Text(selectedMedication?.name ?? "Toca para elegir")
                                    .foregroundColor(selectedMedication == nil ? .gray : .blue)
                            }
                        }
                    }
                } else {
                    Section("Detalles de la Cita") {
                        TextField("¿A qué clínica o doctor vas?", text: $customTitle)
                    }
                }
                
                Section("Programación") {
                    DatePicker("Fecha y Hora inicial", selection: $selectedDate)
                    
                    Toggle("Repetir semanalmente", isOn: $isRecurring)
                    
                    if isRecurring {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer()
                                HStack(spacing: 10) { // Un contenedor centrado
                                    ForEach(daysOfWeek, id: \.self) { day in
                                        Text(day)
                                            .font(.subheadline)
                                            .fontWeight(selectedDays.contains(day) ? .bold : .regular)
                                            .padding(10)
                                            .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                                            .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                if selectedDays.contains(day) {
                                                    selectedDays.remove(day)
                                                } else {
                                                    selectedDays.insert(day)
                                                }
                                            }
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
                
                Section("Notas Adicionales") {
                    TextField("Dosis (ej. 1 tableta) o recordatorios", text: $notes)
                }
            }
            .navigationTitle("Nuevo Registro")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveEvent()
                    }
                    .disabled(type == .medication ? selectedMedication == nil : customTitle.isEmpty)
                }
            }
        }
    }
    
    // Función auxiliar para cerrar la navegación de búsqueda
    @Environment(\.dismiss) var dismissSearch
    
    private func saveEvent() {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let finalTitle = type == .medication ? "\(selectedMedication?.emoji ?? "") \(selectedMedication?.name ?? "")" : customTitle
        let formattedTime = formatter.string(from: selectedDate)
        
        // Diccionario para convertir tus strings a números de día de la semana
        let dayMapping: [String: Int] = [
            "Dom": 1, "Lun": 2, "Mar": 3, "Mié": 4, "Jue": 5, "Vie": 6, "Sáb": 7
        ]
        
        if isRecurring && !selectedDays.isEmpty {
            for dayName in selectedDays {
                guard let weekdayTarget = dayMapping[dayName] else { continue }
                
                var components = DateComponents()
                components.weekday = weekdayTarget
                
                // 1. Buscar la fecha correcta para ese día
                if let firstDate = calendar.nextDate(after: selectedDate.addingTimeInterval(-1),
                                                     matching: components,
                                                     matchingPolicy: .nextTime) {
                    
                    for weekOffset in 0..<4 {
                        if let dateForWeek = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: firstDate) {
                            
                            // 🔒 CANDADO: Evita que el mismo medicamento se guarde dos veces el mismo día a la misma hora
                            let eventExists = events.contains { existingEvent in
                                existingEvent.title == finalTitle &&
                                Calendar.current.isDate(existingEvent.date, inSameDayAs: dateForWeek) &&
                                existingEvent.startTime == formattedTime
                            }
                            
                            if !eventExists {
                                let recurringEvent = CalendarEvent(
                                    title: finalTitle,
                                    type: type,
                                    date: dateForWeek,
                                    startTime: formattedTime,
                                    endTime: nil,
                                    description: notes.isEmpty ? selectedMedication?.description : notes,
                                    color: type == .medication ? .blue : .orange
                                )
                                events.append(recurringEvent)
                            }
                        }
                    }
                }
            }
        } else {
            // 🔒 CANDADO PARA EVENTO ÚNICO
            let eventExists = events.contains { existingEvent in
                existingEvent.title == finalTitle &&
                Calendar.current.isDate(existingEvent.date, inSameDayAs: selectedDate) &&
                existingEvent.startTime == formattedTime
            }
            
            if !eventExists {
                let newEvent = CalendarEvent(
                    title: finalTitle,
                    type: type,
                    date: selectedDate,
                    startTime: formattedTime,
                    endTime: nil,
                    description: notes.isEmpty ? selectedMedication?.description : notes,
                    color: type == .medication ? .blue : .orange
                )
                events.append(newEvent)
            }
        }
        
        dismiss()
    }
}
