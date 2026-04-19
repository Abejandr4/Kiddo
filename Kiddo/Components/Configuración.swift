//
//  Configuración.swift
//  Kiddo
//
//  Created by Valentina Garcia on 18/04/26.
//

import Foundation
import SwiftUI

// MARK: - Models
enum UserType {
    case child, parent
}

struct AvatarConfig {
    var skinColor: Color = .orange
}

// MARK: - Main View
struct SettingsView: View {
    let userType: UserType
    let avatarConfig: AvatarConfig
    
    var onCustomizeAvatar: () -> Void
    var onLogout: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Header
                HStoreHeader()
                
                // User Profile Card
                UserProfileCard(userType: userType, avatarConfig: avatarConfig)
                
                // Settings Options List
                VStack(spacing: 0) {
                    if userType == .child {
                        SettingsRow(
                            icon: "paintpalette.fill",
                            title: "Personalizar Superhéroe",
                            subtitle: "Cambia tu máscara, capa y colores",
                            // CORRECCIÓN: Se agrega hex:
                            gradient: Gradient(colors: [Color(hex: "B4A7D6"), Color(hex: "FFB366")]),
                            action: onCustomizeAvatar
                        )
                        Divider().padding(.leading, 70)
                    }
                    
                    SettingsRow(
                        icon: "shield.fill",
                        title: "Privacidad",
                        subtitle: userType == .child ? "Tu diario es solo tuyo" : "Configuración de acceso",
                        // CORRECCIÓN: Se agrega hex:
                        gradient: Gradient(colors: [Color(hex: "87CEEB"), Color(hex: "7BC67E")]),
                        action: { /* Acción de privacidad */ }
                    )
                    
                    Divider().padding(.leading, 70)
                    
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "Acerca de",
                        subtitle: "Versión 1.0.0 - Mi Jardín de Salud",
                        // CORRECCIÓN: Se agrega hex:
                        gradient: Gradient(colors: [Color(hex: "F9E784"), Color(hex: "FFB366")]),
                        action: { /* Acción de Info */ }
                    )
                }
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                
                // App Info Card
                AppInfoCard()
                
                // Logout Button
                Button(action: onLogout) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Cerrar Sesión")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            // CORRECCIÓN: Se agrega hex:
                            gradient: Gradient(colors: [Color(hex: "FF8ED4"), Color(hex: "FFB366")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: Color(hex: "FF8ED4").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .background(Color(hex: "F7FAFC").ignoresSafeArea())
    }
}

// MARK: - Subviews

struct HStoreHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .bold))
                // CORRECCIÓN: hex:
                .foregroundColor(Color(hex: "7BC67E"))
            Text("Configuración")
                .font(.system(size: 28, weight: .bold))
                // CORRECCIÓN: hex:
                .foregroundColor(Color(hex: "2D3748"))
            Spacer()
        }
        .padding(.bottom, 5)
    }
}

struct UserProfileCard: View {
    let userType: UserType
    let avatarConfig: AvatarConfig
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        // CORRECCIÓN: hex:
                        gradient: Gradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 132, height: 132)
                
                Text("👤")
                    .font(.system(size: 60))
            }
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            VStack(spacing: 4) {
                Text(userType == .child ? "¡Mi Superhéroe!" : "Cuidador")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "2D3748"))
                
                Text(userType == .child ? "Cuenta personal" : "Cuenta de apoyo")
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "718096"))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(
            LinearGradient(
                // CORRECCIÓN: hex:
                gradient: Gradient(colors: [Color(hex: "E8F5E9"), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradient: Gradient
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                    
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
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "CBD5E0"))
            }
            .padding(.all, 18)
        }
    }
}

struct AppInfoCard: View {
    var body: some View {
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
                .font(.system(size: 11))
                .opacity(0.8)
                .lineLimit(nil)
        }
        .padding(20)
        .foregroundColor(.white)
        .background(
            LinearGradient(
                // CORRECCIÓN: hex:
                gradient: Gradient(colors: [Color(hex: "B4A7D6"), Color(hex: "7BC67E")]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(25)
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            userType: .child,
            avatarConfig: AvatarConfig(),
            onCustomizeAvatar: { print("Personalizar") },
            onLogout: { print("Salir") }
        )
    }
}

