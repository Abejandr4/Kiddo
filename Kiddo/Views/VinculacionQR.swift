import SwiftUI

struct VinculacionQRView: View {
    let token: String
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Vincular dispositivo del niño")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Escanea este código desde la aplicación en el dispositivo del niño para sincronizar los medicamentos.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            if let qrImage = QRCodeGenerator.generate(from: token) {
                Image(uiImage: qrImage)
                    .resizable()
                    .interpolation(.none) // Crucial para que el QR no se vea borroso
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 5)
            } else {
                Text("Error al generar el código")
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("ID de vinculación: \(token)")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding()
            
            Spacer()
        }
        .padding(.top, 40)
    }
}
