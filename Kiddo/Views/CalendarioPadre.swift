import SwiftUI

struct CalendarioPadre: View {
    @State private var allEvents: [CalendarEvent] = []
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack { // NavigationStack is preferred over NavigationView in newer iOS
            VStack(spacing: 0) {
                // 1. El Calendario (Asegúrate que el nombre coincida: CalendarioView)
                CalendarView(events: allEvents)
                
                // 2. Lista de próximos eventos
                List(allEvents) { event in
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Circle()
                                .fill(event.color)
                                .frame(width: 10, height: 10)
                            Text(event.title)
                                .font(.headline)
                        }
                        
                        // Usamos 'description' porque 'dose' no existe en tu modelo
                        if let desc = event.description {
                            Text(desc)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Hora: \(event.startTime)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Mi Agenda")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                // Pasamos el binding para que AddEventView pueda guardar
                AddEventView(events: $allEvents)
            }
        }
    }
}

#Preview {
    CalendarioPadre()
}
