import SwiftUI

struct MainListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var newTodoText: String = ""
    @State private var showDeleteAlert = false
    @State private var todoToDelete: TodoItem? = nil
    @State private var showCalendarPopover = false
    @FocusState private var newTodoFocused: Bool

    private var dateTodos: [TodoItem] {
        viewModel.todosForDate(appState.selectedDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 头部标题
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(appState.headerTitle)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    if !appState.headerSubtitle.isEmpty {
                        Text(appState.headerSubtitle)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                // 日历小图标
                Button(action: { showCalendarPopover.toggle() }) {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showCalendarPopover, arrowEdge: .top) {
                    CompactCalendarView(selectedDate: $appState.selectedDate, isPresented: $showCalendarPopover)
                        .environmentObject(viewModel)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 8)

            Divider()
                .padding(.horizontal, 16)

            // 待办列表
            ScrollView {
                LazyVStack(spacing: 2) {
                    ForEach(Array(dateTodos.enumerated()), id: \.element.id) { index, todo in
                        TodoLineRow(
                            index: index + 1,
                            todo: todo,
                            isSelected: appState.selectedTodo?.id == todo.id
                        )
                        .environmentObject(viewModel)
                        .environmentObject(appState)
                        .onTapGesture {
                            appState.selectedTodo = todo
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
            }
            .scrollContentBackground(.hidden)

            Spacer(minLength: 0)

            // 底部添加待办输入框
            VStack(spacing: 0) {
                Divider()
                HStack(spacing: 10) {
                    TextField("输入新的待办事项… 按回车添加", text: $newTodoText)
                        .textFieldStyle(.plain)
                        .font(.body)
                        .focused($newTodoFocused)
                        .onSubmit {
                            addNewTodo()
                        }

                    Button(action: addNewTodo) {
                        Text("添加待办")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(newTodoText.trimmingCharacters(in: .whitespaces).isEmpty
                                ? Color.blue.opacity(0.3)
                                : Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .buttonStyle(.plain)
                    .disabled(newTodoText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
            }
        }
        .frame(minWidth: 320)
        .background(Color(nsColor: .controlBackgroundColor))
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let todo = todoToDelete {
                    viewModel.deleteTodo(todo)
                }
            }
        } message: {
            Text("确定要删除「\(todoToDelete?.title ?? "")」吗？")
        }
        .onReceive(NotificationCenter.default.publisher(for: .focusNewTodoCommand)) { _ in
            newTodoFocused = true
        }
    }

    private func addNewTodo() {
        guard let _ = viewModel.createTodo(title: newTodoText, date: appState.selectedDate) else { return }
        newTodoText = ""
        newTodoFocused = true
    }
}

// MARK: - 待办清单行
struct TodoLineRow: View {
    let index: Int
    let todo: TodoItem
    let isSelected: Bool
    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState
    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @State private var showDeleteAlert = false

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                // 序号
                Text("\(index).")
                    .font(.body)
                    .foregroundStyle(.tertiary)
                    .frame(width: 24, alignment: .trailing)

                // 标题
                Text(todo.title.isEmpty ? "新待办" : todo.title)
                    .font(.body)
                    .lineLimit(2)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 8)

                // 操作图标（hover 时显示）
                HStack(spacing: 12) {
                    // 添加子待办
                    Button(action: { showSubtaskInput.toggle() }) {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 13))
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .help("添加子待办")

                    // 划掉/完成
                    Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                        Image(systemName: todo.isCompleted
                            ? "textformat.strikethrough"
                            : "textformat.strikethrough")
                            .font(.system(size: 13))
                            .foregroundStyle(todo.isCompleted ? .green : .secondary.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .help(todo.isCompleted ? "取消完成" : "标记完成")

                    // 删除
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                    .buttonStyle(.plain)
                    .help("删除")
                }
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.blue.opacity(0.08) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .contentShape(Rectangle())

            // 子待办
            if !todo.subtasks.isEmpty {
                ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                    SubtaskLineRow(subtask: subtask, parentTodo: todo)
                        .environmentObject(viewModel)
                        .environmentObject(appState)
                }
            }

            // 子待办输入框
            if showSubtaskInput {
                HStack(spacing: 8) {
                    Text("    ") // 缩进占位
                    TextField("输入子待办…", text: $subtaskText)
                        .textFieldStyle(.plain)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .onSubmit {
                            addSubtask()
                        }
                    Button(action: addSubtask) {
                        Image(systemName: "arrow.right.circle.fill")
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.leading, 32)
                .padding(.trailing, 8)
                .padding(.vertical, 4)
            }
        }
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                viewModel.deleteTodo(todo)
            }
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
struct SubtaskLineRow: View {
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack(spacing: 8) {
            Text("   ") // 缩进
            Image(systemName: "minus")
                .font(.system(size: 8))
                .foregroundStyle(.tertiary)
                .frame(width: 12)

            Text(subtask.title)
                .font(.callout)
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)

            Spacer()

            HStack(spacing: 10) {
                Button(action: { viewModel.toggleSubtaskCompletion(subtask) }) {
                    Image(systemName: subtask.isCompleted
                        ? "textformat.strikethrough"
                        : "textformat.strikethrough")
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary.opacity(0.5))
                }
                .buttonStyle(.plain)
                .help("划掉")

                Button(action: { viewModel.deleteSubtask(subtask) }) {
                    Image(systemName: "trash")
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary.opacity(0.5))
                }
                .buttonStyle(.plain)
                .help("删除")
            }
        }
        .padding(.vertical, 3)
        .padding(.leading, 32)
        .padding(.trailing, 8)
    }
}
