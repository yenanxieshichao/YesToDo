import SwiftUI
import SwiftData
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var selectedTodo: TodoItem? = nil
    @Published var searchText: String = ""
    @Published var filterCompleted: Bool = false
    @Published var isLoading: Bool = false

    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: .newTodoCommand)
            .sink { [weak self] _ in
                self?.createNewTodo()
            }
            .store(in: &cancellables)
    }

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
            print("Failed to load todos: \(error)")
        }
        isLoading = false
    }

    func createNewTodo(date: Date? = nil) {
        guard let context = modelContext else { return }
        let newTodo = TodoItem(
            title: "",
            isCompleted: false,
            dueDate: date
        )
        context.insert(newTodo)
        try? context.save()
        loadTodos()
        selectedTodo = newTodo
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
        guard let context = modelContext else { return }
        let subtask = SubtaskItem(
            title: title,
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

    func filteredTodos(for sidebarItem: SidebarItem) -> [TodoItem] {
        var result = todos

        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { todo in
                todo.title.localizedCaseInsensitiveContains(searchText) ||
                todo.plainTextDescription.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Apply sidebar filter
        switch sidebarItem {
        case .today:
            let calendar = Calendar.current
            result = result.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInToday(dueDate) && !todo.isCompleted
            }
        case .upcoming:
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            result = result.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.startOfDay(for: dueDate) >= today && !todo.isCompleted
            }
            result.sort { a, b in
                (a.dueDate ?? .distantFuture) < (b.dueDate ?? .distantFuture)
            }
        case .calendar:
            // Filter is handled separately when a date is selected
            break
        case .completed:
            result = result.filter { $0.isCompleted }
        }

        return result
    }

    func todosForDate(_ date: Date) -> [TodoItem] {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }
}

extension Notification.Name {
    static let newTodoCommand = Notification.Name("newTodoCommand")
}
