//
//  ShiftingMeshGradientView.swift
//  obey
//
//  Created by Jake Grant on 7/4/25.
//

import SwiftUI

struct ShiftingMeshGradientView: View {
    let color: Color
    
    private var complement: Color {
        color.complement
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            let x = 0.25 + (sin(timeline.date.timeIntervalSince1970) + 1) / 4
            let y = 0.25 + (cos(timeline.date.timeIntervalSince1970) + 1) / 4
            
            MeshGradient(width: 3, height: 3, points: [
                [0, 0], [Float(y), 0], [1, 0],
                [0, Float(x)], [Float(x), Float(y)], [1, Float(y)],
                [0, 1], [Float(y), 1], [1, 1]
            ], colors: [
                .clear, .clear, .clear,
                color, color, color,
                complement, color, complement
            ])
            .animation(.easeInOut, value: color)
            .overlay(.ultraThinMaterial)
        }
        
    }
}
#Preview {
    ShiftingMeshGradientView(color: .red)
}
