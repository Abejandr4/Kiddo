//
//  UserProfileCard.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 19/04/26.

import SwiftUI

struct UserProfileCard: View {
    let userType: UserType
    let avatar: Avatar
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "7BC67E"), Color(hex: "87CEEB")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 140, height: 140)
                
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 1.0, green: 0.8, blue: 0.8),
                                Color(red: 0.9, green: 0.9, blue: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 132, height: 132)
                
                if userType == .child {
                    // Muestra el Kiddo personalizado para el niño
                    AvatarView(avatar: avatar)
                        .scaleEffect(0.45)
                        .frame(width: 132, height: 132)
                        .clipShape(Circle())
                } else {
                    // Muestra la imagen de Cuidador para el padre
                    Image("Cuidador")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
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
                gradient: Gradient(colors: [Color(hex: "E8F5E9"), .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
    }
}


