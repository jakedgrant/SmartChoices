import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension Color {
    /// Returns a color on the opposite side of the color wheel.
    var complementary: Color {
#if canImport(UIKit)
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        if uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let compHue = CGFloat(truncating: ((hue + 0.5).truncatingRemainder(dividingBy: 1) as NSNumber))
            return Color(hue: compHue, saturation: saturation, brightness: brightness)
        }
#endif
        return self
    }
}
