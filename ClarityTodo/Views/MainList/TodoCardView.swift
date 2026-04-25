import SwiftUI

/// 数字转两位字符串（1→"01", 12→"12"）
private func paddedNumber(_ n: Int) -> String {
    n < 10 ? "0\(n)" : "\(n)"
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
    @State private var showDeleteAlert = false
    @State private var showFontPanel = false

    private let rowHeight: CGFloat = 56

    private var isSelected: Bool {
        appState.selectedTodo?.id == todo.id
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            HStack(spacing: 10) {
                // 序号（两位数字）
                Text(paddedNumber(index))
                    .font(.system(size: 13, weight: .regular, design: .monospaced))
                    .foregroundStyle(.tertiary)
                    .frame(width: 24, alignment: .trailing)

                // 完成 checkbox
                Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                    Circle()
                        .strokeBorder(todo.isCompleted ? Color.appBrand.successGreen : Color.primary.opacity(0.2), lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                        .background(
                            Circle()
                                .fill(todo.isCompleted ? Color.appBrand.successGreen.opacity(0.1) : Color.clear)
                                .frame(width: 26, height: 26)
                        )
                        .overlay {
                            if todo.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(Color.appBrand.successGreen)
                            }
                        }
                }
                .buttonStyle(.plain)

                // 标题
                Text(todo.title.isEmpty ? "新待办" : todo.title)
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(3)
                    .strikethrough(todo.isCompleted, color: Color.secondary.opacity(0.4))
                    .foregroundStyle(todo.isCompleted ? Color.secondary.opacity(0.45) : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 4)

                // ── 操作图标（hover 时显示 / 选中时显示）──
                if isHovering || isSelected {
                    HStack(spacing: 2) {
                        // 字体
                        IconPillButton(icon: "textformat") { showFontPanel.toggle() }
                            .popover(isPresented: $showFontPanel, arrowEdge: .top) {
                                FontSettingsPanel(fontSize: Binding(
                                    get: { CGFloat(todo.titleFontSize) },
                                    set: { todo.titleFontSize = Double($0); viewModel.saveTodo(todo) }
                                ))
                                .padding(14)
                                .frame(width: 200)
                            }

                        // ➕ 加子待办
                        IconPillButton(icon: "plus") { showSubtaskInput.toggle() }

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
                    // 不 hover 时只显示完成状态对号
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
            .onTapGesture {
                appState.selectedTodo = todo
            }
            .contentShape(Rectangle())

            // ── 子待办列表 ──
            if !todo.subtasks.isEmpty {
                VStack(spacing: 0) {
                    ForEach(
                        Array(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder }).enumerated()),
                        id: \.element.id
                    ) { subIdx, subtask in
                        SubtaskLineView(subtaskIndex: subIdx + 1, subtask: subtask, parentTodo: todo)
                            .environmentObject(viewModel)
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
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
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
}

// MARK: - 字体面板
struct FontSettingsPanel: View {
    @Binding var fontSize: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "textformat")
                    .font(.system(size: 11))
                Text("字体大小")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Button(action: { fontSize = max(10, fontSize - 1) }) {
                    Image(systemName: "minus")
                        .font(.system(size: 9, weight: .bold))
                        .frame(width: 22, height: 22)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)

                Slider(value: $fontSize, in: 10...36, step: 1)
                    .controlSize(.small)

                Button(action: { fontSize = min(36, fontSize + 1) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 9, weight: .bold))
                        .frame(width: 22, height: 22)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 4) {
                ForEach([12, 14, 16, 18, 20, 24, 28, 32], id: \.self) { size in
                    Button(action: { fontSize = CGFloat(size) }) {
                        Text("\(size)")
                            .font(.system(size: 9))
                            .foregroundStyle(fontSize == CGFloat(size) ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 3)
                            .background(fontSize == CGFloat(size) ? Color.appBrand.primaryBlue : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                    .buttonStyle(.plain)
                }
            }

            PremiumDivider()

            Text("Aa")
                .font(.system(size: fontSize, weight: .medium))
                .foregroundStyle(.primary)
            Text("\(Int(fontSize))pt")
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - 子待办行
struct SubtaskLineView: View {
    let subtaskIndex: Int
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var showDeleteAlert = false
    @State private var isHovering = false

    var body: some View {
        HStack(spacing: 10) {
            // 子序号
            Text("\(subtaskIndex).")
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundStyle(.tertiary)
                .frame(width: 18, alignment: .trailing)

            // 小圆点（视觉连接线效果）
            Circle()
                .fill(Color.primary.opacity(0.12))
                .frame(width: 4, height: 4)

            // 文字
            Text(subtask.title)
                .font(.system(size: 14))
                .lineLimit(3)
                .strikethrough(subtask.isCompleted, color: Color.secondary.opacity(0.4))
                .foregroundStyle(subtask.isCompleted ? Color.secondary.opacity(0.45) : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 4)

            // 操作（hover 显示）
            if isHovering {
                HStack(spacing: 2) {
                    IconPillButton(icon: "checkmark") {
                        viewModel.toggleSubtaskCompletion(subtask)
                    }
                    DangerIconButton(icon: "xmark") { showDeleteAlert = true }
                }
                .transition(.opacity)
            } else if subtask.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.green.opacity(0.5))
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(isHovering ? Color.rowHover : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .onHover { isHovering = $0 }
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteSubtask(subtask) }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }
}
