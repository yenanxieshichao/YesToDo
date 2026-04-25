import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = TodoViewModel()
    @Query(sort: \TodoItem.sortOrder) private var todos: [TodoItem]

    var body: some View {
        HSplitView {
            // 左侧：今日待办清单
            MainListView()
                .environmentObject(appState)
                .environmentObject(viewModel)
                .frame(minWidth: 320, idealWidth: 380)

            // 右侧：详情编辑
            DetailView()
                .environmentObject(appState)
                .environmentObject(viewModel)
                .frame(minWidth: 300, idealWidth: 360)
        }
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
