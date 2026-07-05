import SwiftUI

private struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = .accentColor
}

extension EnvironmentValues {
    var themeColor: Color {
        get { self[ThemeColorKey.self] }
        set { self[ThemeColorKey.self] = newValue }
    }
}

extension View {
    /// Injects a color into the environment so descendant views can access it via
    /// `\Environment(\.themeColor)`.
    func themeColor(_ color: Color) -> some View {
        environment(\.themeColor, color)
    }
}
