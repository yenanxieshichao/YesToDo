import SwiftUI
import AppKit

struct TodoCardView: View {
    let index: Int
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    @State private var isExpanded: Bool = false
    @State private var editTitle: String = ""
    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @State private var showDeleteAlert = false
    @State private var selectedColor: String = "blue"
    @State private var attributedDescription: NSAttributedString = NSAttributedString(string: "")
    @State private var showColorPicker = false

    private let iconSize: CGFloat = 14

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            mainRow
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isExpanded.toggle()
                    }
                }

            // ── 展开详情 ──
            if isExpanded {
                expandedDetail
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, isExpanded ? 14 : 10)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.06), radius: isExpanded ? 8 : 3, x: 0, y: isExpanded ? 4 : 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
        .onAppear { loadData() }
        .onChange(of: todo) { _, _ in loadData() }
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteTodo(todo) }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    // MARK: - 主行
    private var mainRow: some View {
        HStack(spacing: 10) {
            // 完成圆 checkbox
            Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                Circle()
                    .strokeBorder(todo.isCompleted ? Color.green : colorSwatch, lineWidth: 1.8)
                    .frame(width: 20, height: 20)
                    .overlay {
                        if todo.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.green)
                        }
                    }
            }
            .buttonStyle(.plain)

            // 标题
            Text(todo.title.isEmpty ? "新待办" : todo.title)
                .font(.system(size: 15, weight: .medium))
                .lineLimit(2)
                .strikethrough(todo.isCompleted)
                .foregroundStyle(todo.isCompleted ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // 颜色标签
            Circle()
                .fill(colorSwatch)
                .frame(width: 8, height: 8)

            // 操作图标群
            HStack(spacing: 14) {
                Button(action: { showSubtaskInput.toggle() }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: iconSize))
                }
                .buttonStyle(.plain)
                .help("添加子待办")

                Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                    Image(systemName: "textformat.strikethrough")
                        .font(.system(size: iconSize))
                        .foregroundStyle(todo.isCompleted ? .green : .secondary)
                }
                .buttonStyle(.plain)
                .help(todo.isCompleted ? "取消完成" : "标记完成")

                Button(action: { showDeleteAlert = true }) {
                    Image(systemName: "trash")
                        .font(.system(size: iconSize - 1))
                }
                .buttonStyle(.plain)
                .help("删除")
            }
            .foregroundStyle(.secondary.opacity(0.6))

            // 展开箭头
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.quaternary)
                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                .animation(.easeOut(duration: 0.2), value: isExpanded)
        }
    }

    // MARK: - 展开详情
    private var expandedDetail: some View {
        VStack(alignment: .leading, spacing: 12) {
            Divider()

            // 标题编辑
            HStack {
                TextField("待办标题", text: $editTitle)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .onSubmit {
                        todo.title = editTitle
                        viewModel.saveTodo(todo)
                    }
            }

            // 日期 + 颜色
            HStack(spacing: 10) {
                // 日期开关
                Button(action: {
                    if todo.dueDate != nil {
                        todo.dueDate = nil
                    } else {
                        todo.dueDate = Date()
                    }
                    viewModel.saveTodo(todo)
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: todo.dueDate != nil ? "calendar.circle.fill" : "calendar.circle")
                        Text(todo.dueDate != nil ? formatDate(todo.dueDate!) : "添加日期")
                            .font(.caption)
                    }
                    .foregroundStyle(todo.dueDate != nil ? .blue : .secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(.quaternary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)

                if todo.dueDate != nil, let date = todo.dueDate {
                    DatePicker("", selection: Binding(
                        get: { date },
                        set: { todo.dueDate = $0; viewModel.saveTodo(todo) }
                    ), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .scaleEffect(0.85)
                }

                // 颜色
                Button(action: { showColorPicker.toggle() }) {
                    Circle()
                        .fill(colorSwatch)
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showColorPicker) {
                    ColorPickerRow(selectedColor: $selectedColor) { newColor in
                        todo.colorTag = newColor
                        viewModel.saveTodo(todo)
                    }
                    .padding(10)
                }

                Spacer()

                // 折叠按钮
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        isExpanded = false
                    }
                }) {
                    Text("收起")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }

            // 子任务
            VStack(alignment: .leading, spacing: 4) {
                if !todo.subtasks.isEmpty {
                    ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                        ExpandedSubtaskRow(subtask: subtask, parentTodo: todo)
                            .environmentObject(viewModel)
                    }
                }

                if showSubtaskInput {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.blue)
                        TextField("输入子待办…", text: $subtaskText)
                            .textFieldStyle(.plain)
                            .font(.callout)
                            .onSubmit { addSubtask() }
                        Button(action: addSubtask) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.leading, 4)
                } else {
                    Button(action: { showSubtaskInput = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.caption2)
                            Text("添加子任务")
                                .font(.caption)
                        }
                        .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
            }

            // 富文本描述
            RichTextEditor(attributedString: $attributedDescription)
                .frame(minHeight: 80, maxHeight: 180)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 0.5)
                )
                .onChange(of: attributedDescription) { _, newValue in
                    DataService.shared.saveRichText(newValue, to: todo)
                    viewModel.saveTodo(todo)
                }
        }
    }

    // MARK: - Helpers
    private func loadData() {
        editTitle = todo.title
        selectedColor = todo.colorTag
        attributedDescription = DataService.shared.loadRichText(from: todo)
    }

    private func addSubtask() {
        viewModel.addSubtask(to: todo, title: subtaskText)
        subtaskText = ""
    }

    private var colorSwatch: Color {
        switch selectedColor {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        default: return .blue
        }
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月d日"
        return f.string(from: date)
    }
}

// MARK: - 展开详情中的子任务行
struct ExpandedSubtaskRow: View {
    @EnvironmentObject var viewModel: TodoViewModel
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @State private var editTitle: String = ""

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                .onTapGesture { viewModel.toggleSubtaskCompletion(subtask) }

            TextField("", text: $editTitle)
                .textFieldStyle(.plain)
                .font(.callout)
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)
                .onSubmit {
                    subtask.title = editTitle
                    viewModel.loadTodos()
                }

            Button(action: { viewModel.deleteSubtask(subtask) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .onAppear { editTitle = subtask.title }
    }
}

// MARK: - 颜色选择行
struct ColorPickerRow: View {
    @Binding var selectedColor: String
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(colorTags, id: \.name) { tag in
                Circle()
                    .fill(colorSwatch(tag.color))
                    .frame(width: 22, height: 22)
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
