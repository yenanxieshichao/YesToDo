# ClarityTodo — 完整项目文档

> macOS 14+ SwiftUI + SwiftData 待办应用。SPM 构建，`swift build` 编译，分发包 `dist/Clarity Todo.app`。

---

## 文件树

```
ClarityTodo/
├── Package.swift
├── ClarityTodo/
│   ├── ClarityTodoApp.swift
│   ├── Models/
│   │   ├── TodoItem.swift
│   │   └── SubtaskItem.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   └── MainList/
│   │       ├── MainListView.swift
│   │       ├── TodoCardView.swift
│   │       └── CalendarView.swift
│   ├── ViewModels/
│   │   └── TodoViewModel.swift
│   ├── Services/
│   │   ├── DataService.swift
│   │   └── RichTextService.swift
│   ├── Components/
│   │   └── PremiumControls.swift
│   └── Utilities/
│       └── DesignSystem.swift
```

---

## Package.swift

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClarityTodo",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "ClarityTodo",
            path: "ClarityTodo"
        )
    ]
)
```

---

## ClarityTodoApp.swift (入口 + AppState + ModelContainer)

```swift
import SwiftUI
import SwiftData

@main
struct ClarityTodoApp: App {
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
```

---

## Models/TodoItem.swift

```swift
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
    var titleFontSize: Double
    @Relationship(deleteRule: .cascade) var subtasks: [SubtaskItem] = []
    var sortOrder: Int

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
        titleFontSize: Double = 17.0,
        subtasks: [SubtaskItem] = [],
        sortOrder: Int = 0
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
        self.titleFontSize = titleFontSize
        self.subtasks = subtasks
        self.sortOrder = sortOrder
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

let colorTags: [(name: String, color: String)] = [
    ("Red", "red"), ("Orange", "orange"), ("Yellow", "yellow"),
    ("Green", "green"), ("Blue", "blue"), ("Purple", "purple"),
    ("Pink", "pink"), ("Gray", "gray")
]

extension String {
    var displayColor: String {
        switch self {
        case "red": return "#FF3B30"
        case "orange": return "#FF9500"
        case "yellow": return "#FFCC00"
        case "green": return "#34C759"
        case "blue": return "#007AFF"
        case "purple": return "#AF52DE"
        case "pink": return "#FF2D55"
        case "gray": return "#8E8E93"
        default: return "#007AFF"
        }
    }
}
```

---

## Models/SubtaskItem.swift

```swift
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
```

---

## ViewModels/TodoViewModel.swift

```swift
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

    func todosForDate(_ date: Date) -> [TodoItem] {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

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
```

---

## Views/ContentView.swift

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = TodoViewModel()
    @Query(sort: \TodoItem.sortOrder) private var todos: [TodoItem]

    var body: some View {
        MainListView()
            .environmentObject(appState)
            .environmentObject(viewModel)
            .premiumBackground()
            .onAppear {
                viewModel.setup(with: modelContext)
            }
            .onChange(of: todos) { _, newTodos in
                viewModel.todos = newTodos
            }
            .onReceive(NotificationCenter.default.publisher(for: .deleteTodoCommand)) { _ in
                if let todo = appState.selectedTodo {
                    viewModel.deleteTodo(todo)
                }
            }
    }
}
```

---

## Views/MainList/MainListView.swift

```swift
import SwiftUI

struct MainListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var newTodoText: String = ""
    @State private var showCalendarPopover = false
    @FocusState private var newTodoFocused: Bool

    private var dateTodos: [TodoItem] {
        viewModel.todosForDate(appState.selectedDate)
    }

    private var completedCount: Int { dateTodos.filter(\.isCompleted).count }
    private var progressPercent: Int {
        dateTodos.isEmpty ? 0 : Int((Double(completedCount) / Double(dateTodos.count)) * 100)
    }

    var body: some View {
        VStack(spacing: 0) {
            heroHeader
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 6)

            if !dateTodos.isEmpty {
                statsRow
                    .padding(.horizontal, 24)
                    .padding(.bottom, 12)
            }

            ScrollView {
                VStack(spacing: 0) {
                    if dateTodos.isEmpty {
                        PremiumEmptyState(
                            icon: "sun.max",
                            title: "今天很清爽",
                            subtitle: "写下今天最重要的几件事，保持节奏就好。",
                            hint: "按 ⌘N 快速添加"
                        )
                        .frame(minHeight: 300)
                    } else {
                        LazyVStack(spacing: 4) {
                            ForEach(Array(dateTodos.enumerated()), id: \.element.id) { index, todo in
                                TodoCardView(index: index + 1, todo: todo)
                                    .environmentObject(viewModel)
                                    .environmentObject(appState)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 80)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollContentBackground(.hidden)
        }
        .onReceive(NotificationCenter.default.publisher(for: .focusNewTodoCommand)) { _ in
            DispatchQueue.main.async {
                newTodoFocused = true
            }
        }
        .onChange(of: appState.selectedDate) { _, _ in
            appState.selectedTodo = nil
        }
        .overlay(alignment: .bottom) {
            floatingComposer
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
        }
    }

    private var heroHeader: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(Color.appBrand.primaryBlue)
                    .frame(width: 24, height: 24)
                    .overlay {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                    }
                Text("Clarity")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {
                Text(appState.headerTitle)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.primary)
                if !appState.headerSubtitle.isEmpty {
                    Text(appState.headerSubtitle)
                        .font(.system(size: 11))
                        .foregroundStyle(.tertiary)
                }
            }

            Button(action: { showCalendarPopover.toggle() }) {
                Image(systemName: "calendar")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 32)
                    .background(.quaternary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showCalendarPopover, arrowEdge: .top) {
                CompactCalendarView(selectedDate: $appState.selectedDate, isPresented: $showCalendarPopover)
                    .environmentObject(viewModel)
            }

            if !appState.isTodaySelected {
                Button(action: { appState.selectedDate = Date() }) {
                    Text("回到今天")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.appBrand.primaryBlue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var statsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                InfoChip(icon: "checklist", text: "今日待办 \(dateTodos.count)", color: .appBrand.primaryBlue)
                InfoChip(icon: "checkmark.circle.fill", text: "已完成 \(completedCount)", color: .appBrand.successGreen)
                InfoChip(icon: "percent", text: "完成率 \(progressPercent)%", color: .appBrand.warningAmber)
                InfoChip(icon: "calendar", text: formatDateShort(appState.selectedDate), color: .inkTertiary)
            }
        }
    }

    private var floatingComposer: some View {
        HStack(spacing: 10) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.appBrand.primaryBlue)

            TextField("写下今天要做的事…", text: $newTodoText)
                .textFieldStyle(.plain)
                .font(.system(size: 15))
                .focused($newTodoFocused)
                .onSubmit { addNewTodo() }

            PrimaryActionButton(
                title: "添加",
                disabled: newTodoText.trimmingCharacters(in: .whitespaces).isEmpty,
                action: addNewTodo
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                .fill(.ultraThinMaterial)
                .floatingShadow()
        )
        .overlay(
            RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                .stroke(Color.cardBorder, lineWidth: 0.5)
        )
    }

    private func addNewTodo() {
        guard let _ = viewModel.createTodo(title: newTodoText, date: appState.selectedDate) else { return }
        newTodoText = ""
        newTodoFocused = false
    }

    private func formatDateShort(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月d日"
        return f.string(from: date)
    }
}
```

---

## Views/MainList/TodoCardView.swift (核心：待办卡片 + 子待办行 + 字体面板)

```swift
import SwiftUI

/// 数字转两位字符串（1→"01", 12→"12"）
private func paddedNumber(_ n: Int) -> String {
    n < 10 ? "0\(n)" : "\(n)"
}

// MARK: - 高级待办行
struct TodoCardView: View {
    let index: Int
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    @State private var isHovering = false
    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @FocusState private var subtaskFocused: Bool
    @State private var isEditingTitle = false
    @State private var editTitle: String = ""
    @FocusState private var titleFocused: Bool
    @State private var showDeleteAlert = false
    @State private var showFontPanel = false

    private let rowHeight: CGFloat = 56

    private var isSelected: Bool {
        appState.selectedTodo?.id == todo.id
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── 主行 ──
            HStack(spacing: 10) {
                // 序号（两位数字）
                Text(paddedNumber(index))
                    .font(.system(size: 13, weight: .regular, design: .monospaced))
                    .foregroundStyle(.tertiary)
                    .frame(width: 24, alignment: .trailing)

                // 完成 checkbox
                PremiumCheckbox(isCompleted: todo.isCompleted) {
                    viewModel.toggleTodoCompletion(todo)
                }

                // 标题（编辑态 / 展示态）
                if isEditingTitle {
                    TextField("标题", text: $editTitle)
                        .textFieldStyle(.plain)
                        .font(.system(size: 16, weight: .medium))
                        .focused($titleFocused)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(Color(nsColor: .textBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.appBrand.primaryBlue.opacity(0.5), lineWidth: 1.5)
                        )
                        .onSubmit { commitTitleEdit() }
                        .onKeyPress(.escape) {
                            cancelTitleEdit()
                            return .handled
                        }
                } else {
                    Text(todo.title.isEmpty ? "新待办" : todo.title)
                        .font(.system(size: 16, weight: .medium))
                        .lineLimit(3)
                        .strikethrough(todo.isCompleted, color: Color.secondary.opacity(0.4))
                        .foregroundStyle(todo.isCompleted ? Color.secondary.opacity(0.45) : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Spacer(minLength: 4)

                // ── 操作图标（hover 时显示 / 选中时显示）──
                if isHovering || isSelected {
                    HStack(spacing: 2) {
                        // 字体
                        IconPillButton(icon: "textformat") { showFontPanel.toggle() }
                            .popover(isPresented: $showFontPanel, arrowEdge: .top) {
                                FontSettingsPanel(fontSize: Binding(
                                    get: { CGFloat(todo.titleFontSize) },
                                    set: { todo.titleFontSize = Double($0); viewModel.saveTodo(todo) }
                                ))
                                .padding(14)
                                .frame(width: 200)
                            }

                        // ➕ 加子待办
                        IconPillButton(icon: "plus") {
                            showSubtaskInput = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                subtaskFocused = true
                            }
                        }

                        // ✓ 完成
                        IconPillButton(icon: "checkmark") {
                            viewModel.toggleTodoCompletion(todo)
                        }
                        .foregroundStyle(todo.isCompleted ? .green : .secondary)

                        // 🗑 删除
                        DangerIconButton(icon: "trash") { showDeleteAlert = true }
                    }
                    .transition(.opacity)
                } else {
                    // 不 hover 时只显示完成状态对号
                    if todo.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.green.opacity(0.5))
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(minHeight: rowHeight)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor)
            )
            .onHover { isHovering = $0 }
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture(count: 2).onEnded {
                    startTitleEdit()
                }
            )
            .onTapGesture {
                if isEditingTitle { return }
                appState.selectedTodo = todo
            }

            // ── 子待办列表 ──
            if !todo.subtasks.isEmpty {
                VStack(spacing: 0) {
                    ForEach(
                        Array(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder }).enumerated()),
                        id: \.element.id
                    ) { subIdx, subtask in
                        SubtaskLineView(subtaskIndex: subIdx + 1, subtask: subtask, parentTodo: todo)
                            .environmentObject(viewModel)
                    }
                }
                .padding(.leading, 48)
            }

            // ── 子待办输入框 ──
            if showSubtaskInput {
                subtaskInputView
                    .padding(.leading, 48)
                    .padding(.bottom, 8)
                    .padding(.trailing, 14)
            }

            // 底部分割线（极淡）
            if !isSelected {
                Rectangle()
                    .fill(Color.primary.opacity(0.04))
                    .frame(height: 1)
                    .padding(.leading, 48)
            }
        }
        .animation(.easeOut(duration: 0.15), value: isHovering)
        .animation(.easeOut(duration: 0.15), value: isSelected)
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteTodo(todo) }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    private var backgroundColor: Color {
        if isSelected { return Color.rowSelected }
        if isHovering { return Color.rowHover }
        return Color.clear
    }

    // MARK: - 子待办输入
    private var subtaskInputView: some View {
        HStack(spacing: 8) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 11))
                .foregroundStyle(Color.appBrand.primaryBlue)
            TextField("添加子任务…", text: $subtaskText)
                .textFieldStyle(.plain)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .focused($subtaskFocused)
                .onSubmit { addSubtask() }
            Button(action: addSubtask) {
                Text("确认")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.appBrand.primaryBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(nsColor: .quaternaryLabelColor).opacity(0.12))
        )
    }

    private func addSubtask() {
        guard !subtaskText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        viewModel.addSubtask(to: todo, title: subtaskText)
        subtaskText = ""
        showSubtaskInput = false
    }

    // MARK: - 内联标题编辑
    private func startTitleEdit() {
        guard !isEditingTitle else { return }
        editTitle = todo.title
        isEditingTitle = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            titleFocused = true
        }
    }

    private func commitTitleEdit() {
        let trimmed = editTitle.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            todo.title = trimmed
            viewModel.saveTodo(todo)
        }
        isEditingTitle = false
        titleFocused = false
    }

    private func cancelTitleEdit() {
        isEditingTitle = false
        titleFocused = false
    }
}

// MARK: - 字体面板
struct FontSettingsPanel: View {
    @Binding var fontSize: CGFloat

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "textformat")
                    .font(.system(size: 11))
                Text("字体大小")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                Button(action: { fontSize = max(10, fontSize - 1) }) {
                    Image(systemName: "minus")
                        .font(.system(size: 9, weight: .bold))
                        .frame(width: 22, height: 22)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)

                Slider(value: $fontSize, in: 10...36, step: 1)
                    .controlSize(.small)

                Button(action: { fontSize = min(36, fontSize + 1) }) {
                    Image(systemName: "plus")
                        .font(.system(size: 9, weight: .bold))
                        .frame(width: 22, height: 22)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 4) {
                ForEach([12, 14, 16, 18, 20, 24, 28, 32], id: \.self) { size in
                    Button(action: { fontSize = CGFloat(size) }) {
                        Text("\(size)")
                            .font(.system(size: 9))
                            .foregroundStyle(fontSize == CGFloat(size) ? .white : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 3)
                            .background(fontSize == CGFloat(size) ? Color.appBrand.primaryBlue : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }
                    .buttonStyle(.plain)
                }
            }

            PremiumDivider()

            Text("Aa")
                .font(.system(size: fontSize, weight: .medium))
                .foregroundStyle(.primary)
            Text("\(Int(fontSize))pt")
                .font(.system(size: 9))
                .foregroundStyle(.tertiary)
        }
    }
}

// MARK: - 子待办行
struct SubtaskLineView: View {
    let subtaskIndex: Int
    let subtask: SubtaskItem
    let parentTodo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var showDeleteAlert = false
    @State private var isHovering = false
    @State private var isEditing = false
    @State private var editText: String = ""
    @FocusState private var editFocused: Bool

    var body: some View {
        HStack(spacing: 10) {
            // 子序号
            Text("\(subtaskIndex).")
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .foregroundStyle(.tertiary)
                .frame(width: 18, alignment: .trailing)

            // 文字（编辑态 / 展示态）
            if isEditing {
                TextField("子任务", text: $editText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .focused($editFocused)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color(nsColor: .textBackgroundColor))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(Color.appBrand.primaryBlue.opacity(0.5), lineWidth: 1.5)
                    )
                    .onSubmit { commitEdit() }
                    .onKeyPress(.escape) {
                        cancelEdit()
                        return .handled
                    }
            } else {
                Text(subtask.title)
                    .font(.system(size: 14))
                    .lineLimit(3)
                    .strikethrough(subtask.isCompleted, color: Color.secondary.opacity(0.4))
                    .foregroundStyle(subtask.isCompleted ? Color.secondary.opacity(0.45) : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 4)

            // 操作（hover 显示）
            if isHovering && !isEditing {
                HStack(spacing: 2) {
                    IconPillButton(icon: "checkmark") {
                        viewModel.toggleSubtaskCompletion(subtask)
                    }
                    DangerIconButton(icon: "xmark") { showDeleteAlert = true }
                }
                .transition(.opacity)
            } else if subtask.isCompleted && !isEditing {
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Color.green.opacity(0.5))
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(isHovering ? Color.rowHover : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture(count: 2).onEnded {
                startEdit()
            }
        )
        .onTapGesture { }
        .onHover { isHovering = $0 }
        .alert("删除子待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) { viewModel.deleteSubtask(subtask) }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }

    // MARK: - 内联编辑
    private func startEdit() {
        guard !isEditing else { return }
        editText = subtask.title
        isEditing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            editFocused = true
        }
    }

    private func commitEdit() {
        let trimmed = editText.trimmingCharacters(in: .whitespaces)
        if !trimmed.isEmpty {
            subtask.title = trimmed
            subtask.updateTimestamp()
            viewModel.saveTodo(parentTodo)
        }
        isEditing = false
        editFocused = false
    }

    private func cancelEdit() {
        isEditing = false
        editFocused = false
    }
}
```

---

## Views/MainList/CalendarView.swift

```swift
import SwiftUI

struct CompactCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var currentMonth: Date = Date()

    private let calendar = Calendar.current
    private let weekDays = ["一", "二", "三", "四", "五", "六", "日"]

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Button(action: { moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(.quaternary.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Spacer()

                Text(monthYearString(from: currentMonth))
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: { moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                        .frame(width: 28, height: 28)
                        .background(.quaternary.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 4)

            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date),
                            hasTodos: hasTodos(on: date)
                        )
                        .onTapGesture {
                            selectedDate = date
                            isPresented = false
                        }
                    } else {
                        Color.clear
                            .frame(height: 34)
                    }
                }
            }

            if !calendar.isDateInToday(selectedDate) {
                PremiumDivider()
                Button(action: {
                    selectedDate = Date()
                    isPresented = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.uturn.backward")
                            .font(.system(size: 10))
                        Text("回到今天")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(Color.appBrand.primaryBlue)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(14)
        .frame(width: 270)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.surfaceBackground)
        )
    }

    private func moveMonth(by amount: Int) {
        if let newDate = calendar.date(byAdding: .month, value: amount, to: currentMonth) {
            currentMonth = newDate
        }
    }

    private func monthYearString(from date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "yyyy年 M月"
        return f.string(from: date)
    }

    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthStart = monthInterval.start as Date?
        else { return [] }

        let weekday = calendar.component(.weekday, from: monthStart)
        let offset = weekday == 1 ? 6 : weekday - 2

        var days: [Date?] = Array(repeating: nil, count: offset)

        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }

        return days
    }

    private func hasTodos(on date: Date) -> Bool {
        viewModel.todos.contains { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasTodos: Bool
    @State private var isHovering = false

    var body: some View {
        ZStack {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 13, weight: isToday ? .semibold : .regular))
                .foregroundStyle(textColor)
                .frame(width: 34, height: 34)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(backgroundColor)
                        .animation(.easeOut(duration: 0.12), value: isSelected)
                )

            if hasTodos && !isSelected {
                Circle()
                    .fill(Color.appBrand.primaryBlue)
                    .frame(width: 4, height: 4)
                    .offset(y: 12)
            }
        }
        .onHover { isHovering = $0 }
    }

    private var textColor: Color {
        if isSelected { return .white }
        if isToday { return Color.appBrand.primaryBlue }
        return .primary
    }

    private var backgroundColor: Color {
        if isSelected { return Color.appBrand.primaryBlue }
        if isToday { return Color.blue.opacity(0.08) }
        if isHovering { return Color(nsColor: .quaternaryLabelColor).opacity(0.15) }
        return Color.clear
    }
}
```

---

## Services/DataService.swift

```swift
import SwiftData
import Foundation

class DataService {
    static let shared = DataService()

    private init() {}

    func saveRichText(_ attributedString: NSAttributedString, to todo: TodoItem) {
        let range = NSRange(location: 0, length: attributedString.length)
        if let data = try? attributedString.rtf(from: range) {
            todo.richTextDescription = data
            todo.plainTextDescription = attributedString.string
            todo.updateTimestamp()
        }
    }

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

    func hasTodos(for date: Date, in todos: [TodoItem]) -> Bool {
        let calendar = Calendar.current
        return todos.contains { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

    func todoCount(for date: Date, in todos: [TodoItem]) -> Int {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }.count
    }
}
```

---

## Services/RichTextService.swift

```swift
import AppKit
import SwiftUI

struct RichTextEditor: NSViewRepresentable {
    @Binding var attributedString: NSAttributedString
    var isEditable: Bool = true

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .clear

        let textView = CustomTextView()
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = true
        textView.importsGraphics = false
        textView.allowsImageEditing = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.usesAdaptiveColorMappingForDarkAppearance = true
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.delegate = context.coordinator
        textView.textStorage?.setAttributedString(attributedString)

        textView.font = NSFont.systemFont(ofSize: 14)
        textView.textColor = .labelColor
        textView.drawsBackground = false
        textView.allowsUndo = true
        textView.enabledTextCheckingTypes = 0

        scrollView.documentView = textView

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.attributedString() != attributedString {
            textView.textStorage?.setAttributedString(attributedString)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.attributedString = textView.attributedString()
        }
    }
}

class CustomTextView: NSTextView {
    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == .keyDown {
            if event.modifierFlags.contains(.command) {
                switch event.charactersIgnoringModifiers?.lowercased() {
                case "b":
                    toggleBold()
                    return true
                case "i":
                    toggleItalic()
                    return true
                case "u":
                    toggleUnderline()
                    return true
                default:
                    break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }

    func toggleBold() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentFont = font ?? NSFont.systemFont(ofSize: 14)
        let isBold = currentFont.fontDescriptor.symbolicTraits.contains(.bold)
        let newFont: NSFont
        if isBold {
            newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: .boldFontMask)
        } else {
            newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .boldFontMask)
        }
        textStorage.addAttribute(.font, value: newFont, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleItalic() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentFont = font ?? NSFont.systemFont(ofSize: 14)
        let isItalic = currentFont.fontDescriptor.symbolicTraits.contains(.italic)
        let newFont: NSFont
        if isItalic {
            newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: .italicFontMask)
        } else {
            newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .italicFontMask)
        }
        textStorage.addAttribute(.font, value: newFont, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleUnderline() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentUnderline = textStorage.attribute(.underlineStyle, at: selectedRange().location, effectiveRange: nil) as? Int ?? 0
        let newValue: Int = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
        textStorage.addAttribute(.underlineStyle, value: newValue, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleStrikethrough() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentStrike = textStorage.attribute(.strikethroughStyle, at: selectedRange().location, effectiveRange: nil) as? Int ?? 0
        let newValue: Int = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
        textStorage.addAttribute(.strikethroughStyle, value: newValue, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func setFontColor(_ color: NSColor) {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        textStorage.addAttribute(.foregroundColor, value: color, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func setBackgroundColor(_ color: NSColor) {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        textStorage.addAttribute(.backgroundColor, value: color, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func insertBulletList() {
        insertText("• ", replacementRange: selectedRange())
    }

    func insertNumberedList() {
        let paragraphRange = textStorage?.mutableString.paragraphRange(for: selectedRange()) ?? selectedRange()
        let lineNumber = textStorage?.mutableString
            .substring(with: NSRange(location: 0, length: paragraphRange.location))
            .components(separatedBy: "\n").count ?? 1
        insertText("\(lineNumber). ", replacementRange: selectedRange())
    }

    func attributedStringToData() -> Data? {
        guard let textStorage = textStorage else { return nil }
        let range = NSRange(location: 0, length: textStorage.length)
        let data = textStorage.rtf(from: range)
        return data
    }

    func loadFromData(_ data: Data) {
        guard let textStorage = textStorage else { return }
        do {
            let attrString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            textStorage.setAttributedString(attrString)
        } catch {
            print("Failed to load RTF data: \(error)")
        }
    }
}
```

---

## Components/PremiumControls.swift

```swift
import SwiftUI

// MARK: - Pill Chip
struct InfoChip: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
            Text(text)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(color.opacity(0.08))
        .clipShape(Capsule())
    }
}

// MARK: - Icon Pill Button
struct IconPillButton: View {
    let icon: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isHovering ? Color.blue : .secondary)
                .frame(width: 30, height: 30)
                .background(isHovering ? Color.blue.opacity(0.08) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Primary Action Button
struct PrimaryActionButton: View {
    let title: String
    let disabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: PremiumRadius.medium, style: .continuous)
                        .fill(disabled ? Color.blue.opacity(0.3) : Color.appBrand.primaryBlue)
                )
        }
        .buttonStyle(.plain)
        .disabled(disabled)
        .animation(.easeOut(duration: 0.15), value: disabled)
    }
}

// MARK: - Ghost Button
struct GhostButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .medium))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
            }
            .foregroundStyle(isHovering ? Color.appBrand.primaryBlue : .secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(isHovering ? Color.blue.opacity(0.06) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Danger Icon Button
struct DangerIconButton: View {
    let icon: String
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isHovering ? Color.appBrand.dangerRed : .secondary)
                .frame(width: 30, height: 30)
                .background(isHovering ? Color.appBrand.dangerRed.opacity(0.08) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Premium Checkbox
struct PremiumCheckbox: View {
    let isCompleted: Bool
    let action: () -> Void
    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            Circle()
                .strokeBorder(isCompleted ? Color.appBrand.successGreen : Color.primary.opacity(0.25), lineWidth: 1.5)
                .frame(width: 20, height: 20)
                .background(
                    Circle()
                        .fill(isCompleted ? Color.appBrand.successGreen.opacity(0.12) : Color.clear)
                        .frame(width: 24, height: 24)
                )
                .overlay {
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Color.appBrand.successGreen)
                    }
                }
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .scaleEffect(isHovering ? 1.05 : 1.0)
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

// MARK: - Empty State
struct PremiumEmptyState: View {
    let icon: String
    let title: String
    let subtitle: String
    let hint: String

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.06))
                    .frame(width: 80, height: 80)
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.appBrand.primaryBlue.opacity(0.6))
            }

            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text(hint)
                .font(.system(size: 12))
                .foregroundStyle(.tertiary)
                .padding(.top, 4)

            Spacer()
        }
    }
}

// MARK: - Premium Divider
struct PremiumDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.primary.opacity(0.06))
            .frame(height: 1)
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(label)
                    .font(.system(size: 10))
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: PremiumRadius.medium, style: .continuous)
                .fill(Color.surfaceBackground)
                .softBorder(radius: PremiumRadius.medium)
        )
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(isCompleted ? Color.appBrand.successGreen : Color.appBrand.primaryBlue)
                .frame(width: 6, height: 6)
            Text(isCompleted ? "已完成" : "进行中")
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(isCompleted ? Color.appBrand.successGreen : Color.appBrand.primaryBlue)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            (isCompleted ? Color.appBrand.successGreen : Color.appBrand.primaryBlue).opacity(0.08)
        )
        .clipShape(Capsule())
    }
}
```

---

## Utilities/DesignSystem.swift

```swift
import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let appBrand = AppBrand()
}

struct AppBrand {
    let primaryBlue = Color(red: 0.145, green: 0.392, blue: 0.925)
    let accentCyan = Color(red: 0.024, green: 0.714, blue: 0.831)
    let successGreen = Color(red: 0.133, green: 0.773, blue: 0.369)
    let dangerRed = Color(red: 0.937, green: 0.267, blue: 0.267)
    let warningAmber = Color(red: 0.961, green: 0.620, blue: 0.043)
}

// MARK: - Semantic Colors (Adaptive)
extension Color {
    static var appBackground: Color { Color(nsColor: .windowBackgroundColor) }
    static var panelBackground: Color { Color(nsColor: .controlBackgroundColor) }
    static var elevatedCardBackground: Color { Color(nsColor: .controlBackgroundColor) }
    static var softSeparator: Color { Color.primary.opacity(0.06) }
    static var cardBorder: Color { Color.primary.opacity(0.06) }
    static var inkPrimary: Color { Color.primary }
    static var inkSecondary: Color { Color.secondary }
    static var inkTertiary: Color { Color(nsColor: .tertiaryLabelColor) }
    static var rowHover: Color { Color.blue.opacity(0.04) }
    static var rowSelected: Color { Color.blue.opacity(0.08) }
    static var glassBackground: Color { Color(nsColor: .windowBackgroundColor).opacity(0.72) }
    static var surfaceBackground: Color { Color(nsColor: .controlBackgroundColor) }
    static var quaternaryColor: Color { Color(nsColor: .quaternaryLabelColor) }
    static var floatingMaterial: Color { Color(nsColor: .windowBackgroundColor).opacity(0.85) }
}

// MARK: - Shadows
extension View {
    func softShadow() -> some View {
        self.shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    func cardShadow() -> some View {
        self.shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    func floatingShadow() -> some View {
        self.shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 8)
    }
}

// MARK: - Corner Radius
enum PremiumRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xl: CGFloat = 22
    static let xxl: CGFloat = 24
    static let pill: CGFloat = 999
}

// MARK: - Font Sizes
enum PremiumFont {
    static let heroTitle: Font = .system(size: 32, weight: .bold)
    static let sectionTitle: Font = .system(size: 13, weight: .semibold)
    static let body: Font = .system(size: 15, weight: .regular)
    static let caption: Font = .system(size: 12, weight: .regular)
    static let micro: Font = .system(size: 10, weight: .regular)
}

// MARK: - View Modifiers
struct PremiumCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                    .fill(Color.elevatedCardBackground)
                    .cardShadow()
            )
            .overlay(
                RoundedRectangle(cornerRadius: PremiumRadius.xl, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
    }
}

struct GlassPanelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: PremiumRadius.large, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: PremiumRadius.large, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
    }
}

struct SoftBorderStyle: ViewModifier {
    let radius: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(Color.cardBorder, lineWidth: 0.5)
            )
    }
}

extension View {
    func premiumCard() -> some View { modifier(PremiumCardStyle()) }
    func glassPanel() -> some View { modifier(GlassPanelStyle()) }
    func softBorder(radius: CGFloat = PremiumRadius.medium) -> some View { modifier(SoftBorderStyle(radius: radius)) }
    func premiumBackground() -> some View {
        self.background(
            LinearGradient(
                colors: [
                    Color(nsColor: .windowBackgroundColor),
                    Color(nsColor: .controlBackgroundColor).opacity(0.85),
                    Color.blue.opacity(0.02)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}
```

---

## 架构 / 数据流

```
ContentView (@Query → SwiftData 自动拉取 TodoItem[])
  │  .onChange(of: todos) → viewModel.todos = newTodos
  │
  ├─ AppState (ObservableObject)  ← selectedDate, selectedTodo, colorScheme
  ├─ TodoViewModel (ObservableObject) ← 手动 CRUD + 日期筛选
  └─ MainListView
       ├─ HeroHeader + 日历popover
       ├─ ForEach(dateTodos) → TodoCardView
       │    ├─ 双击 → 内联 TextField（白色背景+蓝色边框）
       │    ├─ 单击 → selectedTodo = todo（高亮）
       │    ├─ 子待办列表 → SubtaskLineView
       │    │    ├─ 双击 → 内联编辑
       │    │    └─ hover → 完成/删除
       │    └─ 子待办输入框（hover ➕ 触发）
       └─ FloatingComposer（底部浮动输入栏 + 添加按钮）
```

## 手势系统关键经验

macOS SwiftUI 上单击/双击的正确做法：

```swift
// ✅ 正确
.contentShape(Rectangle())
.simultaneousGesture(TapGesture(count: 2).onEnded { /* 双击 */ })
.onTapGesture { /* 单击 */ }  // ← 必须有！否则 simultaneousGesture 不激活

// ❌ 错误：onTapGesture + onTapGesture(count: 2) 链式组合 — 优先级混乱
// ❌ 错误：simultaneousGesture 后跟 onHover 而不是 onTapGesture
// ❌ 错误：NSApp.currentEvent?.clickCount 在 onTapGesture 闭包里不可靠
```

## 当前 Bug（待你排查）

**子待办双击编辑不工作。** 大待办的双击编辑已确认正常。两者的 gesture 代码结构现在完全一致：

| | 大待办 | 子待办 |
|---|---|---|
| contentShape | ✅ | ✅ |
| simultaneousGesture(TapGesture(count: 2)) | ✅ | ✅ |
| .onTapGesture { } | ✅ | ✅ |
| 编辑状态 | isEditingTitle | isEditing |
| 焦点 | titleFocused | editFocused |

子待办的 `SubtaskLineView` 渲染在父 `TodoCardView` 的 VStack 内部——可能父视图的某个 modifier 或 ForEach 的视图复用影响了子待办的 gesture 识别。
