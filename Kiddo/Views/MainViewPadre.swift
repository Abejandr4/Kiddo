
import SwiftUI
import SwiftData

struct MainViewPadre: View {
    @AppStorage("linkingToken") private var linkingToken: String = ""
    
    var body: some View {
        TabView {
            // --- 1. INICIO (Con QR Centrado) ---
            NavigationStack {
                VStack(spacing: 0) {
                   
                    InicioPadre()
                }
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }
            
            // --- 2. MEDICINAS (DIARIO) ---
            NavigationStack {
                MedicamentosView()
            }
            .tabItem { Label("Medicinas", systemImage: "heart.text.square.fill") }
            
            // --- 3. CALENDARIO ---
            NavigationStack {
                CalendarioPadre()
            }
            .tabItem { Label("Calendario", systemImage: "calendar") }
            
            // --- 4. CHAT ---
            NavigationStack {
                AIChatViewFF()
            }
            .tabItem { Label("Chat", systemImage: "star.bubble") }
            
            // --- 5. AJUSTES ---
            NavigationStack {
                SettingsView(userType: .parent)
                    
            }
            .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    MainViewPadre()
       
        .modelContainer(for: [DiaryEntry.self, CalendarEvent.self], inMemory: true)
}
