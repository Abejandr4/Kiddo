import SwiftUI

struct DiarioHijo: View {
    // 1. El Estado: Aquí se guardará lo que genere la IA
    @State private var aiTip: AISuggestion?
    @State private var isAnalyzing = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // 2. Llamada a la vista de sugerencia
                if isAnalyzing {
                    ProgressView("Apple Intelligence analizando...")
                        .padding()
                } else if let tip = aiTip {
                    PersonalizedSuggestionView(tip: tip)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                
                // Tu vista del diario
                DiaryView()
            }
        }
        // 3. Disparador: Cuando la vista aparece, ejecutamos la IA
        .task {
            await generateAISuggestion()
        }
    }
    
    // 4. La Lógica de Apple Intelligence
    func generateAISuggestion() async {
        isAnalyzing = true
        
        // Simulamos el delay del LanguageModel
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)
        
        // AQUÍ es donde integrarías el LanguageModel de iOS 18+
        // let response = try? await LanguageModel.shared.generate(...)
        
        let mockResult = AISuggestion(
            icon: "⚡️",
            title: "Recarga de Energía",
            description: "He notado que los jueves tu energía baja. Intenta un descanso corto a las 4 PM.",
            time: "Hoy mismo"
        )
        
        withAnimation {
            self.aiTip = mockResult
            isAnalyzing = false
        }
    }
}

#Preview {
    DiarioHijo()
}
