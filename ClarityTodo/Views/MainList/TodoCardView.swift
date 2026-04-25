import SwiftUI

struct TodoCardView: View {
    let index: Int
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            HStack(spacing: 10) {
                // 序号
                Text("\(index).")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.tertiary)
                    .frame(width: 22, alignment: .trailing)

                // 标题
                Text(todo.title)
                    .font(.system(size: 15, weight: .medium))
                    .lineLimit(2)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 8)

                // ── 右侧图标 ──
                HStack(spacing: 16) {
                    // ➕ 添加子待办
                    Button(action: { showSubtaskInput.toggle() }) {
                        Image(systemName: "plus")
                            .font(.system(size: 14, weight: .regular))
                    }
                    .buttonStyle(.plain)
                    .help("添加子待办")

                    // —— 划掉
                    Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                        Image(systemName: "minus")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(todo.isCompleted ? .green : .primary)
                    }
                    .buttonStyle(.plain)
                    .help(todo.isCompleted ? "取消完成" : "标记完成")

                    // ✕ 删除
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 13, weight: .regular))
                    }
                    .buttonStyle(.plain)
                    .help("删除")
                }
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 10)
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
                .padding(.leading, 32)
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
                        Image(systemName: "return")
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 32)
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

    private func addSubtask() {
        viewModel.addSubtask(to: todo, title: subtaskText)
        subtaskText = ""
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

            Spacer()

            HStack(spacing: 12) {
                // 划掉
                Button(action: { viewModel.toggleSubtaskCompletion(subtask) }) {
                    Image(systemName: "minus")
                        .font(.system(size: 11))
                        .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                }
                .buttonStyle(.plain)
                .help("划掉")

                // 删除
                Button(action: { showDeleteAlert = true }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help("删除")
            }
        }
        .padding(.vertical, 3)
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteSubtask(subtask) }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }
}
