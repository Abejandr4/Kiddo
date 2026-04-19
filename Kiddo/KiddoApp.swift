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
        ContentView()              // ← tu ContentView original sigue aquí adentro
            .environmentObject(DataManager(modelContext: modelContext))
    }
}
