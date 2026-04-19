import SwiftUI

struct MedicamentosView: View {
    // Usamos String para coincidir con tu SettingsView ("child" o "parent")
    let userType: String
    let avatarConfig: AvatarConfig
    
    @State private var selectedMedication: Medication? = nil
    
    // Instanciamos usando tu struct Medication de MedicationInfo.swift.
    // Nota: Ya no le pasamos el "id: 1" porque tu struct ahora genera un UUID() automáticamente.
    let medications: [Medication] = [
        Medication(
            name: "Prednisona", genericName: "Corticosteroide", time: "8:00 AM", dose: "10 mg (1 tableta)", emoji: "💊",
            description: "La prednisona es un corticosteroide que ayuda a reducir la inflamación en el cuerpo. Se usa para tratar diversos tipos de cáncer y reducir la inflamación asociada con la quimioterapia.",
            sideEffects: ["Aumento del apetito", "Cambios de humor o irritabilidad", "Dificultad para dormir", "Aumento de peso", "Retención de líquidos", "Dolor de estómago"],
            warnings: ["Tomar con alimentos para reducir molestias estomacales", "No suspender súbitamente sin consultar al médico", "Puede aumentar el nivel de azúcar en sangre"]
        ),
        Medication(
            name: "Ondansetrón", genericName: "Antiemético", time: "12:00 PM y 8:00 PM", dose: "4 mg (1 tableta)", emoji: "🌊",
            description: "El ondansetrón ayuda a prevenir las náuseas y vómitos causados por la quimioterapia. Funciona bloqueando las sustancias en el cuerpo que provocan náuseas.",
            sideEffects: ["Dolor de cabeza leve", "Mareos", "Estreñimiento", "Cansancio", "Sensación de calor o enrojecimiento"],
            warnings: ["Puede causar mareos, evita levantarte rápidamente", "Bebe suficiente agua para prevenir estreñimiento", "Informa si tienes latidos cardíacos irregulares"]
        ),
        Medication(
            name: "Ácido Fólico", genericName: "Suplemento vitamínico", time: "9:00 AM", dose: "1 mg (1 tableta)", emoji: "🍃",
            description: "El ácido fólico es una vitamina B que ayuda a tu cuerpo a producir células sanguíneas sanas. Es especialmente importante durante el tratamiento de leucemia.",
            sideEffects: ["Náuseas leves (poco común)", "Sabor amargo en la boca", "Dificultad para dormir (raro)", "Irritabilidad (raro)"],
            warnings: ["Tomar con un vaso lleno de agua", "Se puede tomar con o sin alimentos", "Es importante no saltarse las dosis"]
        ),
        Medication(
            name: "Metotrexato", genericName: "Antimetabolito", time: "6:00 PM (solo martes)", dose: "Según indicación médica", emoji: "💉",
            description: "El metotrexato es un medicamento de quimioterapia que ayuda a eliminar las células cancerosas. Se administra una vez por semana en un día específico.",
            sideEffects: ["Náuseas y vómitos", "Llagas en la boca", "Pérdida del apetito", "Cansancio extremo", "Mayor riesgo de infecciones", "Sensibilidad al sol"],
            warnings: ["IMPORTANTE: Solo tomar el día indicado por el médico", "Usar protector cuando estés al aire libre", "Avisar inmediatamente si tienes fiebre o señales de infección", "Evitar contacto con personas enfermas", "Beber mucha agua para ayudar a eliminar el medicamento"]
        )
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Título
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
                
                // Lista de Medicamentos
                VStack(spacing: 16) {
                    ForEach(medications) { med in
                        // Usamos una vista local para no tener conflictos con otros archivos
                        MedicamentoRowView(medication: med) {
                            selectedMedication = med
                        }
                    }
                }
                .padding(.horizontal)
                
                // Tarjeta de Información
                ImportantInfoCardView()
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(hex: "F7FAFC").edgesIgnoringSafeArea(.all)) // Fondo para hacer match con Configuración
        
        // Modal llamando a tu vista existente en MedicationInfo.swift
        .sheet(item: $selectedMedication) { med in
            MedicationInfoCard(medication: med) {
                selectedMedication = nil
            }
            // Para que parezca un modal redondeado como en tu diseño
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Componentes Locales (Para evitar conflictos con otras partes del proyecto)

private struct MedicamentoRowView: View {
    let medication: Medication
    let onLearnMore: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Text(medication.emoji ?? "💊")
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(medication.name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "2D3748"))
                    Text(medication.genericName)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "718096"))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                        .foregroundColor(Color(hex: "4A5568"))
                    Text(medication.time ?? "Sin horario")
                        .foregroundColor(Color(hex: "4A5568"))
                }
                .font(.system(size: 14))
                .padding(.top, 4)
                
                HStack(spacing: 6) {
                    Image(systemName: "pills.fill")
                        .foregroundColor(Color(hex: "718096"))
                    Text(medication.dose ?? "Sin dosis")
                        .foregroundColor(Color(hex: "718096"))
                }
                .font(.system(size: 14))
                
                Button(action: onLearnMore) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                        Text("Aprender más")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
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
                .padding(.top, 12)
            }
            Spacer()
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
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 24))
                Text("Información Importante")
                    .font(.system(size: 20, weight: .semibold))
            }
            
            Text("Toca \"Aprender más\" en cada medicina para conocer sus efectos secundarios y recomendaciones. Si experimentas algo inusual, informa a tu equipo médico de inmediato.")
                .font(.system(size: 15))
                .opacity(0.9)
                .lineSpacing(4)
        }
        .foregroundColor(.white)
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "B4A7D6"), Color(hex: "FFB366")]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(24)
        .shadow(color: Color(hex: "B4A7D6").opacity(0.4), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Preview
struct MedicamentosView_Previews: PreviewProvider {
    static var previews: some View {
        MedicamentosView(userType: "child", avatarConfig: AvatarConfig())
    }
}


