//
//  CheckpointView.swift
//  Kiddo
//
//  Created by Valentina Garcia on 18/04/26.
//

import Foundation
import SwiftUI


struct CheckpointView: View {
    let checkpoint: Checkpoint
    let isActive: Bool
    let isCompleted: Bool
    let size: CGSize
    
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Pulso de fondo para el activo
                if isActive {
                    Circle()
                        .fill(Color(hex: "F9E784")) // CORRECCIÓN: hex
                        .frame(width: 50, height: 50)
                        .scaleEffect(pulseScale)
                        .opacity(2.5 - pulseScale)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                                pulseScale = 2
                            }
                        }
                }
                
                // Círculo principal
                Circle()
                    .fill(backgroundGradient)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Circle().stroke(isCompleted ? Color.clear : Color(hex: "E2E8F0"), lineWidth: isCompleted ? 0 : 4) // CORRECCIÓN: hex
                    )
                    .shadow(radius: 5)
                
                // Contenido: Avatar o Emoji
                // Contenido: Avatar animado o Asset estático
                                if isActive {
                                    // 🌟 Dejamos este espacio VACÍO.
                                    // No ponemos nada aquí porque el avatar animado
                                    // (el que camina) se va a poner encima desde la vista principal.
                                } else {
                                    // ✅ Aquí sí mostramos tus imágenes (Trofeo, Noche, etc.)
                                    Image(checkpoint.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 35, height: 35) // Ajusta el tamaño para que quepa en tu círculo de 60x60
                                }
                // Checkmark de completado
                if isCompleted {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "7BC67E")) // CORRECCIÓN: hex
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                        .offset(x: 25, y: -25)
                        .shadow(radius: 2)
                }
            }
            
            // Labels
            VStack(spacing: 2) {
                Text(checkpoint.label)
                    .font(.system(size: 14, weight: isActive ? .bold : .regular))
                    .foregroundColor(isActive ? Color(hex: "2D3748") : Color(hex: "718096")) // CORRECCIÓN: hex
                
                if !checkpoint.time.isEmpty {
                    Text(checkpoint.time)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
            }
        }
        .position(x: checkpoint.x * size.width, y: checkpoint.y * size.height)
    }
    
    var backgroundGradient: LinearGradient {
        if isCompleted {
            return LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if isActive {
            return LinearGradient(colors: [Color(hex: "F9E784"), Color(hex: "FFB366")], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: [.white], startPoint: .top, endPoint: .bottom)
        }
    }
}

// MARK: - Preview corregido
#Preview {
    GeometryReader { geometry in
        ZStack {
            // Fondo para contrastar
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            // 1. ESTADO COMPLETADO (Arriba)
            CheckpointView(
                checkpoint: Checkpoint(x: 0.5, y: 0.2, label: "Completado", imageName: "Trofeo", time: "8:00 AM"),
                isActive: false,
                isCompleted: true,
                size: geometry.size
            )
            
            // 2. ESTADO ACTIVO (Centro)
            CheckpointView(
                checkpoint: Checkpoint(x: 0.5, y: 0.5, label: "Actual", imageName: "Trofeo", time: "12:00 PM"),
                isActive: true,
                isCompleted: false,
                size: geometry.size
            )
            
            // 3. ESTADO PENDIENTE (Abajo)
            CheckpointView(
                checkpoint: Checkpoint(x: 0.5, y: 0.8, label: "Pendiente", imageName: "Noche", time: "8:00 PM"),
                isActive: false,
                isCompleted: false,
                size: geometry.size
            )
        }
    }
}
