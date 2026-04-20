
import SwiftUI
import SwiftData

struct MainViewPadre: View {
    @AppStorage("linkingToken") private var linkingToken: String = ""
    
    var body: some View {
        TabView {
            // --- 1. INICIO (Con QR Centrado) ---
            NavigationStack {
                VStack(spacing: 0) {
                    // Botón de QR centrado en la parte superior
                    NavigationLink(destination: VinculacionQRView(token: linkingToken)) {
                        VStack {
                            Image(systemName: "qrcode")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.primary)
                            
                            Text("Vincular dispositivo")
                                .font(.subheadline)
                                .padding(5)
                                .bold()
                        }
                        .padding(20)
                        .background(Color(.systemBackground))
                        .cornerRadius(15)
                        .shadow(radius: 2)
                    }
                    .padding(30)

                    // Tu vista de inicio debajo
                    InicioPadre(todayMedsTaken: 2, totalMeds: 5, progress: 0.4)
                }
                .navigationTitle("¡Hola!")
            }
            .tabItem { Label("Inicio", systemImage: "house.fill") }
            
            // --- 2. MEDICINAS (DIARIO) ---
            NavigationStack {
                MedicamentosView()
            }
            .tabItem { Label("Medicinas", systemImage: "heart.text.square.fill") }
            
            // --- 3. CALENDARIO ---
            NavigationStack {
                CalendarioPadre()
            }
            .tabItem { Label("Calendario", systemImage: "calendar") }
            
            // --- 4. CHAT ---
            NavigationStack {
                AIChatView()
            }
            .tabItem { Label("Chat", systemImage: "star.bubble") }
            
            // --- 5. AJUSTES ---
            NavigationStack {
                AjustesPadre()
                    .navigationTitle("Ajustes")
            }
            .tabItem { Label("Ajustes", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    MainViewPadre()
        // ✅ Le agregamos el modelContainer al Preview para que no marque error el simulador
        .modelContainer(for: [DiaryEntry.self, CalendarEvent.self], inMemory: true)
}
