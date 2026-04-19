import SwiftUI

// Modelo para la sugerencia
struct AISuggestion {
    let icon: String
    let title: String
    let description: String
    let time: String
}

struct AIInsightsView: View {
    let lowEnergyPeriods: [String] = ["2:00 PM - 4:00 PM", "8:00 PM - 9:00 PM"]
    let averageEnergy: Double = 6.5
    let trend: String = "improving"
    
    // Aquí recibimos la sugerencia generada por la IA
    @State var suggestion: AISuggestion? = AISuggestion(
        icon: "🧘",
        title: "Yoga suave",
        description: "Practica yoga entre 2-3 PM para mantener energía",
        time: "Después de comer"
    )

    var body: some View {
        VStack(spacing: 16) {
            // --- AI HEADER ---
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "brain.head.profile.fill")
                        .font(.title)
                    Text("Análisis Inteligente")
                        .font(.headline)
                }
                Text("Basado en tus últimas entradas, detectamos estos patrones")
                    .font(.subheadline)
                    .opacity(0.9)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(LinearGradient(colors: [Color(red: 0.71, green: 0.65, blue: 0.84), Color(red: 0.48, green: 0.78, blue: 0.49)], startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(25)

            // --- ENERGY PATTERNS ---
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "chart.line.downtrend.xyaxis")
                        .foregroundColor(.orange)
                    Text("Períodos de Menor Energía")
                        .font(.system(.body, design: .rounded)).bold()
                }
                
                ForEach(lowEnergyPeriods, id: \.self) { period in
                    HStack {
                        Text("⏰")
                        Text(period)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 1.0, green: 0.98, blue: 0.9))
                    .cornerRadius(15)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.05), radius: 10)

            // --- SINGLE SUGGESTION (SOLO UNA) ---
            if let tip = suggestion {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("Sugerencia Personalizada")
                            .font(.system(.body, design: .rounded)).bold()
                    }
                    
                    HStack(alignment: .top, spacing: 15) {
                        Text(tip.icon)
                            .font(.system(size: 40))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tip.title)
                                .font(.headline)
                            Text(tip.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                Image(systemName: "timer")
                                Text(tip.time)
                            }
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [Color(red: 0.91, green: 0.96, blue: 0.91), Color(red: 0.95, green: 0.97, blue: 0.91)], startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.05), radius: 10)
            }

            // --- ENERGY TREND ---
            HStack {
                VStack(alignment: .leading) {
                    Text("Tendencia de Energía").font(.caption).opacity(0.8)
                    Text(trend == "improving" ? "📈 Mejorando" : "📊 Estable")
                        .font(.title3).bold()
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Promedio").font(.caption).opacity(0.8)
                    Text("\(String(format: "%.1f", averageEnergy))/10")
                        .font(.title2).bold()
                }
            }
            .padding(20)
            .background(LinearGradient(colors: [Color.green.opacity(0.7), Color.blue.opacity(0.6)], startPoint: .leading, endPoint: .trailing))
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .padding()
    }
}
