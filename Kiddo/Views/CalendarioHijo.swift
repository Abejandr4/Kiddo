//
//  CalendarioHijo.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import SwiftUI
import SwiftData

struct CalendarioHijo: View {
    // Consultamos los mismos eventos que el padre desde la base de datos
    @Query(sort: \CalendarEvent.date) private var allEvents: [CalendarEvent]
    
    // Estado para manejar la fecha seleccionada en el componente
    @State private var selectedDate = Date()

    var body: some View {
        // Usamos el componente CalendarView 
        // el hijo no tendrá forma de agregar eventos.
        CalendarView(events: allEvents, selectedDate: $selectedDate)
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CalendarioHijo()
            .modelContainer(for: CalendarEvent.self, inMemory: true)
    }
}
