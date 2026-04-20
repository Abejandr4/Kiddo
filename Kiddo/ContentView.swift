//
//  ContentView.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 18/04/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @AppStorage("userRole") private var userRole: String = "None"

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                if userRole == "Padre" {
                    MainViewPadre()
                } else {
                    // Aquí iría la vista del Superhéroe (Hijo)
                    MainView()
                }
            } else {
                // Pasamos una función que actualice el AppStorage
                LoginScreen { selectedRole in
                    withAnimation(.spring()) {
                        userRole = selectedRole
                        hasCompletedOnboarding = true
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        // Importante: Si tu app usa SwiftData, necesitas esto para que el preview cargue
        .modelContainer(for: Item.self, inMemory: true)
}
       

