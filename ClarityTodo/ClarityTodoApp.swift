import SwiftUI
import SwiftData

@main
struct YesToDoApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .modelContainer(sharedModelContainer)
                .frame(minWidth: 980, minHeight: 680)
                .preferredColorScheme(appState.colorScheme)
        }
        .windowStyle(.titleBar)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("新建待办") {
                    NotificationCenter.default.post(name: .focusNewTodoCommand, object: nil)
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandGroup(replacing: .undoRedo) {
                Button("撤销") {
                    NSApp.sendAction(#selector(UndoManager.undo), to: nil, from: nil)
                }
                .keyboardShortcut("z", modifiers: .command)
                Button("重做") {
                    NSApp.sendAction(#selector(UndoManager.redo), to: nil, from: nil)
                }
                .keyboardShortcut("z", modifiers: [.command, .shift])
            }
            CommandGroup(replacing: .textFormatting) {
                Button("粗体") {
                    NotificationCenter.default.post(name: .boldCommand, object: nil)
                }
                .keyboardShortcut("b", modifiers: .command)
                Button("斜体") {
                    NotificationCenter.default.post(name: .italicCommand, object: nil)
                }
                .keyboardShortcut("i", modifiers: .command)
                Button("下划线") {
                    NotificationCenter.default.post(name: .underlineCommand, object: nil)
                }
                .keyboardShortcut("u", modifiers: .command)
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    @Published var selectedDate: Date = Date()
    @Published var selectedTodo: TodoItem? = nil
    @Published var isCalendarPopover: Bool = false
    @Published var globalFontSize: CGFloat = 16

    var isTodaySelected: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }

    var headerTitle: String {
        if isTodaySelected { return "今天" }
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月d日"
        return f.string(from: selectedDate)
    }

    var headerSubtitle: String {
        if isTodaySelected {
            let f = DateFormatter()
            f.locale = Locale(identifier: "zh_CN")
            f.dateFormat = "yyyy年M月d日 EEEE"
            return f.string(from: Date())
        }
        return ""
    }
}

/// 共享 ModelContainer，支持自动迁移
let sharedModelContainer: ModelContainer = {
    let schema = Schema([TodoItem.self, SubtaskItem.self])
    let config = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false,
        allowsSave: true
    )
    do {
        return try ModelContainer(for: schema, configurations: config)
    } catch {
        // 如果 schema 不兼容，删掉旧的重新创建
        try? FileManager.default.removeItem(at: config.url)
        return try! ModelContainer(for: schema, configurations: config)
    }
}()

extension Notification.Name {
    static let boldCommand = Notification.Name("boldCommand")
    static let italicCommand = Notification.Name("italicCommand")
    static let underlineCommand = Notification.Name("underlineCommand")
    static let deleteTodoCommand = Notification.Name("deleteTodoCommand")
    static let focusNewTodoCommand = Notification.Name("focusNewTodoCommand")
}
