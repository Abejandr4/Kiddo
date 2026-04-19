import SwiftUI

struct MedicationInfoCard: View {
    let medication: Medication
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // --- HEADER (Degradado con Título e Info) ---
            HStack(alignment: .center, spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 45, height: 45)
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(medication.name)
                        .font(.title2)
                        .bold()
                    Text(medication.genericName)
                        .font(.subheadline)
                        .opacity(0.9)
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
            }
            .padding(25)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.53, green: 0.81, blue: 0.92), Color(red: 0.71, green: 0.65, blue: 0.84)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            
            // --- CONTENIDO SCROLLABLE ---
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Sección: Descripción
                    VStack(alignment: .leading, spacing: 10) {
                        Text("¿Para qué sirve?")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                        
                        Text(medication.description)
                            .font(.body)
                            .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                            .lineSpacing(4)
                    }
                    
                    // Sección: Efectos Secundarios
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.4))
                            Text("Posibles efectos secundarios")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(medication.sideEffects, id: \.self) { effect in
                                HStack(alignment: .top, spacing: 10) {
                                    Text("•").foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.4))
                                    Text(effect)
                                        .font(.subheadline)
                                        .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 1.0, green: 0.98, blue: 0.9))
                        .cornerRadius(15)
                    }
                    
                    // Sección: Advertencias
                    if !medication.warnings.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "exclamationmark.shield.fill")
                                    .foregroundColor(.white)
                                    .padding(4)
                                    .background(Color(red: 1.0, green: 0.56, blue: 0.83))
                                    .clipShape(Circle())
                                
                                Text("Importante")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(medication.warnings, id: \.self) { warning in
                                    HStack(alignment: .top, spacing: 10) {
                                        Text("⚠️")
                                        Text(warning)
                                            .font(.subheadline)
                                            .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(red: 1.0, green: 0.9, blue: 0.94))
                            .cornerRadius(15)
                        }
                    }
                    
                    Text("**Nota:** Esta información es solo educativa. Siempre consulta con tu médico.")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.29, green: 0.33, blue: 0.41))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.91, green: 0.96, blue: 0.91))
                        .cornerRadius(15)
                }
                .padding(25)
            }
            
            // --- FOOTER ---
            VStack {
                Button("Entendido") {
                    onClose()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue) // O usa tu ActionButton personalizado aquí
                .cornerRadius(15)
                .padding(.bottom, 10)
            }
            .padding(20)
            .background(Color(red: 0.97, green: 0.98, blue: 0.99))
        }
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
        .padding()
    }
}

// --- PREVIEW CORREGIDO ---
struct MedicationInfoCard_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.3).ignoresSafeArea()
            
            MedicationInfoCard(
                medication: Medication(
                    name: "Paracetamol",
                    genericName: "Acetaminofén",
                    time: "8:00 AM", // Argumento faltante corregido
                    dose: "500 mg",  // Argumento faltante corregido
                    emoji: "💊",     // Argumento faltante corregido
                    description: "Se utiliza para el alivio del dolor.",
                    sideEffects: ["Náuseas"],
                    warnings: ["No exceder la dosis"]
                ),
                onClose: { print("Cerrar") }
            )
        }
    }
}
