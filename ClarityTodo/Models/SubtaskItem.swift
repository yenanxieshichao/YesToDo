import SwiftData
import Foundation

@Model
final class SubtaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    var sortOrder: Int
    var parentTodo: TodoItem?

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sortOrder: Int = 0,
        parentTodo: TodoItem? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sortOrder = sortOrder
        self.parentTodo = parentTodo
    }

    func updateTimestamp() {
        updatedAt = Date()
    }
}
