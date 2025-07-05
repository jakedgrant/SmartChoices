import SwiftUI

enum StandardColor: String, CaseIterable, Codable {
    case green, yellow, orange, red, pink, purple, indigo, blue, cyan, teal, mint, primary

    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .teal: return .teal
        case .cyan: return .cyan
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        case .mint: return .mint
        case .primary: return .primary
        }
    }
}

extension Color {
    
    var complement: Color {
        switch self {
        case .red: .orange
        case .orange: .yellow
        case .yellow: .orange
        case .green: .teal
        case .teal:  .mint
        case .cyan: .mint
        case .blue: .mint
        case .indigo: .purple
        case .purple: .indigo
        case .pink: .red
        case .mint: .green
        case .primary: .primary
        default: .clear
        }
    }
}

#Preview {
    
    let colors = StandardColor.allCases
    VStack {
        ForEach(colors, id: \.self) { color in
            ZStack {
                MeshGradient(
                    width: 2,
                    height: 2,
                    points: [
                        .init(x: 0, y: 0), .init(x: 1, y: 0),
                        .init(x: 0, y: 1), .init(x: 1, y: 1)
                    ],
                    colors: [
                        color.color.complement, color.color, color.color, color.color.complement
                    ]
                )
                
                Text(color.rawValue)
            }
        }
    }
}

