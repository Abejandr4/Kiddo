//Organic Path.swift
//  Kiddo
//
//  Created by Valentina Garcia on 18/04/26.
//
import SwiftUI

struct OrganicPath: Shape {
    let points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard points.count >= 2 else { return path }

        let realPoints = points.map { CGPoint(x: $0.x * rect.width, y: $0.y * rect.height) }

        // Iniciamos el camino en el primer punto
        path.move(to: realPoints[0])


        // Iteramos a través de cada par de puntos consecutivos para crear un twirl único
        for i in 1..<realPoints.count {
            let start = realPoints[i-1]
            let end = realPoints[i]

            // DISEÑOS DE CONTROL POINTS PARA CADA TWIRL (basados en tu sketch)

            if i == 1 {
                // Twirl sutil para el primer tramo (abajo a la derecha)
                let c1 = CGPoint(x: start.x + (end.x - start.x) * 0.4, y: start.y + (end.y - start.y) * 0.1) // Se eleva poco
                let c2 = CGPoint(x: start.x + (end.x - start.x) * 0.6, y: end.y + (end.y - start.y) * -0.2) // Baja tras el "imán" de end
                path.addCurve(to: end, control1: c1, control2: c2)

            } else if i == 2 {
                // Twirl en forma de "mueca" para el segundo tramo (derecha a arriba-izquierda)
                let c1 = CGPoint(x: start.x + (end.x - start.x) * 0.2, y: start.y + (end.y - start.y) * 0.6) // Curva hacia arriba y derecha
                let c2 = CGPoint(x: start.x + (end.x - start.x) * 0.5, y: end.y + (end.y - start.y) * 0.8) // Se eleva mucho cerca de end
                path.addCurve(to: end, control1: c1, control2: c2)

            } else if i == 3 {
                // Twirl con un lazo más pronunciado para el tercer tramo (arriba-izquierda a arriba-derecha)
                let c1 = CGPoint(x: start.x + (end.x - start.x) * 0.8, y: start.y + (end.y - start.y) * -0.1) // Curva hacia arriba y derecha
                let c2 = CGPoint(x: start.x + (end.x - start.x) * 0.6, y: end.y + (end.y - start.y) * 0.3) // Baja y se curvea hacia la izquierda
                path.addCurve(to: end, control1: c1, control2: c2)

            } else if i == 4 {
                // Twirl final con un lazo cruzado para el cuarto tramo (arriba-derecha a ¡Día completo!)
                let c1 = CGPoint(x: start.x + (end.x - start.x) * 0.3, y: start.y + (end.y - start.y) * 0.4) // Curva hacia arriba y izquierda
                let c2 = CGPoint(x: start.x + (end.x - start.x) * 0.1, y: end.y + (end.y - start.y) * -0.2) // Se cruza por debajo de start
                path.addCurve(to: end, control1: c1, control2: c2)
            }
        }

        return path
    }
}
