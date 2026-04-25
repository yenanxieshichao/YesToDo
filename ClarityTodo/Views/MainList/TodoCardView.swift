import SwiftUI

struct TodoCardView: View {
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        HStack(spacing: 10) {
            // Completion checkbox
            Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                Circle()
                    .strokeBorder(todo.isCompleted ? Color.green : colorFromTag(todo.colorTag), lineWidth: 1.5)
                    .frame(width: 18, height: 18)
                    .overlay {
                        if todo.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.green)
                        }
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(todo.title.isEmpty ? "New Todo" : todo.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                // Subtask progress
                if !todo.subtasks.isEmpty {
                    HStack(spacing: 4) {
                        let completed = todo.subtasks.filter { $0.isCompleted }.count
                        Text("\(completed)/\(todo.subtasks.count)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }

                // Due date
                if let dueDate = todo.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(formatDueDate(dueDate))
                            .font(.caption2)
                    }
                    .foregroundStyle(isDueDatePast(dueDate) && !todo.isCompleted ? .red : .secondary)
                }
            }

            Spacer()

            // Color tag indicator
            Circle()
                .fill(colorFromTag(todo.colorTag))
                .frame(width: 8, height: 8)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
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

    private func formatDueDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }

    private func isDueDatePast(_ date: Date) -> Bool {
        return date < Calendar.current.startOfDay(for: Date())
    }
}
