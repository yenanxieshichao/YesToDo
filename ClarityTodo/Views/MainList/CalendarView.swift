import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()

    private let calendar = Calendar.current
    private let weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack(spacing: 8) {
            // Month navigation
            HStack {
                Button(action: { moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.body)
                }
                .buttonStyle(.plain)

                Spacer()

                Text(monthYearString(from: currentMonth))
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: { moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.body)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 8)

            // Week day headers
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 4) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        DayCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date),
                            hasTodos: hasTodos(on: date),
                            todoCount: todoCount(on: date)
                        )
                        .onTapGesture {
                            selectedDate = date
                            appState.filterDate = date
                            appState.selectedSidebarItem = .calendar
                        }
                    } else {
                        Color.clear
                            .frame(height: 32)
                    }
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }

    private func moveMonth(by amount: Int) {
        if let newDate = calendar.date(byAdding: .month, value: amount, to: currentMonth) {
            currentMonth = newDate
        }
    }

    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeekday = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }

        var days: [Date?] = []
        let weekdayOffset = calendar.component(.weekday, from: monthInterval.start) - 1
        // Add padding for days before the 1st
        for _ in 0..<weekdayOffset {
            days.append(nil)
        }

        // Add all days in month
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start) {
                days.append(date)
            }
        }

        return days
    }

    private func hasTodos(on date: Date) -> Bool {
        return viewModel.todos.contains { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

    private func todoCount(on date: Date) -> Int {
        return viewModel.todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }.count
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasTodos: Bool
    let todoCount: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 12, weight: isToday ? .bold : .regular))
                .foregroundStyle(foregroundColor)
                .frame(width: 28, height: 28)
                .background(backgroundView)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            if hasTodos {
                HStack(spacing: 3) {
                    Circle()
                        .fill(.blue.opacity(0.5))
                        .frame(width: 4, height: 4)
                    if todoCount > 1 {
                        Text("\(todoCount)")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .frame(height: 36)
    }

    private var foregroundColor: Color {
        if isSelected { return .white }
        if isToday { return .blue }
        return .primary
    }

    private var backgroundView: some View {
        Group {
            if isSelected {
                Color.blue
            } else if isToday {
                Color.blue.opacity(0.1)
            } else {
                Color.clear
            }
        }
    }
}
