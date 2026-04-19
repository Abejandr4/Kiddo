import SwiftUI

struct PersonalizedSuggestionView: View {
    let suggestion: Suggestion  // ← cambia AISuggestion por Suggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("Sugerencia Personalizada")
                    .font(.system(.body, design: .rounded)).bold()
            }
            
            HStack(alignment: .top, spacing: 15) {
                Text(suggestion.emoji)          // ← tip.icon → suggestion.emoji
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(suggestion.title)      // ← igual
                        .font(.headline)
                        .foregroundColor(Color(red: 0.18, green: 0.22, blue: 0.28))
                    
                    Text(suggestion.detail)     // ← tip.description → suggestion.detail
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Image(systemName: "timer")
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

#Preview {
    PersonalizedSuggestionView(suggestion: Suggestion(
        title: "Tómatelo con calma",
        detail: "Tu cuerpo está pidiendo descanso ahora mismo.",
        emoji: "🛋️",
        category: .rest,
        urgency: .strong
    ))
}
