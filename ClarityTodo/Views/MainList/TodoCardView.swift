import SwiftUI

struct TodoCardView: View {
    let index: Int
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel

    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @State private var showDeleteAlert = false
    @State private var isEditingTitle = false
    @State private var editTitle: String = ""

    // 按钮尺寸
    private let iconSize: CGFloat = 18
    private let hitWidth: CGFloat = 34
    private let hitHeight: CGFloat = 30

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            HStack(spacing: 10) {
                // 序号
                Text("\(index).")
                    .font(.system(size: CGFloat(todo.titleFontSize - 2), weight: .regular))
                    .foregroundStyle(.tertiary)
                    .frame(width: 26, alignment: .trailing)

                // 标题
                if isEditingTitle {
                    editingTitleView
                } else {
                    displayTitleView
                }

                Spacer(minLength: 8)

                if !isEditingTitle {
                    // ── 右侧三个大按钮 ──
                    HStack(spacing: 0) {
                        // ➕ 添加子待办
                        bigIcon("plus", color: .secondary)
                            .onTapGesture { showSubtaskInput.toggle() }

                        // —— 划掉/取消
                        bigIcon("minus", color: todo.isCompleted ? .green : .secondary)
                            .onTapGesture { viewModel.toggleTodoCompletion(todo) }

                        // ✕ 删除
                        bigIcon("xmark", color: .secondary)
                            .onTapGesture { showDeleteAlert = true }
                    }
                }
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)

            // ── 子待办列表 ──
            if !todo.subtasks.isEmpty {
                VStack(spacing: 0) {
                    ForEach(
                        todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder }),
                        id: \.id
                    ) { subtask in
                        SubtaskLineView(subtask: subtask, parentTodo: todo)
                            .environmentObject(viewModel)
                    }
                }
                .padding(.leading, 36)
                .padding(.trailing, 14)
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

    // MARK: - 显示标题（加大字体 + 加粗划掉线）
    private var displayTitleView: some View {
        Text(todo.title.isEmpty ? "新待办" : todo.title)
            .font(.system(size: CGFloat(todo.titleFontSize), weight: .medium))
            .lineLimit(2)
            .strikethrough(todo.isCompleted, color: todo.isCompleted ? .secondary : .clear)
            .foregroundStyle(todo.isCompleted ? .secondary : .primary)
            .opacity(todo.isCompleted ? 0.65 : 1.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture(count: 2) {
                editTitle = todo.title
                isEditingTitle = true
            }
    }

    // MARK: - 编辑标题（带字体调节）
    private var editingTitleView: some View {
        HStack(spacing: 6) {
            TextField("待办标题", text: $editTitle, onCommit: commitTitle)
                .textFieldStyle(.plain)
                .font(.system(size: CGFloat(todo.titleFontSize), weight: .medium))
                .onExitCommand { commitTitle() }

            // 字号调节
            HStack(spacing: 1) {
                // 减小
                Button(action: { adjustFontSize(-2) }) {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 13))
                }
                .buttonStyle(.plain)
                .help("减小字号")

                // 当前字号
                Text("\(Int(todo.titleFontSize))")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 20)

                // 增大
                Button(action: { adjustFontSize(2) }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 13))
                }
                .buttonStyle(.plain)
                .help("增大字号")
            }
            .foregroundStyle(.blue)
            .padding(.horizontal, 4)

            // 完成编辑
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
            Text("    ")
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
        .padding(.leading, 36)
        .padding(.trailing, 14)
        .padding(.bottom, 10)
    }

    // MARK: - 大图标
    private func bigIcon(_ name: String, color: Color) -> some View {
        Image(systemName: name)
            .font(.system(size: iconSize, weight: .regular))
            .foregroundStyle(color)
            .frame(minWidth: hitWidth, minHeight: hitHeight)
            .contentShape(Rectangle())
    }

    // MARK: - 操作
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

    private func adjustFontSize(_ delta: Double) {
        let newSize = max(12, min(32, todo.titleFontSize + delta))
        todo.titleFontSize = newSize
        viewModel.saveTodo(todo)
    }
}

// MARK: - 子待办行
struct SubtaskLineView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @State private var showDeleteAlert = false

    var body: some View {
        HStack(spacing: 8) {
            Text("    ")
            Image(systemName: "minus")
                .font(.system(size: 10))
                .foregroundStyle(.tertiary)
                .frame(width: 12)

            Text(subtask.title)
                .font(.system(size: 15))
                .lineLimit(1)
                .strikethrough(subtask.isCompleted, color: .secondary)
                .foregroundStyle(subtask.isCompleted ? Color.secondary.opacity(0.65) : Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            HStack(spacing: 0) {
                // —— 划掉/取消划掉
                Image(systemName: "minus")
                    .font(.system(size: 16))
                    .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                    .frame(minWidth: 32, minHeight: 28)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.toggleSubtaskCompletion(subtask) }

                // ✕ 删除
                Image(systemName: "xmark")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 32, minHeight: 28)
                    .contentShape(Rectangle())
                    .onTapGesture { showDeleteAlert = true }
            }
        }
        .padding(.vertical, 5)
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteSubtask(subtask) }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }
}
