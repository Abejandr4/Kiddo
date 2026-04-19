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
    let progress: Double
    
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
                            withAnimation {
                                medicineTaken = true
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
                }
                .padding()
                .background(LinearGradient(colors: [Color(hex: "FFF9E6"), Color(hex: "FFE6CC")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(20)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: .black.opacity(0.05), radius: 10)

            // --- AQUÍ ESTÁ EL CAMBIO DEL MAPA DE PROGRESO ---
            // Llamamos a tu componente ProgressPath.
            // Si tu ProgressPath necesita el progreso, cámbialo a: ProgressPath(progress: progress)
            ProgressMap(progress: 45)
                .frame(maxWidth: .infinity)
                .frame(height: 600) // Ajusta esta altura si ves que tu camino necesita más o menos espacio
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
        // --- AQUÍ ESTÁ EL CAMBIO DE LOS BORDES ---
        .padding(.horizontal, 20)
        .padding(.top, 10) // Un poquito de espacio arriba para que respire
        .padding(.bottom, 30) // Añadí un margen inferior para que el último elemento no pegue justo al borde al scrollear
                }
    }
}

#Preview {
    InicioHijo(medicineTaken: .constant(false), showAnimation: .constant(false), progress: 0.8)
}
