//
//  ProgressPath.swift
//  Kiddo
//
//  Created by Valentina Garcia on 18/04/26.
//

import Foundation
import SwiftUI

struct Checkpoint: Identifiable {
    let id = UUID()
    let x: CGFloat // Porcentaje 0.0 a 1.0
    let y: CGFloat // Porcentaje 0.0 a 1.0
    let label: String
    let emoji: String
    let time: String
}

struct ProgressMap: View {
    let progress: Double // 0 a 100
    
    // Simulación del AvatarConfig
    var body: some View {
        let checkpoints = [
            Checkpoint(x: 0.15, y: 0.75, label: "Mañana", emoji: "🌅", time: "8:00 AM"),
            Checkpoint(x: 0.8, y: 0.65, label: "Mediodía", emoji: "☀️", time: "12:00 PM"),
            Checkpoint(x: 0.26, y: 0.48, label: "Tarde", emoji: "🌤️", time: "4:00 PM"),
            Checkpoint(x: 0.75, y: 0.35, label: "Noche", emoji: "🌙", time: "8:00 PM"),
            Checkpoint(x: 0.50, y: 0.15, label: "¡Día completo!", emoji: "⭐", time: "")
        ]
        
        let currentCheckpointIndex = Int((progress / 100) * 4)
        
        GeometryReader { geometry in
            ZStack {
                // Fondo con gradiente
                LinearGradient(
                    gradient: Gradient(colors: [Color(hex: "E8F5E9"), Color(hex: "F1F8E9"), Color(hex: "FFF9E6")]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(30)
                .shadow(radius: 10)
                
                
                // Líneas del camino (Dashed Path)
                Path { path in
                    for i in 0..<checkpoints.count - 1 {
                        let start = CGPoint(x: checkpoints[i].x * geometry.size.width, y: checkpoints[i].y * geometry.size.height)
                        let end = CGPoint(x: checkpoints[i+1].x * geometry.size.width, y: checkpoints[i+1].y * geometry.size.height)
                        
                        path.move(to: start)
                        
                        // 1. Calculamos el punto medio exacto entre los dos checkpoints
                        let midX = (start.x + end.x) / 2
                        let midY = (start.y + end.y) / 2
                        
                        // 2. Desplazamos ese punto medio hacia los lados para crear el "imán" de la curva
                        // i % 2 == 0 hace que una curva vaya hacia un lado y la siguiente hacia el opuesto
                        let curveOffset: CGFloat = i % 2 == 0 ? 50 : -50
                        let controlPoint = CGPoint(x: midX + curveOffset, y: midY)
                        
                        // 3. Dibujamos la línea curva usando ese punto de control
                        path.addQuadCurve(to: end, control: controlPoint)
                    }
                }
                .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 12]))
                
                // Checkpoints
                ForEach(0..<checkpoints.count, id: \.self) { i in
                    CheckpointView(
                        checkpoint: checkpoints[i],
                        isActive: i == currentCheckpointIndex,
                        isCompleted: i < currentCheckpointIndex,
                        size: geometry.size
                    )
                }
                
                // Indicador de progreso inferior
                VStack {
                    Spacer()
                    Text("Progreso: \(Int(progress))%")
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(25)
                        .shadow(radius: 5)
                        .padding(.bottom, 20)
                }
            }
        }
        .frame(height: 500)
        .padding()
    }
}
#Preview {
    // Usamos un State personalizado para poder ver cómo cambia el mapa
    // si modificamos el valor del progreso
    ProgressMap(progress: 45.0)
}
