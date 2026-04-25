import SwiftUI

struct MainListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var showDeleteAlert = false
    @State private var todoToDelete: TodoItem? = nil

    var displayedTodos: [TodoItem] {
        // When calendar is active with a selected date
        if appState.selectedSidebarItem == .calendar, let date = appState.filterDate {
            return viewModel.todosForDate(date)
        }
        return viewModel.filteredTodos(for: appState.selectedSidebarItem)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(appState.selectedSidebarItem == .calendar && appState.filterDate != nil
                     ? formatDate(appState.filterDate!)
                     : appState.selectedSidebarItem.rawValue)
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: { appState.isCalendarOpen.toggle() }) {
                    Image(systemName: appState.isCalendarOpen ? "calendar.badge.checkmark" : "calendar")
                        .font(.body)
                }
                .buttonStyle(.plain)
                .help("Toggle Calendar")

                Button(action: {
                    viewModel.createNewTodo(date: appState.filterDate)
                }) {
                    Image(systemName: "plus")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.plain)
                .help("New Todo (Command+N)")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Calendar (when toggled)
            if appState.isCalendarOpen {
                CalendarView()
                    .environmentObject(appState)
                    .environmentObject(viewModel)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            Divider()

            // Todo list
            if displayedTodos.isEmpty {
                EmptyStateView()
            } else {
                List(selection: $appState.selectedTodo) {
                    ForEach(displayedTodos) { todo in
                        TodoCardView(todo: todo)
                            .tag(todo)
                            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .contextMenu {
                                Button("Mark as \(todo.isCompleted ? "Incomplete" : "Complete")") {
                                    viewModel.toggleTodoCompletion(todo)
                                }
                                Divider()
                                Button("Copy") {
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(todo.title, forType: .string)
                                }
                                Button("Delete", role: .destructive) {
                                    todoToDelete = todo
                                    showDeleteAlert = true
                                }
                            }
                    }
                    .onDeleteCommand {
                        if let selected = appState.selectedTodo {
                            todoToDelete = selected
                            showDeleteAlert = true
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
        .frame(minWidth: 320)
        .background(Color(nsColor: .controlBackgroundColor))
        .alert("Delete Todo", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let todo = todoToDelete {
                    viewModel.deleteTodo(todo)
                }
            }
        } message: {
            Text("Are you sure you want to delete \"\(todoToDelete?.title ?? "")\"? This action cannot be undone.")
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: date)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 48))
                .foregroundStyle(.quaternary)
            Text("No todos yet")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            Text("Click the + button or press Command+N\nto create your first todo")
                .font(.callout)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}
