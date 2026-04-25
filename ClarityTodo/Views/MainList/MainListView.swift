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
            // ── 头部（居中）──
            headerView
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 10)

            Divider()
                .padding(.horizontal, 20)

            // ── 待办列表 ──
            if dateTodos.isEmpty {
                emptyState
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 6) {
                            ForEach(Array(dateTodos.enumerated()), id: \.element.id) { index, todo in
                                TodoCardView(index: index + 1, todo: todo)
                                    .environmentObject(viewModel)
                                    .environmentObject(appState)
                                    .id(todo.id)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                    }
                    .scrollContentBackground(.hidden)
                }
            }

            Spacer(minLength: 0)

            // ── 底部添加输入框 ──
            addTodoBar
        }
        .background(
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color(nsColor: .controlBackgroundColor)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let todo = todoToDelete { viewModel.deleteTodo(todo) }
            }
        } message: {
            Text("确定要删除「\(todoToDelete?.title ?? "")」吗？")
        }
        .onReceive(NotificationCenter.default.publisher(for: .focusNewTodoCommand)) { _ in
            newTodoFocused = true
        }
    }

    // MARK: - 头部（居中）
    private var headerView: some View {
        HStack {
            Spacer()

            VStack(alignment: .center, spacing: 4) {
                Text(appState.headerTitle)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.primary)
                if !appState.headerSubtitle.isEmpty {
                    Text(appState.headerSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button(action: { showCalendarPopover.toggle() }) {
                Image(systemName: "calendar")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.secondary)
                    .padding(8)
                    .background(.quaternary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showCalendarPopover, arrowEdge: .top) {
                CompactCalendarView(selectedDate: $appState.selectedDate, isPresented: $showCalendarPopover)
                    .environmentObject(viewModel)
            }
        }
    }

    // MARK: - 空状态
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 52))
                .foregroundStyle(.quaternary)
            Text("今天还没有待办")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            Text("在下方输入框添加今天要做的事")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
            Spacer()
        }
    }

    // MARK: - 添加待办栏
    private var addTodoBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.blue)

                TextField("输入新的待办事项…", text: $newTodoText)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .focused($newTodoFocused)
                    .onSubmit { addNewTodo() }

                Button(action: addNewTodo) {
                    Text("添加")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background(
                            newTodoText.trimmingCharacters(in: .whitespaces).isEmpty
                                ? Color.blue.opacity(0.3)
                                : Color.blue
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(newTodoText.trimmingCharacters(in: .whitespaces).isEmpty)
                .animation(.easeOut(duration: 0.15), value: newTodoText.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            .background(.ultraThinMaterial)
        }
    }

    private func addNewTodo() {
        guard let _ = viewModel.createTodo(title: newTodoText, date: appState.selectedDate) else { return }
        newTodoText = ""
        newTodoFocused = true
    }
}
