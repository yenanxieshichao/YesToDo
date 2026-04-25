import SwiftData
import Foundation

/// Central data access service for todo operations
class DataService {
    static let shared = DataService()

    private init() {}

    /// Save RTF attributed string data to the todo item
    func saveRichText(_ attributedString: NSAttributedString, to todo: TodoItem) {
        let range = NSRange(location: 0, length: attributedString.length)
        if let data = try? attributedString.rtf(from: range) {
            todo.richTextDescription = data
            todo.plainTextDescription = attributedString.string
            todo.updateTimestamp()
        }
    }

    /// Load RTF attributed string from the todo item
    func loadRichText(from todo: TodoItem) -> NSAttributedString {
        guard let data = todo.richTextDescription else {
            return NSAttributedString(string: "")
        }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
        } catch {
            print("Failed to load RTF: \(error)")
            return NSAttributedString(string: todo.plainTextDescription)
        }
    }

    /// Check if a todo item exists for a given date
    func hasTodos(for date: Date, in todos: [TodoItem]) -> Bool {
        let calendar = Calendar.current
        return todos.contains { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

    /// Count todos for a given date
    func todoCount(for date: Date, in todos: [TodoItem]) -> Int {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }.count
    }
}
