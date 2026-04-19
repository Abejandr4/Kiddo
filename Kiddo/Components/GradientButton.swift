import SwiftUI

// 1. Definimos el Estilo de Botón Personalizado
// Esto maneja la apariencia visual: degradado, forma e icono.
struct GradientButtonStyle: ButtonStyle {
    // Colores personalizables para el degradado y el texto/icono
    var startColor: Color
    var endColor: Color
    var foregroundColor: Color
    
    // El método makeBody define cómo se ve el botón
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 12) {
        
            
            // El contenido del botón (el texto)
            configuration.label
                .font(.title3.bold()) // Fuente grande y en negrita
                .foregroundColor(foregroundColor)
                .multilineTextAlignment(.leading) // Alineación a la izquierda para texto largo
        }
        .padding(.vertical, 20)   // Relleno vertical generoso
        .padding(.horizontal, 30) // Relleno horizontal generoso
        
        // --- LA MAGIA DEL FONDO ---
        .background(
            // Creamos el degradado lineal
            LinearGradient(
                gradient: Gradient(colors: [startColor, endColor]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        
        // --- LA FORMA DE CÁPSULA ---
        .clipShape(Capsule())
        
        // --- EFECTO VISUAL AL PRESIONAR ---
        .opacity(configuration.isPressed ? 0.8 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// 2. Definimos la Vista del Botón (un 'wrapper' conveniente)
// Esto hace que usar el botón sea más limpio en tu código principal.
struct ActionButton: View {
    // Propiedades personalizables
    let title: String
    let startColor: Color
    let endColor: Color
    let textColor: Color
    let action: () -> Void
    
    // Un inicializador con valores predeterminados (inspirados en tu imagen)
    init(
        _ title: String,
        startColor: Color = Color(red: 0.53, green: 0.84, blue: 0.61), // Verde azulado
        endColor: Color = Color(red: 0.55, green: 0.86, blue: 0.95),  // Celeste
        textColor: Color = .white,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.startColor = startColor
        self.endColor = endColor
        self.textColor = textColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
        }
        // Aplicamos nuestro estilo personalizado
        .buttonStyle(
            GradientButtonStyle(
                startColor: startColor,
                endColor: endColor,
                foregroundColor: textColor
            )
        )
    }
}

// 3. El Preview
struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        // Un contenedor para el preview con un fondo similar
        ZStack {
            Color(red: 0.98, green: 0.96, blue: 0.93) // Fondo crema claro
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Ejemplo 1: El diseño original (usando valores predeterminados)
                ActionButton("Registrar\nmedicina") {
                    print("Botón 1 presionado")
                }
                
                Divider()
                    .padding(.horizontal)
                
                Text("Variaciones Personalizadas")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                // Ejemplo 2: Diferentes colores y texto corto
                ActionButton(
                    "Confirmar",
                    startColor: .orange,
                    endColor: .red
                ) {
                    print("Botón 2 presionado")
                }
                
                // Ejemplo 3: Colores oscuros y texto blanco
                ActionButton(
                    "Guardar Cambios",
                    startColor: .purple,
                    endColor: .blue
                ) {
                    print("Botón 3 presionado")
                }
                
                // Ejemplo 4: Colores pastel suaves con texto oscuro
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
