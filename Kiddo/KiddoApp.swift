import SwiftUI
import SwiftData

@main
struct KiddoApp: App {
    init() {
            NotificationManager.shared.requestPermission()
            UNUserNotificationCenter.current().delegate = NotificationDelegate.shared 
        }
    
    var sharedModelContainer: ModelContainer = {
        // Mantenemos tu DiaryEntry y agregamos el nuevo CalendarEvent
        let schema = Schema([
            DiaryEntry.self,
            CalendarEvent.self // <-- NUEVO
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
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }
}

// Mantenemos tu RootView exactamente como lo tenías
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

