//
//  UserProfileCard.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 19/04/26.
//

import SwiftUI

struct UserProfileCard: View {
    let userType: UserType
    let avatar: Avatar
    
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


