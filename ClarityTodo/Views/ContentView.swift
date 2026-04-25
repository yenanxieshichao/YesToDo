import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = TodoViewModel()
    @Query(sort: \TodoItem.sortOrder) private var todos: [TodoItem]

    var body: some View {
        HSplitView {
            // 左侧：今日待办（58%）
            MainListView()
                .environmentObject(appState)
                .environmentObject(viewModel)
                .frame(minWidth: 480, idealWidth: 580)

            // 右侧：详情面板（42%）
            DetailView()
                .environmentObject(appState)
                .environmentObject(viewModel)
                .frame(minWidth: 360, idealWidth: 420)
        }
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
