import SwiftUI

extension Color {
    static let appAccent = Color(red: 0.12, green: 0.32, blue: 0.72)
    static let appSuccess = Color(red: 0.12, green: 0.58, blue: 0.30)
    static let appWarning = Color(red: 0.78, green: 0.48, blue: 0.08)
    static let appDanger = Color(red: 0.78, green: 0.18, blue: 0.18)

    static var appCanvas: Color {
        Color(nsColor: .windowBackgroundColor)
    }

    static var appSurface: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    static var appSurfaceElevated: Color {
        Color(nsColor: .textBackgroundColor)
    }

    static var appSeparator: Color {
        Color.primary.opacity(0.08)
    }

    static var rowHover: Color {
        Color.primary.opacity(0.035)
    }

    static var rowSelected: Color {
        Color.appAccent.opacity(0.10)
    }
}

enum AppRadius {
    static let small: CGFloat = 6
    static let medium: CGFloat = 8
    static let large: CGFloat = 12
    static let panel: CGFloat = 14
}

extension View {
    func appBackground() -> some View {
        background(Color.appCanvas.ignoresSafeArea())
    }

    func subtleBorder(_ radius: CGFloat = AppRadius.medium) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .stroke(Color.appSeparator, lineWidth: 0.75)
        )
    }
}
