//
//  ContentView.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    // Persistencia de la selección de rol
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userRole") private var userRole: String = "None"

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                // Selección de la vista principal según el rol guardado
                if userRole == "Padre" {
                    MainViewPadre()
                }            } else {
                // Pantalla de selección inicial solo para apps nuevas
                OnboardingView()
            }
        }
    }
}

// MARK: - Vista de Selección Inicial
struct OnboardingView: View {
    @AppStorage("userRole") var userRole: String = "None"
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 10) {
                Text("Bienvenido a Kiddo")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                Text("¿Quién usará el dispositivo?")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 20) {
                roleButton(title: "Padre / Cuidador", icon: "person.2.fill", color: .blue, role: "Padre")
                roleButton(title: "Hijo / Paciente", icon: "figure.and.child.holdinghands", color: .orange, role: "Hijo")
            }
            .padding(.horizontal, 30)
        }
    }

    private func roleButton(title: String, icon: String, color: Color, role: String) -> some View {
        Button(action: {
            withAnimation(.spring()) {
                userRole = role
                hasCompletedOnboarding = true
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                Text(title)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: 2)
            )
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
