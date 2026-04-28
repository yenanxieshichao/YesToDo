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

    /// 继承：找到最近一个有未完成待办的日子，把那天的待办复制到今天
    /// - 只处理最近一个过去日子（不是所有）
    /// - 复制：原待办留在原日期不动（历史真实），新待办出现在今天
    /// - 标记原待办 carriedOverDate，下次不会被重复继承
    /// - 已完成的子待办不带过来
    /// - 返回复制了多少条
    func carryOverUnfinishedTodos(to targetDate: Date = Date()) -> Int {
        guard let context = modelContext else { return 0 }
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: targetDate)

        // 收集有未完成且未继承过的待办的过去日子
        var datesWithUnfinished: [Date] = []
        var dateSet = Set<Date>()
        for todo in todos {
            guard let dueDate = todo.dueDate else { continue }
            let day = calendar.startOfDay(for: dueDate)
            guard day < today else { continue }
            // 已完成 → 跳过
            guard !todo.isCompleted else { continue }
            // 已继承过 → 跳过
            guard todo.carriedOverDate == nil else { continue }
            // 子待办全完成 → 跳过
            if !todo.subtasks.isEmpty && todo.subtasks.allSatisfy({ $0.isCompleted }) {
                continue
            }
            if !dateSet.contains(day) {
                datesWithUnfinished.append(day)
                dateSet.insert(day)
            }
        }
        datesWithUnfinished.sort(by: >)

        guard let sourceDay = datesWithUnfinished.first else {
            return 0
        }

        // 找到 sourceDay 所有符合条件的待办
        let sourceTodos = todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: sourceDay)
                && !todo.isCompleted
                && todo.carriedOverDate == nil
        }

        var copiedCount = 0
        let baseSortOrder = todos.count

        for (index, todo) in sourceTodos.enumerated() {
            if !todo.subtasks.isEmpty && todo.subtasks.allSatisfy({ $0.isCompleted }) {
                continue
            }

            // 创建副本在今天
            let newTodo = TodoItem(
                title: todo.title,
                richTextDescription: todo.richTextDescription,
                plainTextDescription: todo.plainTextDescription,
                dueDate: targetDate,
                isCompleted: false,
                colorTag: todo.colorTag,
                sortOrder: baseSortOrder + index
            )
            context.insert(newTodo)

            // 只复制未完成的子待办
            let incompleteSubtasks = todo.subtasks.filter { !$0.isCompleted }
            for (subIdx, subtask) in incompleteSubtasks.enumerated() {
                let newSubtask = SubtaskItem(
                    title: subtask.title,
                    isCompleted: false,
                    sortOrder: subIdx,
                    parentTodo: newTodo
                )
                context.insert(newSubtask)
                newTodo.subtasks.append(newSubtask)
            }

            // 标记原待办已继承
            todo.carriedOverDate = targetDate
            todo.updateTimestamp()

            copiedCount += 1
        }

        if copiedCount > 0 {
            try? context.save()
            loadTodos()
        }

        return copiedCount
    }

    /// 检查今天之前是否有未完成的待办（排除已继承和子待办全完成的）
    func hasUnfinishedBeforeToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return todos.contains { todo in
            guard let dueDate = todo.dueDate else { return false }
            guard !calendar.isDate(dueDate, inSameDayAs: today) && dueDate < today && !todo.isCompleted else {
                return false
            }
            guard todo.carriedOverDate == nil else { return false }
            if !todo.subtasks.isEmpty && todo.subtasks.allSatisfy({ $0.isCompleted }) {
                return false
            }
            return true
        }
    }

    private func saveSubtask(_ subtask: SubtaskItem) {
        guard let context = modelContext else { return }
        try? context.save()
        loadTodos()
    }
}
