//
//  AnimaciónMedicina.swift
//  Kiddo
//
//  Created by Valentina Garcia on 19/04/26.
//

import SwiftUI
import Combine

struct AnimacionImagenesAlternas: View {
    // 1. Array con los nombres de tus dos imágenes
    let imagenes = ["pastillas_1", "pastillas_2"]
    
    // 2. Estado para rastrear el índice de la imagen actual
    @State private var indiceImagenActual = 0
    
    // 3. Definir el temporizador (cambia cada 0.5 segundos)
    let temporizador = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        // Tu contenedor centrado (puedes usar HStack + Spacers como antes)
        HStack {
            Spacer()
            
            // 4. Mostrar la imagen basada en el índice actual
            Image(imagenes[indiceImagenActual])
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                // Opcional: Añadir una transición suave al cambiar
                .transition(.opacity)
                // 5. Usar id para forzar a SwiftUI a tratar el cambio como una nueva vista para la animación
                .id(indiceImagenActual)
            
            Spacer()
        }
        // 6. Escuchar el temporizador y actualizar el índice
        .onReceive(temporizador) { _ in
            // Alternar entre 0 y 1 usando el operador módulo (%)
            withAnimation(.easeInOut(duration: 0)) { // Animación suave al cambiar
                indiceImagenActual = (indiceImagenActual + 1) % imagenes.count
            }
        }
    }
}

// Para previsualizar
struct AnimacionImagenesAlternas_Previews: PreviewProvider {
    static var previews: some View {
        AnimacionImagenesAlternas()
    }
}
