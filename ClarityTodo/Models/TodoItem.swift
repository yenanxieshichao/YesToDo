import SwiftData
import Foundation

@Model
final class TodoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var richTextDescription: Data?
    var plainTextDescription: String
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
    var isCompleted: Bool
    var colorTag: String
    @Relationship(deleteRule: .cascade) var subtasks: [SubtaskItem] = []
    var sortOrder: Int
    /// 标记是否已被继承过：nil = 从未继承，非 nil = 已继承（值=继承发生日期）
    var carriedOverDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        richTextDescription: Data? = nil,
        plainTextDescription: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        colorTag: String = "blue",
        subtasks: [SubtaskItem] = [],
        sortOrder: Int = 0,
        carriedOverDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.richTextDescription = richTextDescription
        self.plainTextDescription = plainTextDescription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.colorTag = colorTag
        self.subtasks = subtasks
        self.sortOrder = sortOrder
        self.carriedOverDate = carriedOverDate
    }

    func updateTimestamp() {
        updatedAt = Date()
    }
}

extension TodoItem {
    var dueDateString: String? {
        guard let date = dueDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
