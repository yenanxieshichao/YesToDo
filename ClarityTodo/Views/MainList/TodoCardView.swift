import SwiftUI
import AppKit

/// 阿拉伯数字转中文数字
private func chineseNumber(_ n: Int) -> String {
    let map = ["零","一","二","三","四","五","六","七","八","九","十",
               "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十"]
    return n <= 20 ? map[n] : "\(n)"
}

// MARK: - 待办卡片
struct TodoCardView: View {
    let index: Int
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel

    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @State private var showDeleteAlert = false
    @State private var isEditingTitle = false
    @State private var editTitle: String = ""
    @State private var showFontPanel = false

    private let iconSize: CGFloat = 18
    private let hitWidth: CGFloat = 34
    private let hitHeight: CGFloat = 30

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            HStack(spacing: 10) {
                // 中文序号（固定宽度对齐）
                Text("\(chineseNumber(index))、")
                    .font(.system(size: CGFloat(todo.titleFontSize - 2), weight: .regular))
                    .foregroundStyle(.tertiary)
                    .frame(width: 34, alignment: .trailing)

                // 标题
                if isEditingTitle {
                    editingTitleView
                } else {
                    displayTitleView
                }

                Spacer(minLength: 8)

                if !isEditingTitle {
                    // 字体按钮
                    Button(action: { showFontPanel.toggle() }) {
                        Image(systemName: "textformat")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .frame(minWidth: 28, minHeight: 28)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showFontPanel, arrowEdge: .top) {
                        FontSettingsPanel(
                            fontSize: Binding(
                                get: { CGFloat(todo.titleFontSize) },
                                set: { todo.titleFontSize = Double($0); viewModel.saveTodo(todo) }
                            )
                        )
                        .padding(14)
                        .frame(width: 200)
                    }

                    // ── 右侧操作图标 ──
                    HStack(spacing: 0) {
                        bigIcon("plus")
                            .onTapGesture { showSubtaskInput.toggle() }
                        bigIcon("checkmark")
                            .foregroundStyle(todo.isCompleted ? .green : .secondary)
                            .onTapGesture { viewModel.toggleTodoCompletion(todo) }
                        bigIcon("xmark")
                            .onTapGesture { showDeleteAlert = true }
                    }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)

            // ── 子待办列表（1. 2. 对齐在一个层级）──
            if !todo.subtasks.isEmpty {
                VStack(spacing: 0) {
                    ForEach(
                        Array(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder }).enumerated()),
                        id: \.element.id
                    ) { subIdx, subtask in
                        SubtaskLineView(
                            subtaskIndex: subIdx + 1,
                            subtask: subtask,
                            parentTodo: todo
                        )
                        .environmentObject(viewModel)
                    }
                }
                .padding(.bottom, 6)
            }

            // ── 子待办输入框 ──
            if showSubtaskInput {
                subtaskInputView
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteTodo(todo) }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    // MARK: - 显示标题
    private var displayTitleView: some View {
        Text(todo.title.isEmpty ? "新待办" : todo.title)
            .font(.system(size: CGFloat(todo.titleFontSize), weight: .medium))
            .lineLimit(3)
            .strikethrough(todo.isCompleted, color: Color.secondary.opacity(0.5))
            .foregroundStyle(todo.isCompleted ? Color.secondary.opacity(0.65) : .primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture(count: 2) {
                editTitle = todo.title
                isEditingTitle = true
            }
    }

    // MARK: - 编辑标题
    private var editingTitleView: some View {
        HStack(spacing: 6) {
            TextField("待办标题", text: $editTitle, onCommit: commitTitle)
                .textFieldStyle(.plain)
                .font(.system(size: CGFloat(todo.titleFontSize), weight: .medium))
                .onExitCommand { commitTitle() }

            Button(action: commitTitle) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 15))
                    .foregroundStyle(.green)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - 子待办输入
    private var subtaskInputView: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 11))
                .foregroundStyle(.blue)
            TextField("输入子待办…", text: $subtaskText)
                .textFieldStyle(.plain)
                .font(.callout)
                .foregroundStyle(.secondary)
                .onSubmit { addSubtask() }
            Button(action: addSubtask) {
                Text("添加")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 50) // 与子待办序号对齐
        .padding(.trailing, 14)
        .padding(.bottom, 10)
    }

    // MARK: - 大图标
    private func bigIcon(_ name: String) -> some View {
        Image(systemName: name)
            .font(.system(size: iconSize, weight: .regular))
            .foregroundStyle(.secondary)
            .frame(minWidth: hitWidth, minHeight: hitHeight)
            .contentShape(Rectangle())
    }

    private func addSubtask() {
        guard !subtaskText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addSubtask(to: todo, title: subtaskText)
        subtaskText = ""
        showSubtaskInput = false
    }

    private func commitTitle() {
        guard !editTitle.isEmpty else { isEditingTitle = false; return }
        todo.title = editTitle
        viewModel.saveTodo(todo)
        isEditingTitle = false
    }
}

// MARK: - 字体设置面板
struct FontSettingsPanel: View {
    @Binding var fontSize: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "textformat")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                Text("字体")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                Button(action: { adjustSize(-1) }) {
                    Image(systemName: "minus")
                        .font(.system(size: 10, weight: .bold))
                        .frame(width: 24, height: 24)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)

                Slider(value: $fontSize, in: 10...36, step: 1)
                    .controlSize(.small)

                Button(action: { adjustSize(1) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .frame(width: 24, height: 24)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 4) {
                ForEach([12, 14, 16, 18, 20, 24, 28, 32], id: \.self) { size in
                    Button(action: { fontSize = CGFloat(size) }) {
                        Text("\(size)")
                            .font(.system(size: 10))
                            .foregroundStyle(fontSize == CGFloat(size) ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                            .background(fontSize == CGFloat(size) ? Color.blue : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                    .buttonStyle(.plain)
                }
            }

            VStack(spacing: 2) {
                Divider()
                Text("预览")
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
                Text("Aa")
                    .font(.system(size: fontSize, weight: .medium))
                    .foregroundStyle(.primary)
                Text("\(Int(fontSize))pt")
                    .font(.system(size: 9))
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private func adjustSize(_ delta: Int) {
        fontSize = max(10, min(36, fontSize + CGFloat(delta)))
    }
}

// MARK: - 子待办行（序号：1. 2. 3.）
struct SubtaskLineView: View {
    let subtaskIndex: Int
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var showDeleteAlert = false

    var body: some View {
        HStack(spacing: 10) {
            // 子序号：固定宽度 18，右对齐，与上面主序号列对齐
            Text("\(subtaskIndex).")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.tertiary)
                .frame(width: 18, alignment: .trailing)

            // 缩进占位（让子待办文本对齐在主待办标题的起始位置）
            // 主序号 34pt + gap 10pt = 44pt 偏移
            // 子序号 18pt + gap 4pt = 22pt → 再补 22pt → 总 44pt
            // 但为了可视化对齐更精确，做透明占位
            Color.clear
                .frame(width: 22)

            Text(subtask.title)
                .font(.system(size: 15))
                .lineLimit(3)
                .strikethrough(subtask.isCompleted, color: Color.secondary.opacity(0.5))
                .foregroundStyle(subtask.isCompleted ? Color.secondary.opacity(0.65) : Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 8)

            // 子待办操作图标
            HStack(spacing: 0) {
                Image(systemName: "checkmark")
                    .font(.system(size: 16))
                    .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                    .frame(minWidth: 34, minHeight: 28)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.toggleSubtaskCompletion(subtask) }

                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 34, minHeight: 28)
                    .contentShape(Rectangle())
                    .onTapGesture { showDeleteAlert = true }
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 16)
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteSubtask(subtask) }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }
}
