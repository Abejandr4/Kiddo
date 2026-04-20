//
//  AppInfoCard.swift
//  Kiddo
//
//  Created by Dev Jr.1 on 19/04/26.
//

import SwiftUI

struct AppInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 15) {
                AnimacionFeliz()
                VStack(alignment: .leading) {
                    Text("Kiddo")
                        .font(.headline)
                    Text("Una app para acompañar a cada superhéroe en su misión")
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
