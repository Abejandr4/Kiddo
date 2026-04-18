//
//  Configuración.swift
//  Kiddo
//
//  Created by Valentina Garcia on 18/04/26.
//

import Foundation
import SwiftUI

// Estructura de datos para la configuración del avatar
struct AvatarConfig {
    // Define aquí tus propiedades (ej. color, tipo de máscara)
    var heroColor: Color = .blue
}

struct SettingsView: View {
    let userType: String // "child" o "parent"
    let avatarConfig: AvatarConfig
    var onCustomizeAvatar: () -> Void
    var onLogout: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Título de la sección
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(hex: "7BC67E"))
                    
                    Text("Configuración")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "2D3748"))
                    Spacer()
                }
                .padding(.horizontal)

                // Profile Card (Avatar)
                VStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 150, height: 150)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 142, height: 142)
                        
                        // Placeholder del SuperheroSprite
                        Image(systemName: "bolt.shield.fill")
                            .font(.system(size: 80))
                            .foregroundColor(avatarConfig.heroColor)
                    }
                    .padding(.top, 20)

                    Text(userType == "child" ? "¡Mi Superhéroe!" : "Cuidador")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "2D3748"))

                    Text(userType == "child" ? "Cuenta personal" : "Cuenta de apoyo")
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "718096"))
                        .padding(.bottom, 20)
                }
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [Color(hex: "E8F5E9"), .white], startPoint: .top, endPoint: .bottom)
                )
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)

                // Settings Options List
                VStack(spacing: 0) {
                    if userType == "child" {
                        SettingsRow(
                            icon: "paintbrush.fill",
                            colors: [Color(hex: "B4A7D6"), Color(hex: "FFB366")],
                            title: "Personalizar Superhéroe",
                            subtitle: "Cambia tu máscara, capa y colores",
                            action: onCustomizeAvatar
                        )
                        Divider().padding(.leading, 70)
                    }

                    SettingsRow(
                        icon: "shield.fill",
                        colors: [Color(hex: "87CEEB"), Color(hex: "7BC67E")],
                        title: "Privacidad",
                        subtitle: userType == "child" ? "Tu diario es solo tuyo" : "Configuración de acceso",
                        action: {}
                    )
                    
                    Divider().padding(.leading, 70)

                    SettingsRow(
                        icon: "info.circle.fill",
                        colors: [Color(hex: "F9E784"), Color(hex: "FFB366")],
                        title: "Acerca de",
                        subtitle: "Versión 1.0.0 - Mi Jardín de Salud",
                        action: {}
                    )
                }
                .background(.white)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)

                // App Info Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 15) {
                        Text("🌸")
                            .font(.system(size: 40))
                        VStack(alignment: .leading) {
                            Text("Mi Jardín de Salud")
                                .font(.headline)
                            Text("Una app para cuidar de ti con amor")
                                .font(.subheadline)
                                .opacity(0.9)
                        }
                    }
                    
                    Text("Recuerda: Esta app es una herramienta de apoyo. Siempre consulta con tu equipo médico para decisiones importantes sobre tu salud.")
                        .font(.caption)
                        .opacity(0.8)
                }
                .padding(24)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    LinearGradient(colors: [Color(hex: "B4A7D6"), Color(hex: "7BC67E")], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(30)

                // Logout Button
                Button(action: onLogout) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Cerrar Sesión")
                            .fontWeight(.semibold)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(colors: [Color(hex: "FF8ED4"), Color(hex: "FFB366")], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(30)
                    .shadow(radius: 5)
                }
            }
            .padding()
        }
        .background(Color(hex: "F7FAFC"))
    }
}

// Subcomponente para las filas de configuración
struct SettingsRow: View {
    let icon: String
    let colors: [Color]
    let title: String
    let subtitle: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Color(hex: "2D3748"))
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color(hex: "718096"))
                }
                
                Spacer()
                
                Image(systemName: "play.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "CBD5E0"))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

// Helper para usar colores Hexadecimales en SwiftUI
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView(
                userType: "child",
                avatarConfig: AvatarConfig(),
                onCustomizeAvatar: { print("Personalizar") },
                onLogout: { print("Salir") }
            )
        }
    }

