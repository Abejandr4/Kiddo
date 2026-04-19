import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            // 1. INICIO
            NavigationStack {
                InicioHijo()
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
                DiarioHijo()
                    .navigationTitle("Mi Diario")
            }
            .tabItem {
                Label("Diario", systemImage: "heart.text.square.fill")
            }
            
            // 3. CALENDARIO
            NavigationStack {
                CalendarioHijo()
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
    MainView()
}
