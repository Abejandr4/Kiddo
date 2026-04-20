//
//  InicioPadre.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//
import SwiftUI
import SwiftData

struct InicioPadre: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \CalendarEvent.startTime) private var allEvents: [CalendarEvent]
    
    @AppStorage("personalRecom_1") private var personalRecom_1: String = "⭐️ Asegúrate de que beba suficiente agua hoy."
    @AppStorage("personalRecom_2") private var personalRecom_2: String = "🧘‍♀️ Tómate 5 minutos para ti hoy, ¡lo estás haciendo genial!"
    
    // Lógica de datos
    var todaysMedications: [CalendarEvent] {
        let calendar = Calendar.current
        return allEvents.filter { calendar.isDateInToday($0.date) && $0.type == .medication }
    }
    
    var nextMissions: [CalendarEvent] {
        let pending = todaysMedications.filter { !$0.isTaken }
        let sortedPending = pending.sorted { $0.startTime < $1.startTime }
        guard let firstTime = sortedPending.first?.startTime else { return [] }
        return sortedPending.filter { $0.startTime == firstTime }
    }
    
    var calculatedProgressValue: Double {
        let total = todaysMedications.count
        if total == 0 { return 1.0 }
        return Double(todaysMedications.filter { $0.isTaken }.count) / Double(total)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 25) {
                
                // --- CABECERA ---
                VStack(spacing: 15) {
                    Image("Cuidador")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                }
                .padding(.top, 20)
                
                // --- SECCIÓN 1: Progreso ---
                VStack(spacing: 18) {
                    HStack {
                        Label("Misiones de hoy", systemImage: "bolt.fill")
                            .font(.headline) // Fuente estándar
                            .foregroundColor(Color(hex: "2D3748"))
                        Spacer()
                        Text("\(todaysMedications.filter{$0.isTaken}.count)/\(todaysMedications.count)")
                            .font(.title3.bold())
                            .foregroundColor(Color(hex: "7BC67E"))
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 18)
                            
                            LinearGradient(colors: [Color(hex: "7BC67E"), Color.teal], startPoint: .leading, endPoint: .trailing)
                                .mask(Capsule())
                                .frame(width: geo.size.width * CGFloat(calculatedProgressValue), height: 18)
                        }
                    }
                    .frame(height: 18)
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(colors: [Color.white, Color(hex: "F0FFF4")], startPoint: .top, endPoint: .bottom))
                )
                .shadow(color: Color.black.opacity(0.04), radius: 15, x: 0, y: 10)

                // --- SECCIÓN 2: Próxima Medicina ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("Próxima misión")
                        .font(.headline) // Fuente estándar
                        .foregroundColor(Color(hex: "2D3748"))
                    
                    if nextMissions.isEmpty {
                        HStack {
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Text("¡Todas las misiones completadas!")
                                .font(.subheadline)
                        }
                        .frame(maxWidth: .infinity).padding()
                    } else {
                        ForEach(nextMissions) { mission in
                            HStack(spacing: 15) {
                                Image(systemName: "capsule.fill")
                                    .font(.title)
                                    .foregroundColor(Color(hex: "FFB366"))
                                
                                VStack(alignment: .leading) {
                                    Text(mission.title)
                                        .font(.headline)
                                    Text("Hoy • \(mission.eventDescription ?? "Medicación programada")")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.white.cornerRadius(18))
                        }
                    }
                }
                .padding(25)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(colors: [Color(hex: "FFF9E6"), Color(hex: "FFE6CC")], startPoint: .topLeading, endPoint: .bottomTrailing))
                )

                // --- SECCIÓN 3: Tips ---
                VStack(alignment: .leading, spacing: 15) {
                    Text("Tips de Cuidador")
                        .font(.headline)
                    
                    TipRow(text: personalRecom_1, color: Color(hex: "B4A7D6"), icon: "sparkles")
                    TipRow(text: personalRecom_2, color: .teal, icon: "heart.fill")
                }
                .padding(25)
                .background(Color.white.cornerRadius(30))
                .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)

                // --- FOOTER: Motivación ---
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("El amor y apoyo marcan la diferencia")
                            .font(.title3.bold())
                        Text("Cada día eres parte del poder que hace más fuerte a tu superhéroe.")
                            .font(.subheadline)
                    }
                    Spacer()
                    AnimacionSonrisa()
                        .frame(width: 80, height: 80)
                }
                .padding(30)
                .foregroundColor(.white)
                .background(
                    LinearGradient(colors: [Color(hex: "B4A7D6"), Color(hex: "FFB366")], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .cornerRadius(35)
                .shadow(color: Color(hex: "B4A7D6").opacity(0.4), radius: 15, x: 0, y: 10)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(Color(hex: "F7FAFC").ignoresSafeArea())
    }
}

struct TipRow: View {
    let text: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            Text(text)
                .font(.subheadline)
                .foregroundColor(Color(hex: "2D3748"))
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(18)
    }
}
    #Preview {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: CalendarEvent.self, configurations: config)
        
        InicioPadre()
            .modelContainer(container)
    }

