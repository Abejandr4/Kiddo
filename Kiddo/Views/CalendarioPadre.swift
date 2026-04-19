import SwiftUI

struct CalendarioPadre: View {
    @Binding var allEvents: [CalendarEvent]
    @State private var showingAddSheet = false
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) { // Alineamos el contenido al fondo a la derecha
                
                // 1. El contenido principal (Calendario)
                CalendarView(events: allEvents, selectedDate: $selectedDate)
                    .ignoresSafeArea(edges: .bottom)
                
                // 2. Tu botón con degradado personalizado
                ActionButton("+") {
                    showingAddSheet = true
                }
                .padding(.trailing, 20) // Margen desde la derecha
                .padding(.bottom, 30)   // Margen desde abajo (ajusta según el TabBar)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
            }
            // Quitamos el botón del toolbar ya que ahora tenemos el ActionButton
            .sheet(isPresented: $showingAddSheet) {
                AddEventView(events: $allEvents)
            }
        }
    }
}

