import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct MainView: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var medicineTaken = false
    @State private var showAnimation = false
    @State private var progressPercentage: Double = 0.0
    
    var body: some View {
        TabView {
            // 1. INICIO
            NavigationStack {
                InicioHijo(showAnimation: $showAnimation)
            }
            .tabItem {
                Label("Inicio", systemImage: "house.fill")
            }
            
            
            // 2. DIARIO
            NavigationStack {
                DiarioHijo()
            }
            .tabItem {
                Label("Diario", systemImage: "heart.text.square.fill")
            }
            
            // 3. CALENDARIO
            NavigationStack {
                CalendarioHijo()
            }
            .tabItem {
                Label("Calendario", systemImage: "calendar")
            }
            
            // 4. AJUSTES
            NavigationStack {
                SettingsView(userType: .child)
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
    
    MainView()  
        .environmentObject(DataManager(modelContext: container.mainContext))
        .modelContainer(container)
}
