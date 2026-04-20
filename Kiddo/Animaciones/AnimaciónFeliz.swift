//
//  AnimaciónFeliz.swift
//  Kiddo
//
//  Created by Valentina Garcia on 19/04/26.
//

import Foundation
import SwiftUI
import Combine

struct AnimacionFeliz: View {
    
    let secuencia = ["feliz_1", "feliz_2", "feliz_3", "feliz_4"]
    
  
    @State private var fotogramaActual = 0
    
    let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Image(secuencia[fotogramaActual])
            .resizable()
            .scaledToFit()
            .frame(width: 120, height: 120)
            .transition(.opacity)
            .id(fotogramaActual)
            .onReceive(timer) { _ in
                fotogramaActual = (fotogramaActual + 1) % secuencia.count
            }
            .animation(.linear(duration: 0), value: fotogramaActual)
    }
}
