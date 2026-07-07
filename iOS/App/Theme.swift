import SwiftUI

enum Theme {
    static let background = Color(red: 0.094, green: 0.102, blue: 0.133)
    static let accent = Color(red: 0.557, green: 0.561, blue: 0.796)
    static let ink = Color(red: 0.929, green: 0.929, blue: 0.965)
    static let warm = Color(red: 0.788, green: 0.631, blue: 0.353)
    static let fontDesign: Font.Design = .default

    static func title(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: fontDesign)
    }
    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: fontDesign)
    }
    static func label(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .semibold, design: fontDesign)
    }
}
