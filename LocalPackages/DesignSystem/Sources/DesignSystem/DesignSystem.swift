import SwiftUI

@available(macOS 10.15, *)
public enum DesignSystem {
    public enum Colors {
        public static let screenBackgroundTop = Color(red: 0.97, green: 0.96, blue: 1.0)
        public static let screenBackgroundBottom = Color(red: 0.9, green: 0.91, blue: 0.98)
        public static let surface = Color.white
        public static let surfaceSecondary = Color(red: 0.96, green: 0.96, blue: 1.0)
        public static let cardBorder = Color(red: 0.88, green: 0.89, blue: 0.95)
        public static let textPrimary = Color(red: 0.13, green: 0.12, blue: 0.33)
        public static let textSecondary = Color(red: 0.4, green: 0.38, blue: 0.56)
        public static let mutedText = Color(red: 0.61, green: 0.61, blue: 0.7)
        public static let brandPrimary = Color(red: 0.35, green: 0.28, blue: 0.7)
        public static let brandSecondary = Color(red: 0.98, green: 0.44, blue: 0.56)
        public static let accent = Color(red: 1.0, green: 0.78, blue: 0.25)
        public static let warningBackground = Color(red: 1.0, green: 0.95, blue: 0.89)
        public static let warningForeground = Color(red: 0.78, green: 0.43, blue: 0.07)
        public static let overlayStart = Color(.sRGB, red: 0.02, green: 0.02, blue: 0.07, opacity: 0.85)
        public static let overlayEnd = Color(.sRGB, red: 0.1, green: 0.1, blue: 0.15, opacity: 0.0)
        public static let darkBackground = Color(red: 6 / 255, green: 7 / 255, blue: 24 / 255)
        public static let darkCard = Color(red: 19 / 255, green: 23 / 255, blue: 34 / 255)
    }

    public enum Layout {
        public static let screenPadding: CGFloat = 20
        public static let sectionSpacing: CGFloat = 28
        public static let componentSpacing: CGFloat = 16
        public static let cardCornerRadius: CGFloat = 28
        public static let rowCornerRadius: CGFloat = 22
    }

    public enum Gradients {
        public static let screenBackground = LinearGradient(
            colors: [Colors.screenBackgroundTop, Colors.screenBackgroundBottom],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

@available(macOS 10.15, *)
public extension Color {
    init?(hex: String) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }

        guard cleaned.count == 6, let value = Int(cleaned, radix: 16) else {
            return nil
        }

        let red = Double((value >> 16) & 0xFF) / 255.0
        let green = Double((value >> 8) & 0xFF) / 255.0
        let blue = Double(value & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
