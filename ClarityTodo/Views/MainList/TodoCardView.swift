import SwiftUI
import AppKit

private func paddedNumber(_ number: Int) -> String {
    number < 10 ? "0\(number)" : "\(number)"
}

private struct MacDoubleClickCatcher: NSViewRepresentable {
    var onDoubleClick: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onDoubleClick: onDoubleClick)
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor

        let recognizer = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleDoubleClick(_:))
        )
        recognizer.numberOfClicksRequired = 2
        recognizer.buttonMask = 0x1
        view.addGestureRecognizer(recognizer)

        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        context.coordinator.onDoubleClick = onDoubleClick
    }

    final class Coordinator: NSObject {
        var onDoubleClick: () -> Void

        init(onDoubleClick: @escaping () -> Void) {
            self.onDoubleClick = onDoubleClick
        }

        @objc func handleDoubleClick(_ recognizer: NSClickGestureRecognizer) {
            if recognizer.state == .ended {
                onDoubleClick()
            }
        }
    }
}

struct TodoCardView: View {
    let index: Int
    let todo: TodoItem

    @EnvironmentObject var viewModel: TodoViewModel
    @EnvironmentObject var appState: AppState

    @State private var isHovering = false
    @State private var isEditingTitle = false
    @State private var editTitle = ""
    @State private var showSubtaskInput = false
    @State private var subtaskText = ""
    @State private var showDeleteAlert = false

    @FocusState private var titleFocused: Bool
    @FocusState private var subtaskFocused: Bool

    private var isSelected: Bool {
        appState.selectedTodo?.id == todo.id
    }

    private var sortedSubtasks: [SubtaskItem] {
        todo.subtasks.sorted { $0.sortOrder < $1.sortOrder }
    }

    var body: some View {
        VStack(spacing: 0) {
            mainRow

            if !sortedSubtasks.isEmpty {
                VStack(spacing: 0) {
                    ForEach(Array(sortedSubtasks.enumerated()), id: \.element.id) { index, subtask in
                        SubtaskLineView(subtaskIndex: index + 1, subtask: subtask)
                            .environmentObject(viewModel)
                    }
                }
                .padding(.leading, 50)
                .padding(.trailing, 10)
                .padding(.bottom, showSubtaskInput ? 2 : 8)
            }

            if showSubtaskInput {
                subtaskInput
                    .padding(.leading, 50)
                    .padding(.trailing, 12)
                    .padding(.bottom, 10)
            }

            Divider()
                .opacity(isSelected ? 0 : 0.45)
                .padding(.leading, 50)
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.large, style: .continuous))
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.14), value: isHovering)
        .animation(.easeOut(duration: 0.14), value: isSelected)
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                viewModel.deleteTodo(todo)
                if appState.selectedTodo?.id == todo.id {
                    appState.selectedTodo = nil
                }
            }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    private var mainRow: some View {
        HStack(spacing: 12) {
            Text(paddedNumber(index))
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(.tertiary)
                .frame(width: 24, alignment: .trailing)

            TaskCheckbox(isCompleted: todo.isCompleted) {
                viewModel.toggleTodoCompletion(todo)
            }

            if isEditingTitle {
                titleEditor
            } else {
                titleLabel
            }

            Spacer(minLength: 8)

            if isHovering || isSelected || showSubtaskInput {
                rowActions
                    .transition(.opacity)
            } else if todo.isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.appSuccess.opacity(0.65))
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            if !isEditingTitle {
                appState.selectedTodo = todo
            }
        }
    }

    private var titleLabel: some View {
        Text(todo.title.isEmpty ? "未命名待办" : todo.title)
            .font(.system(size: 15, weight: .medium))
            .foregroundStyle(todo.isCompleted ? Color.secondary.opacity(0.55) : .primary)
            .strikethrough(todo.isCompleted, color: Color.secondary.opacity(0.45))
            .lineLimit(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay {
                MacDoubleClickCatcher {
                    startTitleEdit()
                }
            }
    }

    private var titleEditor: some View {
        TextField("待办标题", text: $editTitle)
            .textFieldStyle(.plain)
            .font(.system(size: 15, weight: .medium))
            .focused($titleFocused)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color.appSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous))
            .subtleBorder(AppRadius.small)
            .onSubmit(commitTitleEdit)
            .onKeyPress(.escape) {
                cancelTitleEdit()
                return .handled
            }
            .onChange(of: titleFocused) { _, focused in
                if !focused && isEditingTitle {
                    commitTitleEdit()
                }
            }
    }

    private var rowActions: some View {
        HStack(spacing: 2) {
            IconPillButton(icon: "plus", accessibilityLabel: "添加子任务") {
                showSubtaskInput = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    subtaskFocused = true
                }
            }

            IconPillButton(icon: "pencil", accessibilityLabel: "编辑标题") {
                startTitleEdit()
            }

            DangerIconButton(icon: "trash", accessibilityLabel: "删除待办") {
                showDeleteAlert = true
            }
        }
    }

    private var subtaskInput: some View {
        HStack(spacing: 8) {
            TextField("添加子任务", text: $subtaskText)
                .textFieldStyle(.plain)
                .font(.system(size: 13))
                .focused($subtaskFocused)
                .onSubmit(addSubtask)
                .onKeyPress(.escape) {
                    cancelSubtaskInput()
                    return .handled
                }

            Button("添加") {
                addSubtask()
            }
            .buttonStyle(.borderless)
            .disabled(subtaskText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Button("取消") {
                cancelSubtaskInput()
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Color.primary.opacity(0.035))
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
    }

    private var backgroundColor: Color {
        if isSelected { return .rowSelected }
        if isHovering { return .rowHover }
        return .clear
    }

    private func startTitleEdit() {
        guard !isEditingTitle else { return }
        appState.selectedTodo = todo
        editTitle = todo.title
        isEditingTitle = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            titleFocused = true
        }
    }

    private func commitTitleEdit() {
        guard isEditingTitle else { return }
        let trimmed = editTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && trimmed != todo.title {
            todo.title = trimmed
            viewModel.saveTodo(todo)
        }
        isEditingTitle = false
        titleFocused = false
    }

    private func cancelTitleEdit() {
        editTitle = todo.title
        isEditingTitle = false
        titleFocused = false
    }

    private func addSubtask() {
        let trimmed = subtaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        viewModel.addSubtask(to: todo, title: trimmed)
        subtaskText = ""
        showSubtaskInput = false
    }

    private func cancelSubtaskInput() {
        subtaskText = ""
        showSubtaskInput = false
        subtaskFocused = false
    }
}

struct SubtaskLineView: View {
    let subtaskIndex: Int
    let subtask: SubtaskItem

    @EnvironmentObject var viewModel: TodoViewModel

    @State private var isHovering = false
    @State private var isEditing = false
    @State private var editText = ""
    @State private var showDeleteAlert = false

    @FocusState private var editFocused: Bool

    var body: some View {
        HStack(spacing: 9) {
            Text("\(subtaskIndex).")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(.tertiary)
                .frame(width: 22, alignment: .trailing)

            TaskCheckbox(isCompleted: subtask.isCompleted, size: 15) {
                viewModel.toggleSubtaskCompletion(subtask)
            }

            if isEditing {
                editor
            } else {
                title
            }

            Spacer(minLength: 8)

            if isHovering && !isEditing {
                actions
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(isHovering ? Color.rowHover : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.medium, style: .continuous))
        .onHover { isHovering = $0 }
        .alert("删除子任务", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                viewModel.deleteSubtask(subtask)
            }
        } message: {
            Text("确定要删除「\(subtask.title)」吗？")
        }
    }

    private var title: some View {
        Text(subtask.title.isEmpty ? "子任务" : subtask.title)
            .font(.system(size: 13))
            .foregroundStyle(subtask.isCompleted ? Color.secondary.opacity(0.55) : .primary)
            .strikethrough(subtask.isCompleted, color: Color.secondary.opacity(0.45))
            .lineLimit(3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay {
                MacDoubleClickCatcher {
                    startEdit()
                }
            }
    }

    private var editor: some View {
        TextField("子任务", text: $editText)
            .textFieldStyle(.plain)
            .font(.system(size: 13))
            .focused($editFocused)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.appSurfaceElevated)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.small, style: .continuous))
            .subtleBorder(AppRadius.small)
            .onSubmit(commitEdit)
            .onKeyPress(.escape) {
                cancelEdit()
                return .handled
            }
            .onChange(of: editFocused) { _, focused in
                if !focused && isEditing {
                    commitEdit()
                }
            }
    }

    private var actions: some View {
        HStack(spacing: 0) {
            IconPillButton(icon: "pencil", accessibilityLabel: "编辑子任务") {
                startEdit()
            }

            DangerIconButton(icon: "trash", accessibilityLabel: "删除子任务") {
                showDeleteAlert = true
            }
        }
    }

    private func startEdit() {
        guard !isEditing else { return }
        editText = subtask.title
        isEditing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            editFocused = true
        }
    }

    private func commitEdit() {
        guard isEditing else { return }
        let trimmed = editText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty && trimmed != subtask.title {
            viewModel.updateSubtaskTitle(subtask, title: trimmed)
        }
        isEditing = false
        editFocused = false
    }

    private func cancelEdit() {
        editText = subtask.title
        isEditing = false
        editFocused = false
    }
}
