import SwiftUI

struct MainViewPadre: View {
    // 1. Fuente de verdad única
    @State var allEvents: [CalendarEvent] = []
    
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
                // Pasamos $allEvents para que la lista se actualice sola
                MedicamentosView(calendarEvents: $allEvents)
            }
            .tabItem { Label("Medicinas", systemImage: "heart.text.square.fill") }
            
            // --- 3. CALENDARIO ---
            NavigationStack {
                // IMPORTANTE: Aquí también debes pasar $allEvents
                CalendarioPadre(allEvents: $allEvents)
                    
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
}
