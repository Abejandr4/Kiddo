//
//  AnimaciónMedicina.swift
//  Kiddo
//
//  Created by Valentina Garcia on 19/04/26.
//

import SwiftUI
import Combine

struct AnimacionImagenesAlternas: View {
    let imagenes = ["pastillas_1", "pastillas_2"]
    
 
    @State private var indiceImagenActual = 0
    
 
    let temporizador = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    var body: some View {
        
        HStack {
            Spacer()
            
           
            Image(imagenes[indiceImagenActual])
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                
                .transition(.opacity)
                                .id(indiceImagenActual)
            
            Spacer()
        }
        .onReceive(temporizador) { _ in
            
            withAnimation(.easeInOut(duration: 0)) {
                indiceImagenActual = (indiceImagenActual + 1) % imagenes.count
            }
        }
    }
}

struct AnimacionImagenesAlternas_Previews: PreviewProvider {
    static var previews: some View {
        AnimacionImagenesAlternas()
    }
}
