import SwiftUI

struct MainListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel

    @State private var newTodoText = ""
    @State private var showCalendarPopover = false
    @State private var showCarryOverAlert = false
    @State private var carryOverCount = 0
    @FocusState private var newTodoFocused: Bool

    private var dateTodos: [TodoItem] {
        viewModel.todosForDate(appState.selectedDate)
    }

    private var completedCount: Int {
        dateTodos.filter(\.isCompleted).count
    }

    private var openCount: Int {
        dateTodos.count - completedCount
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, 24)
                .padding(.top, 22)
                .padding(.bottom, 14)

            composer
                .padding(.horizontal, 24)
                .padding(.bottom, 14)

            metrics
                .padding(.horizontal, 24)
                .padding(.bottom, 12)

            Divider()
                .opacity(0.55)

            taskList
        }
        .onReceive(NotificationCenter.default.publisher(for: .focusNewTodoCommand)) { _ in
            focusComposer()
        }
        .onChange(of: appState.selectedDate) { _, _ in
            appState.selectedTodo = nil
            focusComposer()
        }
        .alert("继承完成", isPresented: $showCarryOverAlert) {
            Button("好的") {}
        } message: {
            Text(carryOverCount > 0 ? "已将 \(carryOverCount) 条未完成待办复制到今天。" : "没有需要继承的待办。")
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 3) {
                Text(appState.headerTitle)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.primary)

                Text(appState.headerSubtitle)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 12)

            if appState.isTodaySelected && viewModel.hasUnfinishedBeforeToday(referenceDate: appState.selectedDate) {
                Button {
                    carryOverCount = viewModel.carryOverUnfinishedTodos(to: appState.selectedDate)
                    showCarryOverAlert = true
                } label: {
                    Label("继承未完成", systemImage: "arrow.triangle.merge")
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.appWarning.opacity(0.10))
                        .foregroundStyle(Color.appWarning)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            if !appState.isTodaySelected {
                Button {
                    appState.selectedDate = Date()
                } label: {
                    Label("今天", systemImage: "arrow.uturn.left")
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.appAccent.opacity(0.08))
                        .foregroundStyle(Color.appAccent)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            Button {
                showCalendarPopover.toggle()
            } label: {
                Image(systemName: "calendar")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .background(Color.primary.opacity(0.055))
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
            }
            .buttonStyle(.plain)
            .help("选择日期")
            .popover(isPresented: $showCalendarPopover, arrowEdge: .top) {
                CompactCalendarView(selectedDate: $appState.selectedDate, isPresented: $showCalendarPopover)
                    .environmentObject(viewModel)
            }
        }
    }

    private var composer: some View {
        HStack(spacing: 11) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.appAccent)

            TextField(appState.isTodaySelected ? "添加今天要做的事" : "添加到 \(shortDate(appState.selectedDate))", text: $newTodoText)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .focused($newTodoFocused)
                .onSubmit(addNewTodo)

            PrimaryActionButton(
                title: "添加",
                disabled: newTodoText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                action: addNewTodo
            )
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(Color.appSurfaceElevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.panel, style: .continuous))
        .subtleBorder(AppRadius.panel)
    }

    private var metrics: some View {
        HStack(spacing: 8) {
            MetricChip(icon: "circle", text: "未完成 \(openCount)", tint: openCount > 0 ? .appWarning : .secondary)
            MetricChip(icon: "checkmark.circle.fill", text: "已完成 \(completedCount)", tint: .appSuccess)
            MetricChip(icon: "list.bullet", text: "全部 \(dateTodos.count)", tint: .appAccent)

            Spacer()
        }
    }

    private var taskList: some View {
        ScrollView {
            if dateTodos.isEmpty {
                EmptyListView(
                    title: appState.isTodaySelected ? "今天没有待办" : "这天没有待办",
                    subtitle: "添加一件真正需要推进的事，让清单保持轻而明确。"
                )
                .padding(.top, 36)
            } else {
                LazyVStack(spacing: 2) {
                    ForEach(Array(dateTodos.enumerated()), id: \.element.id) { index, todo in
                        TodoCardView(index: index + 1, todo: todo)
                            .environmentObject(viewModel)
                            .environmentObject(appState)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
        .scrollContentBackground(.hidden)
    }

    private func addNewTodo() {
        guard viewModel.createTodo(title: newTodoText, date: appState.selectedDate) != nil else { return }
        newTodoText = ""
        focusComposer()
    }

    private func focusComposer() {
        DispatchQueue.main.async {
            newTodoFocused = true
        }
    }

    private func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }
}
