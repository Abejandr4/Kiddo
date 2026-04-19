//
//  InicioPadre.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//
import SwiftUI

struct InicioPadre: View {
    let todayMedsTaken: Int
    let totalMeds: Int
    let progress: Double
    
    var body: some View {
        VStack(spacing: 20) {
            // Bienvenida
            VStack(alignment: .leading) {
                Text("¡Bienvenido!")
                    .font(.largeTitle).bold()
                Text("Apoyando a nuestro superhéroe")
                    .opacity(0.9)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(30)
            .background(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(30)
            
            // Barra de Progreso
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Progreso de Hoy").font(.headline)
                    Spacer()
                    Text("\(todayMedsTaken)/\(totalMeds)")
                        .font(.title3).bold()
                        .foregroundColor(Color(hex: "7BC67E"))
                }
                
                // Progress Bar Custom
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color(hex: "E8F5E9"))
                        Capsule()
                            .fill(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * CGFloat(progress))
                            .overlay(
                                Text("\(Int(progress * 100))%")
                                    .font(.caption2).bold()
                                    .foregroundColor(.white)
                                    .padding(.trailing, 8),
                                alignment: .trailing
                            )
                    }
                }
                .frame(height: 28)
                
                Text("¡Excelente trabajo! Faltan \(totalMeds - todayMedsTaken) medicinas")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            
            // Grid de Stats
            HStack(spacing: 15) {
                StatCard(icon: "sparkles", value: "7", label: "Recomendaciones", color: Color(hex: "F9E784"))
                StatCard(icon: "leaf.fill", value: "Energía ⚡", label: "Energía alta", color: Color(hex: "7BC67E"))
            }
        }
    }
}

// Componente secundario reutilizable
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            Text(value)
                .font(.title).bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(20)
    }
}

#Preview {
    InicioPadre(todayMedsTaken: 21, totalMeds: 24, progress: 0.875)
}
