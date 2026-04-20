//
//  AnimaciónSonrisa.swift
//  Kiddo
//
//  Created by Valentina Garcia on 19/04/26.
//

import Foundation
import Foundation
import SwiftUI
import Combine

struct AnimacionSonrisa: View {
    // 1. Lista de tus 4 imágenes
    let secuencia = ["recomendacion_1", "recomendacion_2", "recomendacion_3"]
    
    // 2. Estado para el fotograma actual
    @State private var fotogramaActual = 0
    
    // 3. Temporizador (0.2 o 0.3 segundos para que se vea fluido como una película)
    let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Image(secuencia[fotogramaActual])
            .resizable()
            .scaledToFit()
            .frame(width: 90, height: 90)
            // La transición de opacidad ayuda a que no se vea un salto brusco
            .transition(.opacity)
            .id(fotogramaActual)
            .onReceive(timer) { _ in
                // Lógica circular: 0, 1, 2, 3 y vuelve a 0
                fotogramaActual = (fotogramaActual + 1) % secuencia.count
            }
            .animation(.linear(duration: 0), value: fotogramaActual)
    }
}
