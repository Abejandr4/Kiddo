import SwiftUI
import SwiftData

struct CalendarioPadre: View {
    // Consultamos los eventos directamente de la base de datos
    @Query(sort: \CalendarEvent.date) private var allEvents: [CalendarEvent]
    @State private var showingAddSheet = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                
                // Pasamos los eventos consultados a la vista del calendario
                CalendarView(events: allEvents, selectedDate: $selectedDate)
                    .ignoresSafeArea(edges: .bottom)
                
                ActionButton("+", fontSize: 35) { // 👈 ¡Solo agregas el fontSize aquí!
                    showingAddSheet = true
                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
                .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                .sheet(isPresented: $showingAddSheet) {
                    AddEventView() // Ya no requiere el binding
                }
            }
        }
    }
    
}
