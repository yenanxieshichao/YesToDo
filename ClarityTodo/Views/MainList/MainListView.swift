import SwiftUI

struct MainListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var newTodoText: String = ""
    @State private var showCalendarPopover = false
    @State private var showCarryOverAlert = false
    @State private var carryOverCount = 0
    @FocusState private var newTodoFocused: Bool

    private var dateTodos: [TodoItem] {
        viewModel.todosForDate(appState.selectedDate)
    }

    private var completedCount: Int { dateTodos.filter(\.isCompleted).count }
    private var progressPercent: Int {
        dateTodos.isEmpty ? 0 : Int((Double(completedCount) / Double(dateTodos.count)) * 100)
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Hero Header ──
            heroHeader
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 6)

            // ── 统计条 ──
            if !dateTodos.isEmpty {
                statsRow
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
            }

            // ── 待办列表容器 ──
            ScrollView {
                VStack(spacing: 0) {
                    if dateTodos.isEmpty {
                        PremiumEmptyState(
                            icon: "sun.max",
                            title: "今天很清爽",
                            subtitle: "写下今天最重要的几件事，保持节奏就好。",
                            hint: "按 ⌘N 快速添加"
                        )
                        .frame(minHeight: 300)
                    } else {
                        LazyVStack(spacing: 4) {
                            ForEach(Array(dateTodos.enumerated()), id: \.element.id) { index, todo in
                                TodoCardView(index: index + 1, todo: todo)
                                    .environmentObject(viewModel)
                                    .environmentObject(appState)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 80) // 给浮层栏留空间
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollContentBackground(.hidden)
        }
        .onReceive(NotificationCenter.default.publisher(for: .focusNewTodoCommand)) { _ in
            DispatchQueue.main.async {
                newTodoFocused = true
            }
        }
        .onChange(of: appState.selectedDate) { _, _ in
            // 切换日期时取消选中
            appState.selectedTodo = nil
        }
        .overlay(alignment: .bottom) {
            // ── Floating Composer ──
            floatingComposer
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
        .alert("继承完成", isPresented: $showCarryOverAlert) {
            Button("好的") {}
        } message: {
            if carryOverCount > 0 {
                Text("已将 \(carryOverCount) 条未完成待办（含未完成子待办）复制到今天。")
            } else {
                Text("没有需要继承的待办。")
            }
        }
    }

    // MARK: - Hero Header
    private var heroHeader: some View {
        HStack(spacing: 12) {
            // 品牌徽标
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.appBrand.primaryBlue)
                    .frame(width: 24, height: 24)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                Text("Yes To Do")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            // 全局缩放控件
            HStack(spacing: 6) {
                Button(action: {
                    appState.globalFontSize = max(12, appState.globalFontSize - 1)
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 22, height: 22)
                        .background(.quaternary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)

                Text("\(Int(appState.globalFontSize))")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(width: 24)

                Button(action: {
                    appState.globalFontSize = min(32, appState.globalFontSize + 1)
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.secondary)
                        .frame(width: 22, height: 22)
                        .background(.quaternary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }

            // 日期间信息
            VStack(alignment: .trailing, spacing: 0) {
                Text(appState.headerTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                if !appState.headerSubtitle.isEmpty {
                    Text(appState.headerSubtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                }
            }

            // 日历按钮
            Button(action: { showCalendarPopover.toggle() }) {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .background(.quaternary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showCalendarPopover, arrowEdge: .top) {
                CompactCalendarView(selectedDate: $appState.selectedDate, isPresented: $showCalendarPopover)
                    .environmentObject(viewModel)
            }

            // 继承未完成待办（仅今天显示）
            if appState.isTodaySelected && viewModel.hasUnfinishedBeforeToday() {
                Button(action: {
                    carryOverCount = viewModel.carryOverUnfinishedTodos(to: appState.selectedDate)
                    showCarryOverAlert = true
                }) {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.triangle.merge")
                            .font(.system(size: 9))
                        Text("继承")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Color.primary.opacity(0.04))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }

            // 回到今天（非今天时显示）
            if !appState.isTodaySelected {
                Button(action: { appState.selectedDate = Date() }) {
                    Text("回到今天")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.appBrand.primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - 统计条
    private var statsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                InfoChip(icon: "checklist", text: "今日待办 \(dateTodos.count)", color: .appBrand.primaryBlue)
                InfoChip(icon: "checkmark.circle.fill", text: "已完成 \(completedCount)", color: .appBrand.successGreen)
                InfoChip(icon: "percent", text: "完成率 \(progressPercent)%", color: .appBrand.warningAmber)
                InfoChip(icon: "calendar", text: formatDateShort(appState.selectedDate), color: .inkTertiary)
            }
        }
    }

    // MARK: - Floating Composer
    private var floatingComposer: some View {
        HStack(spacing: 10) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.appBrand.primaryBlue)

            TextField("写下今天要做的事…", text: $newTodoText)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .focused($newTodoFocused)
                .onSubmit { addNewTodo() }

            PrimaryActionButton(
                title: "添加",
                disabled: newTodoText.trimmingCharacters(in: .whitespaces).isEmpty,
                action: addNewTodo
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
                .floatingShadow()
        )
        .overlay(
            RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                .stroke(Color.cardBorder, lineWidth: 0.5)
        )
    }

    private func addNewTodo() {
        guard let _ = viewModel.createTodo(title: newTodoText, date: appState.selectedDate) else { return }
        newTodoText = ""
        newTodoFocused = false  // 显式失焦，让待办卡片可被选择/编辑
    }

    private func formatDateShort(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月d日"
        return f.string(from: date)
    }
}
