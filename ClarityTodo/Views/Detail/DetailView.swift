import SwiftUI
import AppKit

struct DetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        VStack(spacing: 0) {
            if let todo = appState.selectedTodo {
                TodoInspectorContent(todo: todo)
            } else {
                EmptyInspector()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.85))
        )
        .overlay(
            Rectangle()
                .fill(Color.cardBorder)
                .frame(width: 1),
            alignment: .leading
        )
    }
}

// MARK: - 空状态
struct EmptyInspector: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.appBrand.primaryBlue.opacity(0.06))
                    .frame(width: 64, height: 64)
                Image(systemName: "sidebar.right")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.appBrand.primaryBlue.opacity(0.5))
            }

            Text("选择一条待办")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            Text("在左侧列表点击待办，\n在右侧查看详情、添加描述和子任务")
                .font(.system(size: 13))
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Spacer()
        }
        .padding(32)
    }
}

// MARK: - 任务详情面板
struct TodoInspectorContent: View {
    @EnvironmentObject var viewModel: TodoViewModel
    let todo: TodoItem

    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var selectedColor: String = "blue"
    @State private var attributedDescription: NSAttributedString = NSAttributedString(string: "")
    @State private var showColorPicker = false
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // ── 顶部：标题 + 状态 + 删除 ──
                VStack(spacing: 8) {
                    HStack {
                        StatusBadge(isCompleted: todo.isCompleted)
                        Spacer()
                        DangerIconButton(icon: "trash") { showDeleteAlert = true }
                    }

                    // 标题
                    TextField("任务标题", text: $title)
                        .textFieldStyle(.plain)
                        .font(.system(size: 22, weight: .semibold))
                        .onSubmit {
                            todo.title = title
                            viewModel.saveTodo(todo)
                        }

                    // 时间信息
                    HStack(spacing: 12) {
                        Label(formatDateFull(todo.createdAt), systemImage: "clock")
                            .font(.system(size: 11))
                            .foregroundStyle(.tertiary)
                        if todo.createdAt != todo.updatedAt {
                            Text("· 更新 \(formatRelative(todo.updatedAt))")
                                .font(.system(size: 11))
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                PremiumDivider()
                    .padding(.horizontal, 20)

                // ── 日期 + 颜色卡片 ──
                HStack(spacing: 12) {
                    // 日期卡片
                    Button(action: {
                        hasDueDate.toggle()
                        todo.dueDate = hasDueDate ? dueDate : nil
                        viewModel.saveTodo(todo)
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: hasDueDate ? "calendar.circle.fill" : "calendar.circle")
                                .font(.system(size: 14))
                            Text(hasDueDate ? formatDateShort(dueDate) : "添加截止日期")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(hasDueDate ? Color.appBrand.primaryBlue : .secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(nsColor: .quaternaryLabelColor).opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)

                    if hasDueDate {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .scaleEffect(0.85)
                            .onChange(of: dueDate) { _, newDate in
                                todo.dueDate = newDate
                                viewModel.saveTodo(todo)
                            }
                    }

                    // 颜色卡片
                    Button(action: { showColorPicker.toggle() }) {
                        HStack(spacing: 6) {
                            Circle()
                                .fill(colorFromTag(selectedColor))
                                .frame(width: 12, height: 12)
                            Text(titleForTag(selectedColor))
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(nsColor: .quaternaryLabelColor).opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showColorPicker) {
                        ColorPickerRow(selectedColor: $selectedColor) { newColor in
                            todo.colorTag = newColor
                            viewModel.saveTodo(todo)
                        }
                        .padding(12)
                    }

                    Spacer()
                }
                .padding(.horizontal, 20)

                // ── 子任务 ──
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "checklist")
                            .font(.system(size: 11))
                        Text("子任务")
                            .font(.system(size: 12, weight: .semibold))
                        if !todo.subtasks.isEmpty {
                            Text("\(todo.subtasks.count)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.tertiary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.quaternary.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        Spacer()
                    }
                    .foregroundStyle(.secondary)

                    ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                        InspectorSubtaskRow(subtask: subtask, parentTodo: todo)
                            .environmentObject(viewModel)
                    }

                    GhostButton(icon: "plus", title: "添加子任务") {
                        viewModel.addSubtask(to: todo, title: "新子任务")
                    }
                }
                .padding(.horizontal, 20)

                // ── 描述 ──
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "doc.text")
                            .font(.system(size: 11))
                        Text("详细描述")
                            .font(.system(size: 12, weight: .semibold))
                        Spacer()
                        Text("⌘B / ⌘I / ⌘U")
                            .font(.system(size: 9))
                            .foregroundStyle(.tertiary)
                    }
                    .foregroundStyle(.secondary)

                    RichTextEditor(attributedString: $attributedDescription)
                        .frame(minHeight: 100, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .scrollContentBackground(.hidden)
        .onAppear { loadData() }
        .onChange(of: todo) { _, _ in loadData() }
        .onChange(of: attributedDescription) { _, newValue in
            DataService.shared.saveRichText(newValue, to: todo)
            viewModel.saveTodo(todo)
        }
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteTodo(todo) }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    private func loadData() {
        title = todo.title
        hasDueDate = todo.dueDate != nil
        dueDate = todo.dueDate ?? Date()
        selectedColor = todo.colorTag
        attributedDescription = DataService.shared.loadRichText(from: todo)
    }

    private func formatDateFull(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月d日 HH:mm"
        return "创建 " + f.string(from: date)
    }

    private func formatRelative(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        if interval < 60 { return "刚刚" }
        if interval < 3600 { return "\(Int(interval / 60))分钟前" }
        if interval < 86400 { return "\(Int(interval / 3600))小时前" }
        return "\(Int(interval / 86400))天前"
    }

    private func formatDateShort(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月d日"
        return f.string(from: date)
    }

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
        case "red": return .red; case "orange": return .orange
        case "yellow": return .yellow; case "green": return .green
        case "blue": return .blue; case "purple": return .purple
        case "pink": return .pink; default: return .blue
        }
    }

    private func titleForTag(_ tag: String) -> String {
        switch tag {
        case "red": return "红色"; case "orange": return "橙色"
        case "yellow": return "黄色"; case "green": return "绿色"
        case "blue": return "蓝色"; case "purple": return "紫色"
        case "pink": return "粉色"; default: return "蓝色"
        }
    }
}

// MARK: - 详情面板子任务行
struct InspectorSubtaskRow: View {
    @EnvironmentObject var viewModel: TodoViewModel
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @State private var editTitle: String = ""

    var body: some View {
        HStack(spacing: 6) {
            Button(action: { viewModel.toggleSubtaskCompletion(subtask) }) {
                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 12))
                    .foregroundStyle(subtask.isCompleted ? Color.appBrand.successGreen : .secondary)
            }
            .buttonStyle(.plain)

            TextField("", text: $editTitle)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)
                .onSubmit {
                    subtask.title = editTitle
                    viewModel.loadTodos()
                }

            DangerIconButton(icon: "xmark") {
                viewModel.deleteSubtask(subtask)
            }
        }
        .onAppear { editTitle = subtask.title }
    }
}

// MARK: - 颜色选择行
struct ColorPickerRow: View {
    @Binding var selectedColor: String
    let onSelect: (String) -> Void

    private let colors: [(name: String, color: String)] = [
        ("红色", "red"), ("橙色", "orange"), ("黄色", "yellow"),
        ("绿色", "green"), ("蓝色", "blue"), ("紫色", "purple"), ("粉色", "pink")
    ]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(colors, id: \.color) { tag in
                Circle()
                    .fill(colorSwatch(tag.color))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(tag.color == selectedColor ? Color.primary : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedColor = tag.color
                        onSelect(tag.color)
                    }
            }
        }
    }

    private func colorSwatch(_ tag: String) -> Color {
        switch tag {
        case "red": return .red; case "orange": return .orange
        case "yellow": return .yellow; case "green": return .green
        case "blue": return .blue; case "purple": return .purple
        case "pink": return .pink; default: return .blue
        }
    }
}
