import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = TodoViewModel()
    @Query(sort: \TodoItem.sortOrder) private var todos: [TodoItem]

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(appState)
                .environmentObject(viewModel)
        } content: {
            MainListView()
                .environmentObject(appState)
                .environmentObject(viewModel)
        } detail: {
            DetailView()
                .environmentObject(appState)
                .environmentObject(viewModel)
        }
        .navigationSplitViewStyle(.balanced)
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
