//
//  CalendarView.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import SwiftUI

struct CalendarView: View {
    var events: [CalendarEvent]
    @Binding var selectedDate: Date
    
    // Colores convertidos a RGB estándar (0.0 a 1.0)
    let themeYellow = Color(red: 249/255, green: 231/255, blue: 132/255)
    let themeGreen  = Color(red: 123/255, green: 198/255, blue: 126/255)
    let themeBlue   = Color(red: 135/255, green: 206/255, blue: 235/255)
    let themeOrange = Color(red: 255/255, green: 179/255, blue: 102/255)
    let themePurple = Color(red: 180/255, green: 167/255, blue: 214/255)
    
    var filteredEvents: [CalendarEvent] {
            events.filter { event in
                Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
            }
        }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con Icono y Título
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.title)
                        .foregroundColor(themeYellow)
                    Text("Mi Agenda")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding([.horizontal, .top])

                // Selector de días horizontal
                HStack(spacing: 10) {
                    ForEach(0..<7) { index in
                        let date = getDateFor(index: index)
                        DaySelectorItem(
                            date: date,
                            isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                            activeColor: themeGreen
                        ) {
                            withAnimation(.spring()) {
                                selectedDate = date
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
            }
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 5)

            // Contenido del Día
            ScrollView {
                VStack(spacing: 16) {
                    if filteredEvents.isEmpty {
                        VStack(spacing: 20) {
                            Spacer(minLength: 50)
                            Image("recomendacion_2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                            Text("¡Tu superhéroe ha tomado todos sus medicamentos!")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        ForEach(filteredEvents) { event in
                            EventRow(event: event)
                        }
                    }
                }
                .padding()
                
            }
            .background(Color(UIColor.secondarySystemBackground))
        }
    }

    func getDateFor(index: Int) -> Date {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return calendar.date(byAdding: .day, value: index, to: startOfWeek)!
    }
}

// MARK: - Componentes Visuales
struct DaySelectorItem: View {
    let date: Date
    let isSelected: Bool
    let activeColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(date.format("EEE").uppercased())
                    .font(.system(size: 10, weight: .bold))
                Text(date.format("d"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(isSelected ? activeColor : Color.clear)
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

struct EventRow: View {
    let event: CalendarEvent
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // Columna de hora
            VStack {
                Text(event.startTime)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.secondary)
            }
            .frame(width: 50)
            
            // Tarjeta de información
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Label(event.title, systemImage: event.type == .medication ? "pill.fill" : "stethoscope")
                        .font(.headline)
                    Spacer()
                    if let end = event.endTime {
                        Text("Hasta \(end)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                if let desc = event.description {
                    Text(desc)
                        .font(.subheadline)
                        .opacity(0.85)
                }
            }
            .padding()
            .background(event.color)
            .foregroundColor(.white)
            .cornerRadius(18)
            .shadow(color: event.color.opacity(0.3), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Helpers
extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: self)
    }
}


