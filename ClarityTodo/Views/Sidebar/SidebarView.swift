import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        VStack(spacing: 0) {
            // App logo and title
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.blue.gradient)
                Text("Clarity")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                TextField("Search...", text: $appState.searchText)
                    .textFieldStyle(.plain)
                    .font(.body)
            }
            .padding(8)
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            // Sidebar items
            List(selection: $appState.selectedSidebarItem) {
                ForEach(SidebarItem.allCases) { item in
                    SidebarRow(item: item, count: countForItem(item))
                        .tag(item)
                        .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background(.clear)
        }
        .frame(minWidth: 200)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }

    private func countForItem(_ item: SidebarItem) -> Int {
        return viewModel.filteredTodos(for: item).count
    }
}

struct SidebarRow: View {
    let item: SidebarItem
    let count: Int

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: item.icon)
                .font(.system(size: 14))
                .foregroundStyle(iconColor)
                .frame(width: 20)

            Text(item.rawValue)
                .font(.body)
                .fontWeight(.medium)

            Spacer()

            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.quaternary.opacity(0.6))
                    .clipShape(Capsule())
            }
        }
        .contentShape(Rectangle())
        .padding(.vertical, 4)
    }

    private var iconColor: AnyGradient {
        switch item {
        case .today: return Color.blue.gradient
        case .upcoming: return Color.orange.gradient
        case .calendar: return Color.purple.gradient
        case .completed: return Color.green.gradient
        }
    }
}
