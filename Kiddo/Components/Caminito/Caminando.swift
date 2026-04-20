//
//  Caminando.swift
//  Kiddo
//
//  Created by Valentina Garcia on 19/04/26.
//

import SwiftUI

struct WalkingAvatar: View, Animatable {
    var progress: Double // 0 a 100
    let points: [CGPoint]
    let size: CGSize
    
    // Esto es lo que hace la magia de la animación en SwiftUI
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    var body: some View {
        let position = calculatePosition()
        let currentFrame = calculateFrame()
        
        Image("caminar_\(currentFrame)")
            .resizable()
            .scaledToFit()
            .frame(width: 70, height: 70) // Ajusta al tamaño de tu icono
            .position(position)
            // Pequeño salto al caminar para darle un toque más orgánico (opcional)
            .offset(y: currentFrame % 2 == 0 ? 0 : -2)
    }
    
    // MARK: - Lógica de Animación de Sprite
    private func calculateFrame() -> Int {
        // Tolerancia para saber si estamos detenidos en un checkpoint (0%, 25%, 50%, 75%, 100%)
        let remainder = progress.truncatingRemainder(dividingBy: 25)
        let isAtCheckpoint = remainder < 0.1 || remainder > 24.9
        
        if isAtCheckpoint {
            return 0 // Postura estática / de pie
        } else {
            // El frame cambia según la distancia recorrida.
            // Multiplica por 1.5 o 2.0 para hacer que mueva las piernas más rápido o lento
            return Int(progress * 1.5) % 8
        }
    }
    
    // MARK: - Lógica de Bézier Cúbica (Espejo de tu OrganicPath)
    private func calculatePosition() -> CGPoint {
        // Aseguramos que el progreso esté entre 0 y 1
        let p = max(0, min(100, progress)) / 100.0
        let totalSegments = CGFloat(points.count - 1)
        
        // Determinar en qué segmento (0 a 3) estamos y el tiempo local 't' (0 a 1) dentro de ese segmento
        let rawSegment = p * totalSegments
        let segmentIndex = min(Int(rawSegment), points.count - 2)
        let t = rawSegment - CGFloat(segmentIndex)
        
        // Puntos de inicio y fin reales
        let startRaw = points[segmentIndex]
        let endRaw = points[segmentIndex + 1]
        
        let start = CGPoint(x: startRaw.x * size.width, y: startRaw.y * size.height)
        let end = CGPoint(x: endRaw.x * size.width, y: endRaw.y * size.height)
        
        // Obtenemos los puntos de control exactos que diseñaste
        let controls = getControlPoints(for: segmentIndex + 1, start: start, end: end)
        
        // Ecuación paramétrica de Bézier Cúbica
        let u = 1.0 - t
        let tt = t * t
        let uu = u * u
        let uuu = uu * u
        let ttt = tt * t
        
        var pos = CGPoint.zero
        pos.x = uuu * start.x + 3 * uu * t * controls.c1.x + 3 * u * tt * controls.c2.x + ttt * end.x
        pos.y = uuu * start.y + 3 * uu * t * controls.c1.y + 3 * u * tt * controls.c2.y + ttt * end.y
        
        return pos
    }
    
    private func getControlPoints(for i: Int, start: CGPoint, end: CGPoint) -> (c1: CGPoint, c2: CGPoint) {
        let dx = end.x - start.x
        let dy = end.y - start.y
        
        // ¡Estos son tus mismos twirls!
        if i == 1 {
            return (CGPoint(x: start.x + dx * 0.4, y: start.y + dy * 0.1),
                    CGPoint(x: start.x + dx * 0.6, y: end.y + dy * -0.2))
        } else if i == 2 {
            return (CGPoint(x: start.x + dx * 0.2, y: start.y + dy * 0.6),
                    CGPoint(x: start.x + dx * 0.5, y: end.y + dy * 0.8))
        } else if i == 3 {
            return (CGPoint(x: start.x + dx * 0.8, y: start.y + dy * -0.1),
                    CGPoint(x: start.x + dx * 0.6, y: end.y + dy * 0.3))
        } else { // i == 4
            return (CGPoint(x: start.x + dx * 0.3, y: start.y + dy * 0.4),
                    CGPoint(x: start.x + dx * 0.1, y: end.y + dy * -0.2))
        }
    }
}
