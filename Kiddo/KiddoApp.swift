import SwiftUI
import SwiftData

@main
struct KiddoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            DiaryEntry.self,   // ← cambia Item.self por DiaryEntry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()             // ← cambia ContentView por RootView
        }
        .modelContainer(sharedModelContainer)
    }
}

struct RootView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ContentView()
            .environmentObject(DataManager(modelContext: modelContext))
            .task {
                // Intenta cargar los modelos del bundle al arrancar
                try? PredictionEngine.shared.loadModels()
            }
            .task {
                try? PredictionEngine.shared.loadModels()
                print("Modelos cargados: \(PredictionEngine.shared.modelsLoaded)")
            }
    }
}

