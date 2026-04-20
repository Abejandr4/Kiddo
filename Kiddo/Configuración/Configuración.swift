//
//  Configuración.swift
//  Kiddo
//
//  Created by Valentina Garcia on 18/04/26.
//


import Foundation
import SwiftUI

enum UserType {
    case child, parent
}

struct SettingsView: View {
    let userType: UserType
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userRole") private var userRole: String = "None"
    
    // Variables de persistencia para el avatar
    @AppStorage("avatarCapa") private var avatarCapa: String = ""
    @AppStorage("avatarAccesorio") private var avatarAccesorio: String = ""
    
    var onLogout: () -> Void = { }
    
    // Avatar dinámico que siempre refleja lo guardado
    var currentAvatar: Avatar {
        Avatar(
            capa: avatarCapa.isEmpty ? nil : avatarCapa,
            cuerpo: "kiddo_principal",
            accesorio: avatarAccesorio.isEmpty ? nil : avatarAccesorio
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Solo dejamos este encabezado
                HStoreHeader()
                
                // Pasamos el avatar actualizado
                UserProfileCard(userType: userType, avatar: currentAvatar)
                
                NavigationStack {
                    VStack(spacing: 20) {
                        
                        if userType == .child {
                            NavigationRow(
                                icon: "person.crop.circle",
                                title: "Personalizar Superhéroe",
                                subtitle: "Edita tu avatar",
                                gradient: Gradient(colors: [.purple, .blue]),
                                destination: CustomizationView(avatarCapa: $avatarCapa, avatarAccesorio: $avatarAccesorio)
                            )
                        }
                        
                        // Nueva opción de Vinculación con padre
                        // Nueva opción de Vinculación con padre
                        NavigationRow(
                            icon: "qrcode.viewfinder",
                            title: "Vinculación con padre",
                            subtitle: "Conecta tu cuenta",
                            gradient: Gradient(colors: [.green, .teal]),
                            // ¡Aquí está la corrección! Agregamos "View" y un token de prueba
                            destination: VinculacionQRView(token: "KIDDO-1234-ABCD")
                        )
                        
                    }
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 10)
                    
                    // App Info Card
                    AppInfoCard()
                    
                    // Logout Button
                    Button(action: {
                        hasCompletedOnboarding = false
                        userRole = "None"
                        onLogout()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Cerrar Sesión")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
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
                    .foregroundColor(Color(hex: "7BC67E"))
                Text("Configuración")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(hex: "2D3748"))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
        }
    }
}

#Preview("Vista Niño") {
    NavigationStack {
        SettingsView(userType: .child)
    }
}

#Preview("Vista Padre") {
    NavigationStack {
        SettingsView(userType: .parent)
    }
}

