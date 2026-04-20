import SwiftUI

struct VinculacionQRView: View {
    let token: String
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Vincular dispositivo del niño")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "2D3748"))
            
            Text("Escanea este código desde la aplicación en el dispositivo de tu pequeño superhéroe para sincronizar los medicamentos.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Contenedor del QR
            if let qrImage = QRCodeGenerator.generate(from: token) {
                Image(uiImage: qrImage)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20) // Más redondeado para el estilo Kiddo
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            } else {
                Text("Error al generar el código")
                    .foregroundColor(.red)
            }
            
            // --- ANIMACIÓN JUSTO DEBAJO DEL QR ---
            // Aumentamos el tamaño a 150x150 para que resalte
            AnimacionImagenesAlternas()
                .frame(width: 150, height: 150)
                .padding(.vertical, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("ID de vinculación: \(token)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding(.top, 40)
        .background(Color(hex: "F7FAFC").ignoresSafeArea())
    }
}
