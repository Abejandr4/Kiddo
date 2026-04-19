import SwiftUI

struct MainViewPadre: View {
    
    var body: some View {
        TabView {
            // 1. INICIO
            NavigationStack {
                InicioPadre()
                    .navigationTitle("¡Hola!")
                    .background(
                        VStack {
                            Spacer()
                            HStack {
                                Image("pandaBien")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 170, height: 200)
                                    .padding(.leading, -20) // Ajusta la posición según necesites
                                Spacer()
                            }
                        }
                    )
            }
            .tabItem {
                Label("Inicio", systemImage: "house.fill")
            }
            
            // 2. DIARIO
            NavigationStack {
                MedicinasPadre()
            }
            .tabItem {
                Label("Medicinas", systemImage: "heart.text.square.fill")
            }
            
            // 3. CALENDARIO
            NavigationStack {
                CalendarioPadre()
                    .navigationTitle("Mi Calendario")
            }
            .tabItem {
                Label("Calendario", systemImage: "calendar")
            }
            
            // 4. AJUSTES
            NavigationStack {
                AjustesHijo()
                    .navigationTitle("Ajustes")
            }
            .tabItem {
                Label("Ajustes", systemImage: "gearshape.fill")
            }
        }
        
    }
}

#Preview {
    MainViewPadre()
}
