//
//  InicioPadre.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import SwiftUI
import SwiftData

struct InicioHijo: View {
    // 1. Inyectamos SwiftData
    @Environment(\.modelContext) private var context
    @Query(sort: \CalendarEvent.startTime) private var allEvents: [CalendarEvent]
    
    @Binding var showAnimation: Bool
    
    // 2. Filtramos solo los medicamentos de HOY
    var todaysMedications: [CalendarEvent] {
        let calendar = Calendar.current
        return allEvents.filter {
            calendar.isDateInToday($0.date) && $0.type == .medication
        }
    }
    
    // 3. Calculamos la siguiente misión (agrupando por la misma hora)
    var currentMissions: [CalendarEvent] {
        let pending = todaysMedications.filter { !$0.isTaken }
        
        // Asumimos que startTime está en formato "HH:mm" para que el orden alfabético funcione,
        // o puedes ordenarlos convirtiéndolos a Date.
        let sortedPending = pending.sorted { $0.startTime < $1.startTime }
        
        guard let firstTime = sortedPending.first?.startTime else { return [] }
        
        // Retornamos todas las medicinas que compartan exactamente esa misma hora
        return sortedPending.filter { $0.startTime == firstTime }
    }
    
    // 4. Calculamos el progreso escalar
    var calculatedProgress: Double {
        let total = todaysMedications.count
        if total == 0 { return 0 }
        let takenCount = todaysMedications.filter { $0.isTaken }.count
        return (Double(takenCount) / Double(total)) * 100.0
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                
                // Tarjeta: Siguiente Misión
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text(currentMissions.isEmpty ? "Misiones completadas" : "La siguiente misión")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                        if currentMissions.isEmpty && !todaysMedications.isEmpty {
                            Text("¡Día Libre!")
                                .font(.subheadline).bold()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    
                    if !currentMissions.isEmpty {
                        // Iteramos sobre las medicinas agrupadas para esta hora
                        ForEach(currentMissions) { mission in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(mission.title) 💊")
                                            .font(.title3).bold()
                                        Text("Hoy a las \(mission.startTime) • \(mission.eventDescription ?? "")")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                
                                Button(action: {
                                    withAnimation(.spring()) {
                                        // SwiftData guardará el cambio instantáneamente
                                        mission.isTaken = true
                                        showAnimation = true
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark")
                                        Text("Registrar medicina")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing))
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .cornerRadius(25)
                                    .shadow(radius: 5)
                                }
                            }
                            .padding()
                            .background(LinearGradient(colors: [Color(hex: "FFF9E6"), Color(hex: "FFE6CC")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(20)
                        }
                    } else if todaysMedications.isEmpty {
                        Text("No hay medicamentos programados para hoy.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.05), radius: 10)

                // El progreso se inyecta directamente calculado
                ProgressMap(progress: calculatedProgress)
                    .frame(maxWidth: .infinity)
                    .frame(height: 550)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.05), radius: 10)

                // Tarjeta Motivacional...
                // (Mismo código que ya tienes)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
    }
}
#Preview {
    InicioHijo(showAnimation: .constant(false))
        .modelContainer(for: CalendarEvent.self, inMemory: true)
}

