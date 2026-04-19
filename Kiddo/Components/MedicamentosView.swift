import SwiftUI
struct MedicamentosView: View {
    // 1. Recibimos la lista de eventos del calendario para filtrar
    @Binding var calendarEvents: [CalendarEvent]
    
    @State private var selectedMedication: Medication? = nil
    
    // 2. Filtro: Solo muestra medicinas que han sido agregadas a la agenda
    var filteredMedications: [Medication] {
        medicationList.filter { med in
            calendarEvents.contains { event in
                // Comprobamos si el nombre de la medicina está dentro del título del evento
                event.title.localizedCaseInsensitiveContains(med.name)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header
                HStack(spacing: 12) {
                    Image(systemName: "pill.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "87CEEB"))
                    
                    Text("Mis Medicinas")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color(hex: "2D3748"))
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // MARK: - Medications List
                VStack(spacing: 16) {
                    if filteredMedications.isEmpty {
                        // Estado vacío
                        VStack(spacing: 20) {
                            Image(systemName: "calendar.badge.plus")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                            
                            Text("No hay medicinas programadas")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text("Agrega medicamentos en 'Mi Agenda' para ver su información detallada aquí.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 60)
                    } else {
                        ForEach(filteredMedications) { med in
                            MedicamentoRowView(medication: med) {
                                selectedMedication = med
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Info Card
                ImportantInfoCardView()
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(hex: "F7FAFC").edgesIgnoringSafeArea(.all))
        
        // MARK: - Detail Sheet
        .sheet(item: $selectedMedication) { med in
            MedicationInfoCard(medication: med) {
                selectedMedication = nil
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}
// MARK: - Sub-Componentes Visuales
private struct MedicamentoRowView: View {
    let medication: Medication
    let onLearnMore: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Icono/Emoji
            Text(medication.emoji ?? "💊")
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(Color(hex: "F7FAFC"))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(medication.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "2D3748"))
                    
                    Text(medication.genericName)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "718096"))
                        .italic()
                }
                
                // Botón de Acción
                Button(action: onLearnMore) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Aprender más")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "87CEEB"), Color(hex: "B4A7D6")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: "87CEEB").opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.top, 8)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
private struct ImportantInfoCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 24))
                Text("Nota de Seguridad")
                    .font(.system(size: 20, weight: .semibold))
            }
            
            Text("Esta información es educativa. Si notas efectos secundarios no listados o te sientes mal, contacta a tu médico inmediatamente.")
                .font(.system(size: 15))
                .lineSpacing(4)
        }
        .foregroundColor(.white)
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "B4A7D6"), Color(hex: "FFB366")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(24)
        .shadow(color: Color(hex: "B4A7D6").opacity(0.3), radius: 10, x: 0, y: 5)
    }
}
struct MedicamentosView_Previews: PreviewProvider {
    static var previews: some View {
        MedicamentosView(calendarEvents: .constant([
            CalendarEvent(
                title: "Tomar Ibuprofeno",
                // 1. Cambiamos el String por el caso del Enum (ajusta .medication si tiene otro nombre)
                type: .medication,
                date: Date(),
                // 2. Cambiamos Date() por un String
                startTime: "08:00",
                endTime: "08:30",
                description: "Dosis matutina",
                color: .blue
            )
        ]))
    }
}

