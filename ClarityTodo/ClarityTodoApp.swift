import SwiftUI
import SwiftData

@main
struct ClarityTodoApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .modelContainer(for: [TodoItem.self, SubtaskItem.self])
                .frame(minWidth: 960, minHeight: 640)
                .preferredColorScheme(appState.colorScheme)
        }
        .windowStyle(.titleBar)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New Todo") {
                    appState.createNewTodo()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandGroup(replacing: .undoRedo) {
                Button("Undo") {
                    appState.undo()
                }
                .keyboardShortcut("z", modifiers: .command)
                Button("Redo") {
                    appState.redo()
                }
                .keyboardShortcut("z", modifiers: [.command, .shift])
            }
            CommandGroup(replacing: .textFormatting) {
                Button("Bold") {
                    NotificationCenter.default.post(name: .boldCommand, object: nil)
                }
                .keyboardShortcut("b", modifiers: .command)
                Button("Italic") {
                    NotificationCenter.default.post(name: .italicCommand, object: nil)
                }
                .keyboardShortcut("i", modifiers: .command)
                Button("Underline") {
                    NotificationCenter.default.post(name: .underlineCommand, object: nil)
                }
                .keyboardShortcut("u", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let boldCommand = Notification.Name("boldCommand")
    static let italicCommand = Notification.Name("italicCommand")
    static let underlineCommand = Notification.Name("underlineCommand")
    static let deleteTodoCommand = Notification.Name("deleteTodoCommand")
}

class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    @Published var selectedSidebarItem: SidebarItem = .today
    @Published var selectedTodo: TodoItem? = nil
    @Published var filterDate: Date? = nil
    @Published var searchText: String = ""
    @Published var isCalendarOpen: Bool = false

    func createNewTodo() {
        let context = ModelContext(
            try! ModelContainer(for: TodoItem.self, SubtaskItem.self)
        )
        let newTodo = TodoItem(
            title: "",
            isCompleted: false,
            dueDate: filterDate
        )
        context.insert(newTodo)
        selectedTodo = newTodo
    }

    func undo() {
        NotificationCenter.default.post(name: .undoCommand, object: nil)
    }

    func redo() {
        NotificationCenter.default.post(name: .redoCommand, object: nil)
    }
}

extension Notification.Name {
    static let undoCommand = Notification.Name("undoCommand")
    static let redoCommand = Notification.Name("redoCommand")
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case today = "Today"
    case upcoming = "Upcoming"
    case calendar = "Calendar"
    case completed = "Completed"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .today: return "sun.max.fill"
        case .upcoming: return "calendar.badge.clock"
        case .calendar: return "calendar"
        case .completed: return "checkmark.circle.fill"
        }
    }
}
