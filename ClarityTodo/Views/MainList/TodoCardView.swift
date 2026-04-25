import SwiftUI
import AppKit

/// 数字转两位字符串（1→"01", 12→"12"）
private func paddedNumber(_ n: Int) -> String {
    n < 10 ? "0\(n)" : "\(n)"
}

// MARK: - macOS 原生双击捕获层
private struct MacDoubleClickCatcher: NSViewRepresentable {
    var onDoubleClick: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDoubleClick: onDoubleClick)
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor

        let recognizer = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleDoubleClick(_:))
        )
        recognizer.numberOfClicksRequired = 2
        recognizer.buttonMask = 0x1

        view.addGestureRecognizer(recognizer)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.onDoubleClick = onDoubleClick
    }

    final class Coordinator: NSObject {
        var onDoubleClick: () -> Void

        init(onDoubleClick: @escaping () -> Void) {
            self.onDoubleClick = onDoubleClick
        }

        @objc func handleDoubleClick(_ recognizer: NSClickGestureRecognizer) {
            if recognizer.state == .ended {
                onDoubleClick()
            }
        }
    }
}

// MARK: - 高级待办行
struct TodoCardView: View {
    let index: Int
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    @State private var isHovering = false
    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @FocusState private var subtaskFocused: Bool
    @State private var isEditingTitle = false
    @State private var editTitle: String = ""
    @FocusState private var titleFocused: Bool
    @State private var showDeleteAlert = false

    private let rowHeight: CGFloat = 56

    private var isSelected: Bool {
        appState.selectedTodo?.id == todo.id
    }

    private var titleSize: CGFloat { appState.globalFontSize }
    private var subtitleSize: CGFloat { max(13, appState.globalFontSize - 2) }

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            HStack(spacing: 10) {
                // 序号（两位数字）
                Text(paddedNumber(index))
                    .font(.system(size: subtitleSize, weight: .regular, design: .monospaced))
                    .foregroundStyle(.tertiary)
                    .frame(width: subtitleSize * 1.5, alignment: .trailing)

                // 标题（编辑态 / 展示态）
                if isEditingTitle {
                    TextField("标题", text: $editTitle)
                        .textFieldStyle(.plain)
                        .font(.system(size: titleSize, weight: .medium))
                        .focused($titleFocused)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color(nsColor: .textBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.appBrand.primaryBlue.opacity(0.5), lineWidth: 1.5)
                        )
                        .onSubmit { commitTitleEdit() }
                        .onKeyPress(.escape) {
                            cancelTitleEdit()
                            return .handled
                        }
                } else {
                    Text(todo.title.isEmpty ? "新待办" : todo.title)
                        .font(.system(size: titleSize, weight: .medium))
                        .lineLimit(3)
                        .strikethrough(todo.isCompleted, color: Color.secondary.opacity(0.4))
                        .foregroundStyle(todo.isCompleted ? Color.secondary.opacity(0.45) : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 4)

                // ── 操作图标（hover 时显示 / 选中时显示）──
                if isHovering || isSelected {
                    HStack(spacing: 2) {
                        // ➕ 加子待办
                        IconPillButton(icon: "plus") {
                            showSubtaskInput = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                subtaskFocused = true
                            }
                        }

                        // ✓ 完成
                        IconPillButton(icon: "checkmark") {
                            viewModel.toggleTodoCompletion(todo)
                        }
                        .foregroundStyle(todo.isCompleted ? .green : .secondary)

                        // 🗑 删除
                        DangerIconButton(icon: "trash") { showDeleteAlert = true }
                    }
                    .transition(.opacity)
                } else {
                    if todo.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.green.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(minHeight: rowHeight)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .onHover { isHovering = $0 }
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture(count: 2).onEnded {
                    startTitleEdit()
                }
            )
            .onTapGesture {
                if isEditingTitle { return }
                appState.selectedTodo = todo
            }

            // ── 子待办列表 ──
            if !todo.subtasks.isEmpty {
                VStack(spacing: 0) {
                    ForEach(
                        Array(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder }).enumerated()),
                        id: \.element.id
                    ) { subIdx, subtask in
                        SubtaskLineView(subtaskIndex: subIdx + 1, subtask: subtask, parentTodo: todo)
                            .environmentObject(viewModel)
                            .environmentObject(appState)
                    }
                }
                .padding(.leading, 48)
            }

            // ── 子待办输入框 ──
            if showSubtaskInput {
                subtaskInputView
                    .padding(.leading, 48)
                    .padding(.bottom, 8)
                    .padding(.trailing, 14)
            }

            // 底部分割线（极淡）
            if !isSelected {
                Rectangle()
                    .fill(Color.primary.opacity(0.04))
                    .frame(height: 1)
                    .padding(.leading, 48)
            }
        }
        .animation(.easeOut(duration: 0.15), value: isHovering)
        .animation(.easeOut(duration: 0.15), value: isSelected)
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteTodo(todo) }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    private var backgroundColor: Color {
        if isSelected { return Color.rowSelected }
        if isHovering { return Color.rowHover }
        return Color.clear
    }

    // MARK: - 子待办输入
    private var subtaskInputView: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 11))
                .foregroundStyle(Color.appBrand.primaryBlue)
            TextField("添加子任务…", text: $subtaskText)
                .textFieldStyle(.plain)
                .font(.system(size: subtitleSize))
                .foregroundStyle(.secondary)
                .focused($subtaskFocused)
                .onSubmit { addSubtask() }
            Button(action: addSubtask) {
                Text("确认")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.appBrand.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(nsColor: .quaternaryLabelColor).opacity(0.12))
        )
    }

    private func addSubtask() {
        guard !subtaskText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addSubtask(to: todo, title: subtaskText)
        subtaskText = ""
        showSubtaskInput = false
    }

    // MARK: - 内联标题编辑
    private func startTitleEdit() {
        guard !isEditingTitle else { return }
        editTitle = todo.title
        isEditingTitle = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            titleFocused = true
        }
    }

    private func commitTitleEdit() {
        let trimmed = editTitle.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            todo.title = trimmed
            viewModel.saveTodo(todo)
        }
        isEditingTitle = false
        titleFocused = false
    }

    private func cancelTitleEdit() {
        isEditingTitle = false
        titleFocused = false
    }
}

// MARK: - 子待办行
struct SubtaskLineView: View {
    let subtaskIndex: Int
    let subtask: SubtaskItem
    let parentTodo: TodoItem

    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    @State private var showDeleteAlert = false
    @State private var isHovering = false
    @State private var isEditing = false
    @State private var editText: String = ""

    @FocusState private var editFocused: Bool

    private var titleSize: CGFloat { max(13, appState.globalFontSize - 2) }

    var body: some View {
        HStack(spacing: 10) {
            Text("\(subtaskIndex).")
                .font(.system(size: max(11, titleSize - 1), weight: .regular, design: .monospaced))
                .foregroundStyle(.tertiary)
                .frame(width: max(18, (titleSize - 1) * 1.3), alignment: .trailing)

            if isEditing {
                editingField
            } else {
                displayTitle
            }

            Spacer(minLength: 4)

            trailingActions
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(isHovering ? Color.rowHover : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovering = hovering
        }
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}

            Button("删除", role: .destructive) {
                viewModel.deleteSubtask(subtask)
            }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }

    private var displayTitle: some View {
        Text(subtask.title.isEmpty ? "子任务" : subtask.title)
            .font(.system(size: titleSize))
            .lineLimit(3)
            .strikethrough(subtask.isCompleted, color: Color.secondary.opacity(0.4))
            .foregroundStyle(subtask.isCompleted ? Color.secondary.opacity(0.45) : .primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay {
                MacDoubleClickCatcher {
                    startEdit()
                }
            }
    }

    private var editingField: some View {
        HStack(spacing: 6) {
            TextField("子任务", text: $editText)
                .textFieldStyle(.plain)
                .font(.system(size: titleSize))
                .focused($editFocused)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color(nsColor: .textBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(Color.appBrand.primaryBlue.opacity(0.65), lineWidth: 1.5)
                )
                .onSubmit {
                    commitEdit()
                }
                .onKeyPress(.escape) {
                    cancelEdit()
                    return .handled
                }
                .onChange(of: editFocused) { _, focused in
                    if !focused && isEditing {
                        commitEdit()
                    }
                }

            Button {
                commitEdit()
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)

            Button {
                cancelEdit()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .frame(width: 24, height: 24)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var trailingActions: some View {
        if isEditing {
            EmptyView()
        } else if isHovering {
            HStack(spacing: 2) {
                IconPillButton(icon: "checkmark") {
                    viewModel.toggleSubtaskCompletion(subtask)
                }

                DangerIconButton(icon: "trash") {
                    showDeleteAlert = true
                }
            }
            .transition(.opacity)
        } else if subtask.isCompleted {
            Image(systemName: "checkmark")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.green.opacity(0.5))
        }
    }

    private func startEdit() {
        guard !isEditing else { return }

        editText = subtask.title
        isEditing = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
            editFocused = true
        }
    }

    private func commitEdit() {
        guard isEditing else { return }

        let trimmed = editText.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            cancelEdit()
            return
        }

        if trimmed != subtask.title {
            viewModel.updateSubtaskTitle(subtask, title: trimmed)
        }

        isEditing = false
        editFocused = false
    }

    private func cancelEdit() {
        editText = subtask.title
        isEditing = false
        editFocused = false
    }
}
