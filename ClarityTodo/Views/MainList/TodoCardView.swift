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
                    .font(.body)
                    .foregroundStyle(.tertiary)
                    .frame(width: 24, alignment: .trailing)

                // 标题（双击编辑）
                if isEditingTitle {
                    HStack(spacing: 6) {
                        TextField("待办标题", text: $editTitle, onCommit: commitTitle)
                            .textFieldStyle(.plain)
                            .font(.body)
                            .onExitCommand { commitTitle() }
                        Button(action: commitTitle) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.green)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    Text(todo.title.isEmpty ? "新待办" : todo.title)
                        .font(.body)
                        .lineLimit(2)
                        .strikethrough(todo.isCompleted)
                        .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture(count: 2) {
                            editTitle = todo.title
                            isEditingTitle = true
                        }
                }

                Spacer(minLength: 8)

                if !isEditingTitle {
                    // ── 右侧三个大按钮 ──
                    HStack(spacing: 0) {
                        // ➕ 添加子待办
                        bigIcon("plus", color: .secondary)
                            .onTapGesture { showSubtaskInput.toggle() }

                        // —— 划掉/取消（可切换）
                        bigIcon("minus", color: todo.isCompleted ? .green : .secondary)
                            .onTapGesture { viewModel.toggleTodoCompletion(todo) }

                        // ✕ 删除
                        bigIcon("xmark", color: .secondary)
                            .onTapGesture { showDeleteAlert = true }
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)

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
                .padding(.leading, 34)
                .padding(.trailing, 14)
                .padding(.bottom, 6)
            }

            // ── 子待办输入框 ──
            if showSubtaskInput {
                HStack(spacing: 8) {
                    Text("    ")
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 10))
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
                .padding(.leading, 34)
                .padding(.trailing, 14)
                .padding(.bottom, 10)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color.primary.opacity(0.05), lineWidth: 0.5)
        )
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteTodo(todo) }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    // MARK: - 大图标（加大的点击区域）
    private func bigIcon(_ name: String, color: Color) -> some View {
        Image(systemName: name)
            .font(.system(size: iconSize, weight: .regular))
            .foregroundStyle(color)
            .frame(minWidth: hitWidth, minHeight: hitHeight)
            .contentShape(Rectangle())
    }

    private func addSubtask() {
        guard !subtaskText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addSubtask(to: todo, title: subtaskText)
        subtaskText = ""
        showSubtaskInput = false // 添加后关闭，不留空输入行
    }

    private func commitTitle() {
        guard !editTitle.isEmpty else { isEditingTitle = false; return }
        todo.title = editTitle
        viewModel.saveTodo(todo)
        isEditingTitle = false
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
                .font(.system(size: 8))
                .foregroundStyle(.tertiary)
                .frame(width: 12)

            Text(subtask.title)
                .font(.callout)
                .lineLimit(1)
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            // 子待办按钮（同样加大）
            HStack(spacing: 0) {
                // —— 划掉/取消划掉
                Image(systemName: "minus")
                    .font(.system(size: 15))
                    .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                    .frame(minWidth: 30, minHeight: 26)
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.toggleSubtaskCompletion(subtask) }

                // ✕ 删除
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .frame(minWidth: 30, minHeight: 26)
                    .contentShape(Rectangle())
                    .onTapGesture { showDeleteAlert = true }
            }
        }
        .padding(.vertical, 4)
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteSubtask(subtask) }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }
}
