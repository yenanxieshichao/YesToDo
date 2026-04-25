import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let appBrand = AppBrand()
}

struct AppBrand {
    let primaryBlue = Color(red: 0.145, green: 0.392, blue: 0.925)      // #2563EB
    let accentCyan = Color(red: 0.024, green: 0.714, blue: 0.831)       // #06B6D4
    let successGreen = Color(red: 0.133, green: 0.773, blue: 0.369)     // #22C55E
    let dangerRed = Color(red: 0.937, green: 0.267, blue: 0.267)        // #EF4444
    let warningAmber = Color(red: 0.961, green: 0.620, blue: 0.043)     // #F59E0B
}

// MARK: - Semantic Colors (Adaptive)
extension Color {
    static var appBackground: Color {
        Color(nsColor: .windowBackgroundColor)
    }

    static var panelBackground: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    static var elevatedCardBackground: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    static var softSeparator: Color {
        Color.primary.opacity(0.06)
    }

    static var cardBorder: Color {
        Color.primary.opacity(0.06)
    }

    static var inkPrimary: Color {
        Color.primary
    }

    static var inkSecondary: Color {
        Color.secondary
    }

    static var inkTertiary: Color {
        Color(nsColor: .tertiaryLabelColor)
    }

    static var rowHover: Color {
        Color.blue.opacity(0.04)
    }

    static var rowSelected: Color {
        Color.blue.opacity(0.08)
    }

    static var glassBackground: Color {
        Color(nsColor: .windowBackgroundColor).opacity(0.72)
    }

    static var surfaceBackground: Color {
        Color(nsColor: .controlBackgroundColor)
    }

    static var quaternaryColor: Color {
        Color(nsColor: .quaternaryLabelColor)
    }

    static var floatingMaterial: Color {
        Color(nsColor: .windowBackgroundColor).opacity(0.85)
    }
}

// MARK: - Shadows
extension View {
    func softShadow() -> some View {
        self.shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }

    func cardShadow() -> some View {
        self.shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    func floatingShadow() -> some View {
        self.shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Corner Radius
enum PremiumRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xl: CGFloat = 22
    static let xxl: CGFloat = 24
    static let pill: CGFloat = 999
}

// MARK: - Font Sizes
enum PremiumFont {
    static let heroTitle: Font = .system(size: 32, weight: .bold)
    static let sectionTitle: Font = .system(size: 13, weight: .semibold)
    static let body: Font = .system(size: 15, weight: .regular)
    static let caption: Font = .system(size: 12, weight: .regular)
    static let micro: Font = .system(size: 10, weight: .regular)
}

// MARK: - View Modifiers
struct PremiumCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                    .fill(Color.elevatedCardBackground)
                    .cardShadow()
            )
            .overlay(
                RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
    }
}

struct GlassPanelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: PremiumRadius.large, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: PremiumRadius.large, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
    }
}

struct SoftBorderStyle: ViewModifier {
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
    }
}

extension View {
    func premiumCard() -> some View {
        modifier(PremiumCardStyle())
    }

    func glassPanel() -> some View {
        modifier(GlassPanelStyle())
    }

    func softBorder(radius: CGFloat = PremiumRadius.medium) -> some View {
        modifier(SoftBorderStyle(radius: radius))
    }
}

// MARK: - Background Gradient
extension View {
    func premiumBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color(nsColor: .controlBackgroundColor).opacity(0.85),
                    Color.blue.opacity(0.02)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}
