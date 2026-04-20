import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins // Este es el que habilita .qrCodeGenerator()

struct QRCodeGenerator {
    static func generate(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        // Convertimos el string a data
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        // Obtenemos la imagen de salida
        if let outputImage = filter.outputImage {
            // Los códigos QR son muy pequeños por defecto (ej. 27x27 px).
            // Necesitamos escalarlo para que no se vea borroso.
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            // Convertimos CIImage a UIImage
            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return nil
    }
}
