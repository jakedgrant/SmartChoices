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

