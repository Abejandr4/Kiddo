import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var dataManager: DataManager
    
    
    var body: some View {
        TabView {
            // 1. INICIO
            NavigationStack {
                InicioHijo()
                    .navigationTitle("¡Hola!")
            }
            .tabItem {
                Label("Inicio", systemImage: "house.fill")
            }
            
            // 2. DIARIO
            NavigationStack {
                DiarioHijo()
                    .navigationTitle("Mi Diario")
            }
            .tabItem {
                Label("Diario", systemImage: "heart.text.square.fill")
            }
            
            // 3. CALENDARIO
            NavigationStack {
                CalendarioHijo()
                    .navigationTitle("Mi Calendario")
            }
            .tabItem {
                Label("Calendario", systemImage: "calendar")
            }
            
            // 4. AJUSTES
            NavigationStack {
                AjustesHijo()
                    .navigationTitle("Ajustes")
            }
            .tabItem {
                Label("Ajustes", systemImage: "gearshape.fill")
            }
        }
        
    }


}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DiaryEntry.self, configurations: config)
    
    MainView()  // ← sin "return"
        .environmentObject(DataManager(modelContext: container.mainContext))
        .modelContainer(container)
}
