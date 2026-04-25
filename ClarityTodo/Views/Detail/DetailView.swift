import SwiftUI
import AppKit

struct DetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        Group {
            if let todo = appState.selectedTodo {
                TodoDetailContent(todo: todo)
            } else {
                DetailEmptyState()
            }
        }
        .frame(minWidth: 280)
    }
}

struct DetailEmptyState: View {
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            Text("选择一条待办查看详情")
                .font(.body)
                .foregroundStyle(.tertiary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

struct TodoDetailContent: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var selectedColor: String = "blue"
    @State private var attributedDescription: NSAttributedString = NSAttributedString(string: "")
    @State private var showDeleteAlert = false
    @State private var showColorPicker = false

    let todo: TodoItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // 标题
                TextField("待办标题", text: $title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        todo.title = title
                        viewModel.saveTodo(todo)
                    }

                // 元数据行
                HStack(spacing: 10) {
                    // 日期
                    Button(action: {
                        hasDueDate.toggle()
                        todo.dueDate = hasDueDate ? dueDate : nil
                        viewModel.saveTodo(todo)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: hasDueDate ? "calendar.circle.fill" : "calendar.circle")
                            Text(hasDueDate ? formatDate(dueDate) : "添加日期")
                                .font(.caption)
                        }
                        .foregroundStyle(hasDueDate ? .blue : .secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
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

                    // 颜色
                    Button(action: { showColorPicker.toggle() }) {
                        Circle()
                            .fill(colorFromTag(selectedColor))
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showColorPicker) {
                        ColorPickerView(selectedColor: $selectedColor) { newColor in
                            todo.colorTag = newColor
                            viewModel.saveTodo(todo)
                        }
                        .padding(8)
                    }

                    Spacer()

                    // 删除
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundStyle(.red.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                    .help("删除待办")
                }

                Divider()

                // 子任务
                VStack(alignment: .leading, spacing: 4) {
                    Text("子任务")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                        SubtaskRow(subtask: subtask, parentTodo: todo)
                    }

                    Button(action: { viewModel.addSubtask(to: todo, title: "新子任务") }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.caption)
                            Text("添加")
                                .font(.caption)
                        }
                        .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }

                Divider()

                // 富文本描述
                VStack(alignment: .leading, spacing: 4) {
                    Text("描述")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    RichTextEditor(attributedString: $attributedDescription)
                        .frame(minHeight: 100, maxHeight: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                        )
                }
            }
            .padding(16)
        }
        .background(Color(nsColor: .controlBackgroundColor))
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

    private func formatDate(_ date: Date) -> String {
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
}

struct SubtaskRow: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var title: String = ""
    let subtask: SubtaskItem
    let parentTodo: TodoItem

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                .font(.system(size: 12))
                .onTapGesture { viewModel.toggleSubtaskCompletion(subtask) }

            TextField("子任务", text: $title)
                .textFieldStyle(.plain)
                .font(.callout)
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)
                .onSubmit {
                    subtask.title = title
                    viewModel.loadTodos()
                }

            Button(action: { viewModel.deleteSubtask(subtask) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.4))
            }
            .buttonStyle(.plain)
        }
        .onAppear { title = subtask.title }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 6) {
            ForEach(colorTags, id: \.name) { tag in
                Circle()
                    .fill(colorFromTag(tag.color))
                    .frame(width: 20, height: 20)
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

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
        case "red": return .red; case "orange": return .orange
        case "yellow": return .yellow; case "green": return .green
        case "blue": return .blue; case "purple": return .purple
        case "pink": return .pink; default: return .blue
        }
    }
}
