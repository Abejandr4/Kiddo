//
//  InicioPadre.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import SwiftUI

struct InicioHijo: View {
    @Binding var medicineTaken: Bool
    @Binding var showAnimation: Bool
    @Binding var progress: Double //
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                // Tarjeta: Siguiente Misión
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("La siguiente misión")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                        if medicineTaken {
                            Text("¡Hecho!")
                                .font(.subheadline).bold()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(LinearGradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Prednisona 💊")
                                    .font(.title3).bold()
                                Text("Hoy a las 2:00 PM • 10 mg")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        
                        if !medicineTaken {
                            Button(action: {
                                withAnimation(.spring()) {
                                    medicineTaken = true
                                    showAnimation = true
                                    
                                    // CAMBIO 1: Incrementamos el progreso al registrar la medicina.
                                    // Como tienes 5 checkpoints en tu ProgressMap,
                                    // subir de 25 en 25 (o 20 en 20) moverá el avatar al siguiente punto.
                                    if progress < 100 {
                                        progress += 25
                                    }
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
                    }
                    .padding()
                    .background(LinearGradient(colors: [Color(hex: "FFF9E6"), Color(hex: "FFE6CC")], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.05), radius: 10)

                // --- CAMBIO 2: PROGRESO VINCULADO ---
                // Ahora usamos la variable 'progress' que viene del Binding.
                // Esto hará que el mapa reaccione inmediatamente al botón superior.
                ProgressMap(progress: progress)
                    .frame(maxWidth: .infinity)
                    .frame(height: 550) // Ajustado a la altura definida en tu ProgressMap.swift
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.05), radius: 10)

                // Tarjeta Motivacional
                HStack(spacing: 15) {
                    Text("🌟").font(.system(size: 40))
                    VStack(alignment: .leading) {
                        Text("¡Vas muy bien, campeón!").font(.headline)
                        Text("Cada día te vuelves más fuerte").font(.subheadline).opacity(0.9)
                    }
                    Spacer()
                }
                .padding()
                .background(LinearGradient(colors: [Color(hex: "B4A7D6"), Color(hex: "FFB366")], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(30)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
    }
}

