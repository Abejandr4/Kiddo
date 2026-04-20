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
    
    @State private var myAvatar = Avatar()
    
    // 1. This should be your DATA model, not a View
    // Assuming 'Avatar' is your struct that holds the choices
    @State private var avatarConfig = Avatar(capa: "default", accesorio: "default")
    
    var onLogout: () -> Void = { }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStoreHeader()
                
                // 2. Pass the data model here.
                // Use the argument name 'avatar' as defined in UserProfileCard
                UserProfileCard(userType: userType, avatar: avatarConfig)
                
                NavigationStack {
                    VStack(spacing: 20) {
                        HStoreHeader()
                        
                        if userType == .child {
                            NavigationRow(
                                icon: "person.crop.circle",
                                title: "Personalizar Superhéroe",
                                subtitle: "Edita tu avatar",
                                gradient: Gradient(colors: [.purple, .blue]),
                                destination: CustomizationView(userAvatar: $myAvatar)
                            )
                        }
                        
                        NavigationRow(
                            icon: "lock.shield",
                            title: "Privacidad",
                            subtitle: "Cómo usamos tus datos",
                            gradient: Gradient(colors: [.green, .teal]),
                            destination: Text("La IA analiza las entradas de tu diario para hacer mejores recomendaciones a los usuarios, pero el tutor no puede acceder a las entradas directamente")
                                .padding()
                        )
                        
                        NavigationRow(
                            icon: "info.circle",
                            title: "Acerca de",
                            subtitle: "Información de la app",
                            gradient: Gradient(colors: [.orange, .pink]),
                            destination: Text("Versión 1.0.0 - Mi Jardín de Salud")
                                .padding()
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
    
}

