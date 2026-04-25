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
        .frame(minWidth: 300)
    }
}

struct DetailEmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 36))
                .foregroundStyle(.quaternary)
            Text("Select a todo to edit")
                .font(.body)
                .foregroundStyle(.tertiary)
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
            VStack(alignment: .leading, spacing: 16) {
                // Title
                TextField("Todo title", text: $title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        todo.title = title
                        viewModel.saveTodo(todo)
                    }

                // Metadata row
                HStack(spacing: 12) {
                    // Due date toggle
                    Button(action: {
                        hasDueDate.toggle()
                        if hasDueDate {
                            todo.dueDate = dueDate
                        } else {
                            todo.dueDate = nil
                        }
                        viewModel.saveTodo(todo)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: hasDueDate ? "calendar.circle.fill" : "calendar.circle")
                            Text(hasDueDate ? "Due \(formatDate(dueDate))" : "Add due date")
                                .font(.caption)
                        }
                        .foregroundStyle(hasDueDate ? .blue : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)

                    if hasDueDate {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .onChange(of: dueDate) { _, newDate in
                                todo.dueDate = newDate
                                viewModel.saveTodo(todo)
                            }
                    }

                    Spacer()

                    // Color picker
                    Button(action: { showColorPicker.toggle() }) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(colorFromTag(selectedColor))
                                .frame(width: 10, height: 10)
                            Text("Color")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showColorPicker) {
                        ColorPickerView(selectedColor: $selectedColor) { newColor in
                            todo.colorTag = newColor
                            viewModel.saveTodo(todo)
                        }
                        .padding(8)
                    }
                }

                Divider()

                // Subtasks
                VStack(alignment: .leading, spacing: 4) {
                    Text("Subtasks")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                        SubtaskRow(subtask: subtask)
                    }

                    Button(action: { addSubtask() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle")
                                .font(.caption)
                            Text("Add subtask")
                                .font(.caption)
                        }
                        .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }

                // Rich text description
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    RichTextEditor(attributedString: $attributedDescription)
                        .frame(minHeight: 120, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                        )
                }

                // Delete button
                Button(action: { showDeleteAlert = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                        Text("Delete Todo")
                    }
                    .font(.body)
                    .foregroundStyle(.red)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .onAppear {
            loadTodoData()
        }
        .onChange(of: todo) { _, _ in
            loadTodoData()
        }
        .onChange(of: attributedDescription) { _, newValue in
            saveRichText(newValue)
        }
        .alert("Delete Todo", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteTodo(todo)
            }
        } message: {
            Text("Are you sure you want to delete \"\(todo.title)\"?")
        }
    }

    private func loadTodoData() {
        title = todo.title
        hasDueDate = todo.dueDate != nil
        dueDate = todo.dueDate ?? Date()
        selectedColor = todo.colorTag
        attributedDescription = DataService.shared.loadRichText(from: todo)
    }

    private func saveRichText(_ attrString: NSAttributedString) {
        DataService.shared.saveRichText(attrString, to: todo)
        viewModel.saveTodo(todo)
    }

    private func addSubtask() {
        viewModel.addSubtask(to: todo, title: "New subtask")
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
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
}

struct SubtaskRow: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var title: String = ""
    let subtask: SubtaskItem

    var body: some View {
        HStack(spacing: 8) {
            // Completion checkbox
            Button(action: {
                viewModel.toggleSubtaskCompletion(subtask)
            }) {
                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)

            // Title
            TextField("Subtask", text: $title)
                .textFieldStyle(.plain)
                .font(.callout)
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)
                .onSubmit {
                    subtask.title = title
                    subtask.updateTimestamp()
                    viewModel.loadTodos()
                }

            Spacer()

            // Delete
            Button(action: { viewModel.deleteSubtask(subtask) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 4)
        .onAppear {
            title = subtask.title
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(colorTags, id: \.name) { tag in
                Circle()
                    .fill(colorFromTag(tag.color))
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

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
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
}
