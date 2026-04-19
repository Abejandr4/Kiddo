import SwiftUI
import SwiftData

struct DiarioHijo: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var suggestions: [Suggestion] = []

    var body: some View {
        VStack {
            if let first = suggestions.first {
                PersonalizedSuggestionView(suggestion: first)
            }

            DiaryView()
        }
        .task {
            await loadSuggestions()
        }
    }

    private func loadSuggestions() async {
        do {
            let entries = try dataManager.fetchAll()
            guard !entries.isEmpty else { return }

            // Usar fallback heurístico hasta tener modelo entrenado
            let averages = try dataManager.averagesByHour()
            let insight  = PredictionEngine.shared.generateHeuristicInsight(averagesByHour: averages)

            guard let context = SuggestionEngine.shared.buildContext(
                recentEntries: entries,
                insight: insight
            ) else { return }

            suggestions = SuggestionEngine.shared.suggestions(for: context)

        } catch {
            print("Error cargando sugerencias: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryEntry.self, configurations: config)
    
    return DiarioHijo()
        .environmentObject(DataManager(modelContext: container.mainContext))
        .modelContainer(container)
}
