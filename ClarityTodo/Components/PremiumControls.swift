import SwiftUI

// MARK: - Pill Chip
struct InfoChip: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
            Text(text)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.08))
        .clipShape(Capsule())
    }
}

// MARK: - Icon Pill Button
struct IconPillButton: View {
    let icon: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isHovering ? Color.blue : .secondary)
                .frame(width: 30, height: 30)
                .background(isHovering ? Color.blue.opacity(0.08) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Primary Action Button
struct PrimaryActionButton: View {
    let title: String
    let disabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: PremiumRadius.medium, style: .continuous)
                        .fill(disabled ? Color.blue.opacity(0.3) : Color.appBrand.primaryBlue)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .animation(.easeOut(duration: 0.15), value: disabled)
    }
}

// MARK: - Ghost Button
struct GhostButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .medium))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(isHovering ? Color.appBrand.primaryBlue : .secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(isHovering ? Color.blue.opacity(0.06) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Danger Icon Button
struct DangerIconButton: View {
    let icon: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isHovering ? Color.appBrand.dangerRed : .secondary)
                .frame(width: 30, height: 30)
                .background(isHovering ? Color.appBrand.dangerRed.opacity(0.08) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Premium Checkbox
struct PremiumCheckbox: View {
    let isCompleted: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Circle()
                .strokeBorder(isCompleted ? Color.appBrand.successGreen : Color.primary.opacity(0.25), lineWidth: 1.5)
                .frame(width: 20, height: 20)
                .background(
                    Circle()
                        .fill(isCompleted ? Color.appBrand.successGreen.opacity(0.12) : Color.clear)
                        .frame(width: 24, height: 24)
                )
                .overlay {
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.appBrand.successGreen)
                    }
                }
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .scaleEffect(isHovering ? 1.05 : 1.0)
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Empty State
struct PremiumEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    let hint: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.06))
                    .frame(width: 80, height: 80)
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.appBrand.primaryBlue.opacity(0.6))
            }

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text(hint)
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)
                .padding(.top, 4)

            Spacer()
        }
    }
}

// MARK: - Premium Divider
struct PremiumDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.06))
            .frame(height: 1)
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: PremiumRadius.medium, style: .continuous)
                .fill(Color.surfaceBackground)
                .softBorder(radius: PremiumRadius.medium)
        )
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isCompleted ? Color.appBrand.successGreen : Color.appBrand.primaryBlue)
                .frame(width: 6, height: 6)
            Text(isCompleted ? "已完成" : "进行中")
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(isCompleted ? Color.appBrand.successGreen : Color.appBrand.primaryBlue)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            (isCompleted ? Color.appBrand.successGreen : Color.appBrand.primaryBlue).opacity(0.08)
        )
        .clipShape(Capsule())
    }
}
