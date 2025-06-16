import SwiftUI

enum StandardColor: String, CaseIterable, Codable {
    case red, orange, yellow, green, mint, teal, cyan, blue, indigo, purple, pink, brown, gray

    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .mint: return .mint
        case .teal: return .teal
        case .cyan: return .cyan
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        case .brown: return .brown
        case .gray: return .gray
        }
    }

#if canImport(UIKit)
    init(_ color: Color) {
        let uiColor = UIColor(color)
        if uiColor.isEqual(UIColor.red) { self = .red }
        else if uiColor.isEqual(UIColor.orange) { self = .orange }
        else if uiColor.isEqual(UIColor.yellow) { self = .yellow }
        else if uiColor.isEqual(UIColor.green) { self = .green }
        else if uiColor.isEqual(UIColor.systemMint) { self = .mint }
        else if uiColor.isEqual(UIColor.systemTeal) { self = .teal }
        else if uiColor.isEqual(UIColor.cyan) { self = .cyan }
        else if uiColor.isEqual(UIColor.blue) { self = .blue }
        else if uiColor.isEqual(UIColor.systemIndigo) { self = .indigo }
        else if uiColor.isEqual(UIColor.purple) { self = .purple }
        else if uiColor.isEqual(UIColor.systemPink) { self = .pink }
        else if uiColor.isEqual(UIColor.brown) { self = .brown }
        else if uiColor.isEqual(UIColor.gray) { self = .gray }
        else { self = .mint }
    }
#endif
}

