import SwiftUI
import SwiftData
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var selectedTodo: TodoItem? = nil
    @Published var isLoading: Bool = false

    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()

    init() {}

    func setup(with context: ModelContext) {
        self.modelContext = context
        loadTodos()
    }

    func loadTodos() {
        guard let context = modelContext else { return }
        isLoading = true
        let descriptor = FetchDescriptor<TodoItem>(
            sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdAt)]
        )
        do {
            todos = try context.fetch(descriptor)
        } catch {
            print("加载待办失败: \(error)")
        }
        isLoading = false
    }

    /// 获取指定日期的待办（含已完成的）
    func todosForDate(_ date: Date) -> [TodoItem] {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

    /// 创建待办：直接输入标题 + 指定日期
    func createTodo(title: String, date: Date) -> TodoItem? {
        guard let context = modelContext, !title.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }
        let newTodo = TodoItem(
            title: title.trimmingCharacters(in: .whitespaces),
            dueDate: date,
            isCompleted: false,
            sortOrder: todos.count
        )
        context.insert(newTodo)
        try? context.save()
        loadTodos()
        selectedTodo = newTodo
        return newTodo
    }

    func saveTodo(_ todo: TodoItem) {
        guard let context = modelContext else { return }
        todo.updateTimestamp()
        try? context.save()
        loadTodos()
    }

    func deleteTodo(_ todo: TodoItem) {
        guard let context = modelContext else { return }
        context.delete(todo)
        if selectedTodo?.id == todo.id {
            selectedTodo = nil
        }
        try? context.save()
        loadTodos()
    }

    func toggleTodoCompletion(_ todo: TodoItem) {
        todo.isCompleted.toggle()
        saveTodo(todo)
    }

    func addSubtask(to todo: TodoItem, title: String) {
        guard let context = modelContext, !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let subtask = SubtaskItem(
            title: title.trimmingCharacters(in: .whitespaces),
            sortOrder: todo.subtasks.count
        )
        todo.subtasks.append(subtask)
        todo.updateTimestamp()
        try? context.save()
        loadTodos()
    }

    func toggleSubtaskCompletion(_ subtask: SubtaskItem) {
        subtask.isCompleted.toggle()
        subtask.updateTimestamp()
        saveSubtask(subtask)
    }

    func updateSubtaskTitle(_ subtask: SubtaskItem, title: String) {
        guard let context = modelContext else { return }

        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        subtask.title = trimmed
        subtask.updateTimestamp()

        try? context.save()
        loadTodos()
    }

    func deleteSubtask(_ subtask: SubtaskItem) {
        guard let context = modelContext else { return }
        context.delete(subtask)
        try? context.save()
        loadTodos()
    }

    private func saveSubtask(_ subtask: SubtaskItem) {
        guard let context = modelContext else { return }
        try? context.save()
        loadTodos()
    }
}
