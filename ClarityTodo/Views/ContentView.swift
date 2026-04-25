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
            .frame(minWidth: 500, minHeight: 400)
            .onAppear {
                viewModel.setup(with: modelContext)
            }
            .onChange(of: todos) { _, newTodos in
                viewModel.todos = newTodos
            }
    }
}
