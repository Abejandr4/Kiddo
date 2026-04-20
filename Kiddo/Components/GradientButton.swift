import SwiftUI

struct GradientButtonStyle: ButtonStyle {
    var startColor: Color
    var endColor: Color
    var foregroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
            configuration.label
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.leading)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [startColor, endColor]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule())
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ActionButton: View {
    let title: String
    let startColor: Color
    let endColor: Color
    let textColor: Color
    let fontSize: CGFloat
    let action: () -> Void
    
    init(
        _ title: String,
        startColor: Color = Color(red: 0.53, green: 0.84, blue: 0.61),
        endColor: Color = Color(red: 0.55, green: 0.86, blue: 0.95),
        textColor: Color = .white,
        fontSize: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.startColor = startColor
        self.endColor = endColor
        self.textColor = textColor
        self.fontSize = fontSize
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: fontSize, weight: .bold))
        }
        .buttonStyle(
            GradientButtonStyle(
                startColor: startColor,
                endColor: endColor,
                foregroundColor: textColor
            )
        )
    }
}

// ... (Tu Preview se mantiene igualito)

// 3. El Preview
struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
       
        ZStack {
            Color(red: 0.98, green: 0.96, blue: 0.93)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                ActionButton("Registrar\nmedicina") {
                    print("Botón 1 presionado")
                }
                
                Divider()
                    .padding(.horizontal)
                
                Text("Variaciones Personalizadas")
                    .font(.headline)
                    .foregroundColor(.gray)
                
               
                ActionButton(
                    "Confirmar",
                    startColor: .orange,
                    endColor: .red
                ) {
                    print("Botón 2 presionado")
                }
                
                
                ActionButton(
                    "Guardar Cambios",
                    startColor: .purple,
                    endColor: .blue
                ) {
                    print("Botón 3 presionado")
                }
                
               
                ActionButton(
                    "Añadir\nSíntoma",
                    startColor: Color(red: 1.0, green: 0.8, blue: 0.8), // Rosa pastel
                    endColor: Color(red: 0.9, green: 0.9, blue: 1.0),  // Azul pastel
                    textColor: .black.opacity(0.7)
                ) {
                    print("Botón 4 presionado")
                }
            }
            .padding()
        }
    }
}
