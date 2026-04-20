//
//  Configuración.swift
//  Kiddo
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
    
    @AppStorage("avatarCapa") private var avatarCapa: String = ""
    @AppStorage("avatarAccesorio") private var avatarAccesorio: String = ""
    
    var onLogout: () -> Void = { }
    
    var currentAvatar: Avatar {
        Avatar(
            capa: avatarCapa.isEmpty ? nil : avatarCapa,
            cuerpo: "kiddo_principal",
            accesorio: avatarAccesorio.isEmpty ? nil : avatarAccesorio
        )
    }
    
    var body: some View {
        NavigationStack {
        ScrollView {
            VStack(spacing: 20) {
                HStoreHeader()
                
                UserProfileCard(userType: userType, avatar: currentAvatar)
                
                
                    VStack(spacing: 20) {
                        
                        // OPCIÓN SOLO PARA NIÑO
                        if userType == .child {
                            NavigationRow(
                                icon: "person.crop.circle",
                                title: "Personalizar Superhéroe",
                                subtitle: "Edita tu avatar",
                                gradient: Gradient(colors: [.purple, .blue]),
                                destination: CustomizationView(avatarCapa: $avatarCapa, avatarAccesorio: $avatarAccesorio)
                            )
                        }
                        
                        // OPCIÓN SOLO PARA PADRE (Privacidad y Protección de Datos)
                        if userType == .parent {
                            NavigationRow(
                                icon: "lock.shield",
                                title: "Privacidad",
                                subtitle: "Protección de datos",
                                gradient: Gradient(colors: [.green, .teal]),
                                // --- NUEVO MENSAJE DE PRIVACIDAD ---
                                destination: ScrollView {
                                    VStack(spacing: 25) {
                                        Image(systemName: "checkmark.shield.fill")
                                            .font(.system(size: 65))
                                            .foregroundColor(Color(hex: "7BC67E"))
                                            .padding(.top, 20)
                                        
                                        Text("Privacidad y Protección de Datos")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "2D3748"))
                                            .multilineTextAlignment(.center)
                                        
                                        Text("En Kiddo, la seguridad de tu familia es nuestra máxima prioridad. Toda la información médica y personal está encriptada y almacenada bajo estrictos estándares de seguridad.\n\nEl diario interactivo es un espacio seguro y confidencial diseñado para que el niño pueda expresar sus emociones libremente. Nuestra Inteligencia Artificial procesa estas entradas de forma anónima y local, únicamente para personalizar las recomendaciones de bienestar.\n\nPara fomentar un entorno de total confianza y proteger su privacidad emocional, los textos originales del diario no son accesibles para el tutor ni se comparten con terceros.")
                                            .font(.body)
                                            .foregroundColor(Color(hex: "718096"))
                                            .multilineTextAlignment(.center)
                                            .lineSpacing(4)
                                            .padding(.horizontal, 20)
                                        AnimacionSonrisa()
                                        Spacer()
                                    }
                                    .padding()
                                }
                                .navigationTitle("Privacidad")
                                .navigationBarTitleDisplayMode(.inline),
                                
                            )
                        }
                        
                        
                        // OPCIÓN PARA AMBOS (Vinculación)
                        NavigationRow(
                            icon: "qrcode.viewfinder",
                            title: "Vinculación",
                            subtitle: userType == .child ? "Conecta con tu padre" : "Sincroniza con el niño",
                            gradient: Gradient(colors: [.blue, Color(hex: "87CEEB")]),
                            destination: VinculacionQRView(token: "KIDDO-1234-ABCD")
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 20)
                    
                    AppInfoCard()
                    
                    // Botón Cerrar Sesión
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
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "FF8ED4"), Color(hex: "FFB366")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .background(Color(hex: "F7FAFC").ignoresSafeArea())
        }
    }
    
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

