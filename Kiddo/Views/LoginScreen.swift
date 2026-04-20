//
//  LoginScreen.swift
//  Kiddo
//
//  Created by Valentina Garcia on 19/04/26.
//

import Foundation
import SwiftUI

struct LoginScreen: View {
    var onFinished: (String) -> Void
    
    var body: some View {
        ZStack {
            // Fondo crema suave para resaltar el naranja y los gradientes
            Color(hex: "FDFBF2")
                .ignoresSafeArea()
            
            VStack {
                Spacer() // Empuja el contenido hacia el centro
                
                VStack(spacing: 60) {
                    // MARK: - App Name (Estilo Imagen 2)
                    VStack(spacing: -10) {
                        // Rayitos decorativos
                        HStack {
                            
                        }
                        .frame(width: 150)
                        .foregroundColor(Color(hex: "2D3748"))
                        
                        Text("Kiddo")
                            .font(.system(size: 80, weight: .black, design: .rounded))
                            .foregroundColor(Color(hex: "E59866")) // Color naranja similar a la imagen
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 2, y: 2)
                    }
                    
                    // MARK: - Botones
                    VStack(spacing: 20) {
                        UserTypeButton(
                            imageName: "Superhéroe",
                            title: "Soy el Superhéroe",
                            subtitle: "Mi diario personal",
                            gradient: [Color(hex: "7BC67E"), Color(hex: "87CEEB")]
                        ) {
                            onFinished("Hijo")
                        }
                        
                        UserTypeButton(
                            imageName: "Cuidador",
                            title: "Soy el Cuidador",
                            subtitle: "Apoyo a mi superhéroe",
                            gradient: [Color(hex: "B4A7D6"), Color(hex: "FFB366")]
                        ) {
                            onFinished("Padre")
                        }
                    }
                    .padding(.horizontal, 30)
                }
                
                Spacer() // Empuja el contenido hacia el centro desde abajo
            }
        }
    }
}

// El componente UserTypeButton se queda igual, pero ajustamos el sombreado
struct UserTypeButton: View {
    let imageName: String
    let title: String
    let subtitle: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    Text(subtitle)
                        .font(.system(size: 14))
                        .opacity(0.9)
                }
                Spacer()
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 25)
            .foregroundColor(.white)
            .background(
                LinearGradient(gradient: Gradient(colors: gradient), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .cornerRadius(25)
            // Sombreado más profundo para que parezcan "cards" físicas
            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(onFinished: { _ in })
    }
}
