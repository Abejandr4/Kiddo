
import SwiftUI


struct MedicationCard: View {
    let medication: Medication
    let onLearnMore: () -> Void
    
    // Colores exactos basados en la imagen
    let titleColor = Color(red: 45/255, green: 55/255, blue: 72/255)
    let subtitleColor = Color(red: 113/255, green: 128/255, blue: 150/255)
    
    // Colores del gradiente del botón
    let gradientStart = Color(red: 135/255, green: 206/255, blue: 235/255)
    let gradientEnd = Color(red: 180/255, green: 167/255, blue: 214/255)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 18) {
                // Imagen/Emoji 3D
                if let emoji = medication.emoji {
                    Text(emoji)
                        .font(.system(size: 60))
                        .padding(.top, 4)
                }
                VStack(alignment: .leading, spacing: 6) {
                    // Título y Subtítulo
                    Text(medication.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(titleColor)
                    
                    Text(medication.genericName)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(subtitleColor)
                    
                    // Info de tiempo y dosis
                    VStack(alignment: .leading, spacing: 8) {
                        if let time = medication.time {
                            Label(time, systemImage: "clock")
                        }
                        if let dose = medication.dose {
                            Label(dose, systemImage: "pill")
                        }
                    }
                    .font(.system(size: 17, weight: .medium, design: .rounded))
                    .foregroundColor(titleColor.opacity(0.8))
                    .padding(.top, 4)
                }
            }
            
            // Botón con Gradiente Cápsula
            Button(action: onLearnMore) {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 20, weight: .medium))
                    
                    Text("Aprender más")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 22)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [gradientStart.opacity(0.8), gradientEnd.opacity(0.8)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .clipShape(Capsule()) // Forma de cápsula exacta a la imagen
            }
            .padding(.top, 8)
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(45) // Esquinas muy redondeadas
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
    }
}
