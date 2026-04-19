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
                    DatePicker("Fecha y Hora", selection: $selectedDate)
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        // El título será el nombre de la medicina + emoji, o el título personalizado
        let finalTitle = type == .medication ? "\(selectedMedication?.emoji ?? "") \(selectedMedication?.name ?? "")" : customTitle
        
        let newEvent = CalendarEvent(
            title: finalTitle,
            type: type,
            date: selectedDate,
            startTime: formatter.string(from: selectedDate),
            endTime: nil,
            description: notes.isEmpty ? selectedMedication?.description : notes,
            color: type == .medication ? .blue : .orange
        )
        
        events.append(newEvent)
        dismiss()
    }
}
