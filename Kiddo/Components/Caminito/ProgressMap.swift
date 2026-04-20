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
    let imageName: String
    let time: String
    
}

struct ProgressMap: View {
    let progress: Double // 0 a 100
    
    var body: some View {
        let checkpoints = [
            Checkpoint(x: 0.2, y: 0.75, label: "Mañana", imageName: "Mañana", time: "8:00 AM"),
            Checkpoint(x: 0.8, y: 0.60, label: "Mediodía", imageName: "Medio_día", time: "12:00 PM"),
            Checkpoint(x: 0.26, y: 0.45, label: "Tarde", imageName: "Tarde", time: "4:00 PM"),
            Checkpoint(x: 0.75, y: 0.34, label: "Noche", imageName: "Noche", time: "8:00 PM"),
            Checkpoint(x: 0.50, y: 0.15, label: "¡Día completo!", imageName: "Trofeo", time: "")
        ]
        
        // Calculamos cuál es el checkpoint actual basado en el progreso
        let currentCheckpointIndex = Int((progress / 100) * Double(checkpoints.count - 1))
        
        GeometryReader { geometry in
            ZStack {
                // Fondo con gradiente usando la extensión hex:
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "E8F5E9"),
                        Color(hex: "F1F8E9"),
                        Color(hex: "FFF9E6")
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Camino serpenteante (Usa tu OrganicPath existente)
                OrganicPath(points: checkpoints.map { CGPoint(x: $0.x, y: $0.y) })
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [8, 10]))
                
                // Checkpoints
                ForEach(0..<checkpoints.count, id: \.self) { i in
                    CheckpointView(
                        checkpoint: checkpoints[i],
                        isActive: i == currentCheckpointIndex,
                        isCompleted: i < currentCheckpointIndex,
                        size: geometry.size
                    )
                }
                
                // 🦸‍♂️ NUESTRO AVATAR ANIMADO
                WalkingAvatar(
                    progress: progress,
                    points: checkpoints.map { CGPoint(x: $0.x, y: $0.y) },
                    size: geometry.size
                )
                .animation(.easeInOut(duration: 1.5), value: progress)
                
                // Indicador de progreso inferior (¡Restaurado!)
                VStack {
                    Spacer() // Empuja la barra hacia abajo
                    
                    HStack(spacing: 15) {
                        Text("Progreso: \(Int(progress))%")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "2D3748"))
                        
                        // Barra de progreso estética
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 8)
                            Capsule()
                                .fill(LinearGradient(
                                    colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .frame(width: CGFloat(progress), height: 8)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.bottom, 25)
                }
            } // Cierra el ZStack
        } // Cierra el GeometryReader
        .frame(height: 550)
        .padding()
    }
}


// MARK: - Preview
#Preview {
    VStack {
        ProgressMap(progress: 100.0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(hex: "F7FAFC"))
}
