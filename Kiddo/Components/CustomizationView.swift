import SwiftUI

struct CustomizationView: View {
    // El avatar "permanente" que viene de fuera
    @Binding var userAvatar: Avatar
    
    // El avatar temporal para previsualizar cambios
    @State private var tempAvatar: Avatar
    
    // Datos de los assets
    let opcionesCapas = ["capa_verde", "capa_azul", "capa_roja", "capa_morada"]
    let opcionesAccesorios = ["kiddo_rana", "kiddo_conejo"]
    
    // Inicializador para copiar el estado actual al temporal
    init(userAvatar: Binding<Avatar>) {
        self._userAvatar = userAvatar
        self._tempAvatar = State(initialValue: userAvatar.wrappedValue)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Personaliza tu Kiddo")
                .font(.headline)
            
            // --- TOP: Previsualización constante ---
            AvatarView(avatar: tempAvatar)
                .background(Circle().fill(Color.gray.opacity(0.1)))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    
                    // --- SECCIÓN CAPAS ---
                    Text("Capas").bold()
                    HStack {
                        Button("None") { tempAvatar.capa = nil }
                            .buttonStyle(.bordered)
                        
                        ForEach(opcionesCapas, id: \.self) { capa in
                            OptionImage(name: capa) { tempAvatar.capa = capa }
                        }
                    }
                    
                    Divider()
                    
                    // --- SECCIÓN ACCESORIOS ---
                    Text("Accesorios").bold()
                    HStack {
                        Button("None") { tempAvatar.accesorio = nil }
                            .buttonStyle(.bordered)
                        
                        ForEach(opcionesAccesorios, id: \.self) { acc in
                            OptionImage(name: acc) { tempAvatar.accesorio = acc }
                        }
                    }
                }
                .padding()
            }
            
            // --- BOTÓN GUARDAR ---
            Button(action: {
                userAvatar = tempAvatar // Pasamos lo temporal a lo permanente
                print("¡Avatar Guardado!")
            }) {
                Text("Guardar Cambios")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
}

// Componente pequeño para los botones del menú
struct OptionImage: View {
    let name: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(5)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.3)))
        }
    }
}
