import SwiftUI

struct CustomizationView: View {
    @Binding var avatarCapa: String
    @Binding var avatarAccesorio: String
    
    @State private var tempCapa: String
    @State private var tempAccesorio: String
    
    @Environment(\.dismiss) var dismiss
    
    let opcionesCapas = ["capa_verde", "capa_azul", "capa_roja", "capa_morada"]
    let opcionesAccesorios = ["kiddo_rana", "kiddo_conejo"]
    
    init(avatarCapa: Binding<String>, avatarAccesorio: Binding<String>) {
        self._avatarCapa = avatarCapa
        self._avatarAccesorio = avatarAccesorio
        self._tempCapa = State(initialValue: avatarCapa.wrappedValue)
        self._tempAccesorio = State(initialValue: avatarAccesorio.wrappedValue)
    }
    
    var tempAvatar: Avatar {
        Avatar(
            capa: tempCapa.isEmpty ? nil : tempCapa,
            accesorio: tempAccesorio.isEmpty ? nil : tempAccesorio
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            AvatarView(avatar: tempAvatar)
                .frame(height: 220)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.8, blue: 0.8), // Rosa pastel
                                    Color(red: 0.9, green: 0.9, blue: 1.0)  // Azul/Morado pastel
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: Color(red: 1.0, green: 0.8, blue: 0.8).opacity(0.6), radius: 12, x: 0, y: 8)
                )
                .padding(.horizontal)
                .padding(.top, 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // --- SECCIÓN CAPAS ---
                    Text("Elige tu capa")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "2D3748"))
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            Spacer().frame(width: 5)
                            
                            SelectionCard(title: "Ninguna", isSelected: tempCapa.isEmpty) {
                                tempCapa = ""
                            }
                            
                            ForEach(opcionesCapas, id: \.self) { capa in
                                OptionImageCard(name: capa, isSelected: tempCapa == capa) {
                                    tempCapa = capa
                                }
                            }
                            Spacer().frame(width: 5)
                        }
                    }
                    
                    Divider().padding(.horizontal)
                    
                    // Accesos
                    Text("Elige un accesorio")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "2D3748"))
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            Spacer().frame(width: 5)
                            
                            SelectionCard(title: "Ninguno", isSelected: tempAccesorio.isEmpty) {
                                tempAccesorio = ""
                            }
                            
                            ForEach(opcionesAccesorios, id: \.self) { acc in
                                OptionImageCard(name: acc, isSelected: tempAccesorio == acc) {
                                    tempAccesorio = acc
                                }
                            }
                            Spacer().frame(width: 5)
                        }
                    }
                }
            }
            
            // Botón guardar
            Button(action: {
                avatarCapa = tempCapa
                avatarAccesorio = tempAccesorio
                dismiss()
            }) {
                Text("Guardar Cambios")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "7BC67E"), Color.teal]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: Color(hex: "7BC67E").opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationTitle("Personalizar")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(hex: "F7FAFC").ignoresSafeArea())
    }
}

// MARK: - Subcomponentes Visuales

// Tarjeta para los botones de texto
struct SelectionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(isSelected ? .white : Color(hex: "2D3748"))
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? Color(hex: "7BC67E") : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: isSelected ? Color(hex: "7BC67E").opacity(0.4) : Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        }
    }
}

// Tarjeta para las imágenes 
struct OptionImageCard: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? Color(hex: "7BC67E").opacity(0.15) : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected ? Color(hex: "7BC67E") : Color.gray.opacity(0.2), lineWidth: isSelected ? 2 : 1)
                )
                .shadow(color: isSelected ? Color(hex: "7BC67E").opacity(0.2) : Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
        }
    }
}
