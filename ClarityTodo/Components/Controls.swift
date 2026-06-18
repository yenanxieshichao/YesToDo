import SwiftUI

struct MetricChip: View {
    let icon: String
    let text: String
    var tint: Color = .secondary

    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(tint)
            .labelStyle(.titleAndIcon)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(tint.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous))
    }
}

struct IconPillButton: View {
    let icon: String
    var accessibilityLabel: String = ""
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isHovering ? Color.appAccent : .secondary)
                .frame(width: 28, height: 28)
                .background(isHovering ? Color.appAccent.opacity(0.09) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous))
        }
        .buttonStyle(.plain)
        .help(accessibilityLabel)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

struct DangerIconButton: View {
    let icon: String
    var accessibilityLabel: String = ""
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(isHovering ? Color.appDanger : .secondary)
                .frame(width: 28, height: 28)
                .background(isHovering ? Color.appDanger.opacity(0.10) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous))
        }
        .buttonStyle(.plain)
        .help(accessibilityLabel)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

struct PrimaryActionButton: View {
    let title: String
    var icon: String = "plus"
    let disabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 13)
                .padding(.vertical, 8)
                .background(disabled ? Color.appAccent.opacity(0.35) : Color.appAccent)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .animation(.easeOut(duration: 0.12), value: disabled)
    }
}

struct TaskCheckbox: View {
    let isCompleted: Bool
    var size: CGFloat = 18
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Circle()
                .strokeBorder(borderColor, lineWidth: 1.5)
                .background(Circle().fill(fillColor))
                .frame(width: size, height: size)
                .overlay {
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: max(8, size * 0.48), weight: .bold))
                            .foregroundStyle(Color.appSuccess)
                    }
                }
        }
        .buttonStyle(.plain)
        .help(isCompleted ? "标记为未完成" : "标记为完成")
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }

    private var borderColor: Color {
        if isCompleted { return .appSuccess }
        return isHovering ? .appAccent : Color.primary.opacity(0.25)
    }

    private var fillColor: Color {
        if isCompleted { return Color.appSuccess.opacity(0.12) }
        return isHovering ? Color.appAccent.opacity(0.07) : Color.clear
    }
}

struct EmptyListView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "checklist.unchecked")
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(Color.secondary.opacity(0.55))

            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
        }
        .frame(maxWidth: .infinity, minHeight: 280)
    }
}
