import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var events: [CalendarEvent]
    
    // Estados para el formulario
    @State private var type: CalendarEvent.EventType = .medication
    @State private var selectedMedication: Medication?
    @State private var customTitle = ""
    @State private var selectedDate = Date()
    @State private var notes = ""
    @State private var searchText = ""
    
    // Configuración de repetición
    let daysOfWeek = ["Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"]
    @State private var selectedDays: Set<String> = []
    @State private var isRecurring = false
    
    // Colores para el degradado de fondo
    let startColor = Color(red: 0.53, green: 0.84, blue: 0.61).opacity(0.4)
    let endColor = Color(red: 0.55, green: 0.86, blue: 0.95).opacity(0.4)
    
    // Lista filtrada para la búsqueda
    var filteredMedications: [Medication] {
        if searchText.isEmpty {
            return medicationList
        } else {
            return medicationList.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // --- SOLUCIÓN ERROR 1: Definir medicationSearchList ---
    var medicationSearchList: some View {
        List {
            ForEach(filteredMedications) { medication in
                Button(action: {
                    self.selectedMedication = medication
                    // Al seleccionar, regresamos a la vista anterior
                }) {
                    HStack {
                        Text(medication.emoji ?? "💊")
                        VStack(alignment: .leading) {
                            Text(medication.name).font(.headline)
                            Text(medication.genericName).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        if selectedMedication?.id == medication.id {
                            Image(systemName: "checkmark.circle.fill").foregroundColor(.blue)
                        }
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .searchable(text: $searchText, prompt: "Buscar medicamento...")
        .navigationTitle("Seleccionar Medicina")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [startColor, endColor]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Form {
                    Section("Tipo de Registro") {
                        Picker("Tipo", selection: $type) {
                            Text("Medicamento").tag(CalendarEvent.EventType.medication)
                            Text("Cita Médica").tag(CalendarEvent.EventType.appointment)
                        }
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.white.opacity(0.6))
                    
                    if type == .medication {
                        Section("Selecciona el Medicamento") {
                            NavigationLink {
                                medicationSearchList
                            } label: {
                                HStack {
                                    Text("Medicina:")
                                    Spacer()
                                    Text(selectedMedication?.name ?? "Toca para elegir")
                                        .foregroundColor(selectedMedication == nil ? .gray : .blue)
                                }
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.6))
                    } else {
                        Section("Detalles de la Cita") {
                            TextField("¿A qué clínica o doctor vas?", text: $customTitle)
                        }
                        .listRowBackground(Color.white.opacity(0.6))
                    }
                    
                    Section("Programación") {
                        DatePicker("Fecha y Hora inicial", selection: $selectedDate)
                        
                        Toggle("Repetir semanalmente", isOn: $isRecurring)
                        
                        if isRecurring {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
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
                    .listRowBackground(Color.white.opacity(0.6))
                    
                    Section("Notas Adicionales") {
                        TextField("Dosis (ej. 1 tableta) o recordatorios", text: $notes)
                    }
                    .listRowBackground(Color.white.opacity(0.6))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Nuevo Registro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        saveEvent()
                    }
                    .fontWeight(.bold)
                    .disabled(type == .medication ? selectedMedication == nil : customTitle.isEmpty)
                }
            }
        }
    }
    
    // --- SOLUCIÓN ERROR 2: Implementar saveEvent() ---
    private func saveEvent() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: selectedDate)
        
        let title = type == .medication ? (selectedMedication?.name ?? "Medicamento") : customTitle
        
        // 1. Crear el evento principal (el del día seleccionado)
        let mainEvent = CalendarEvent(
            title: title,
            type: type,
            date: selectedDate,
            startTime: timeString,
            endTime: nil,
            description: notes.isEmpty ? nil : notes,
            color: type == .medication ? .blue : .green
        )
        events.append(mainEvent)
        
        // 2. Si es recurrente, calculamos las repeticiones
        if isRecurring && !selectedDays.isEmpty {
            let calendar = Calendar.current
            // Mapeo de tus abreviaturas a números de día de la semana de Swift (1 = Dom, 2 = Lun...)
            let dayMapping: [String: Int] = [
                "Dom": 1, "Lun": 2, "Mar": 3, "Mié": 4, "Jue": 5, "Vie": 6, "Sáb": 7
            ]
            
            // Convertimos tus "Lun", "Mar" a números (2, 3...)
            let targetDays = selectedDays.compactMap { dayMapping[$0] }
            
            // Calculamos repeticiones para las próximas 4 semanas (puedes aumentar este número)
            for weekOffset in 0..<4 {
                for dayOfWeek in targetDays {
                    // Buscamos la fecha que corresponde a ese día de la semana en esa semana específica
                    var components = DateComponents()
                    components.weekday = dayOfWeek
                    components.weekOfYear = calendar.component(.weekOfYear, from: selectedDate) + weekOffset
                    components.year = calendar.component(.year, from: selectedDate)
                    
                    if let recurringDate = calendar.nextDate(after: calendar.startOfDay(for: selectedDate).addingTimeInterval(-1), matching: components, matchingPolicy: .nextTime) {
                        
                        // Evitamos duplicar el evento principal si cae en el mismo día y hora
                        if calendar.isDate(recurringDate, inSameDayAs: selectedDate) { continue }
                        
                        let recurringEvent = CalendarEvent(
                            title: title,
                            type: type,
                            date: recurringDate,
                            startTime: timeString,
                            endTime: nil,
                            description: notes,
                            color: type == .medication ? .blue : .green
                        )
                        events.append(recurringEvent)
                    }
                }
            }
        }
        
        dismiss()
    }
}
