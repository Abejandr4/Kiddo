import SwiftUI

struct PersonalizedSuggestionView: View {
    let tip: AISuggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Título de la sección
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Sugerencia Personalizada")
                    .font(.system(.body, design: .rounded)).bold()
            }
            
            // Tarjeta de contenido
            HStack(alignment: .top, spacing: 15) {
                Text(tip.icon)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(tip.title)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                    
                    Text(tip.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true) // Evita que se corte el texto
                    
                    HStack {
                        Image(systemName: "timer")
                        Text(tip.time)
                    }
                    .font(.caption)
                    .foregroundColor(Color(red: 0.48, green: 0.78, blue: 0.49))
                    .padding(.top, 4)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.91, green: 0.96, blue: 0.91), Color(red: 0.95, green: 0.97, blue: 0.91)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}
