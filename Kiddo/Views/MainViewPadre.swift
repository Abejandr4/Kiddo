import SwiftUI
import SwiftData

struct MainViewPadre: View {
    // ❌ Borramos el @State var allEvents porque SwiftData ya es nuestra fuente de verdad
    
    var body: some View {
        TabView {
            // --- 1. INICIO ---
            NavigationStack {
                InicioPadre(todayMedsTaken: 2, totalMeds: 5, progress: 0.4)
                    .navigationTitle("¡Hola!")
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }
            
            // --- 2. MEDICINAS (DIARIO) ---
            NavigationStack {
                // ✅ Le quitamos el parámetro (calendarEvents: $allEvents)
                MedicamentosView()
            }
            .tabItem { Label("Medicinas", systemImage: "heart.text.square.fill") }
            
            // --- 3. CALENDARIO ---
            NavigationStack {
                CalendarioPadre()
            }
            .tabItem { Label("Calendario", systemImage: "calendar") }
            
            // --- 4. AJUSTES ---
            NavigationStack {
                AjustesPadre()
                    .navigationTitle("Ajustes")
            }
            .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    MainViewPadre()
        // ✅ Le agregamos el modelContainer al Preview para que no marque error el simulador
        .modelContainer(for: [DiaryEntry.self, CalendarEvent.self], inMemory: true)
}
