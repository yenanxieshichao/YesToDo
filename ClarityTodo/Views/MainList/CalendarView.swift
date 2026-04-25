import SwiftUI

/// 小巧的日历弹出视图，适合放在 popover 里
struct CompactCalendarView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var currentMonth: Date = Date()

    private let calendar = Calendar.current
    private let weekDays = ["日", "一", "二", "三", "四", "五", "六"]

    var body: some View {
        VStack(spacing: 6) {
            // 月份切换
            HStack {
                Button(action: { moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .font(.caption)
                }
                .buttonStyle(.plain)

                Spacer()

                Text(monthYearString(from: currentMonth))
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Button(action: { moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 4)

            // 星期行
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // 日期网格
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 2) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        CompactDayCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date),
                            hasTodos: hasTodos(on: date)
                        )
                        .onTapGesture {
                            selectedDate = date
                            isPresented = false // 选完自动关闭
                        }
                    } else {
                        Color.clear
                            .frame(height: 26)
                    }
                }
            }

            // 快捷跳转今天
            if !calendar.isDateInToday(selectedDate) {
                Divider()
                Button("回到今天") {
                    selectedDate = Date()
                    isPresented = false
                }
                .font(.caption)
                .buttonStyle(.plain)
                .foregroundStyle(.blue)
            }
        }
        .padding(10)
        .frame(width: 210)
    }

    private func moveMonth(by amount: Int) {
        if let newDate = calendar.date(byAdding: .month, value: amount, to: currentMonth) {
            currentMonth = newDate
        }
    }

    private func monthYearString(from date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "zh_CN")
        f.dateFormat = "M月"
        return f.string(from: date)
    }

    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthStart = monthInterval.start as Date?
        else { return [] }

        let weekdayOffset = calendar.component(.weekday, from: monthStart) - 1
        var days: [Date?] = Array(repeating: nil, count: weekdayOffset)

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

struct CompactDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasTodos: Bool

    var body: some View {
        Text("\(Calendar.current.component(.day, from: date))")
            .font(.system(size: 12, weight: isToday ? .bold : .regular))
            .foregroundStyle(foregroundColor)
            .frame(width: 24, height: 24)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .overlay(
                hasTodos && !isSelected
                    ? Circle()
                        .fill(.blue)
                        .frame(width: 3, height: 3)
                        .offset(y: 8)
                    : nil
            )
    }

    private var foregroundColor: Color {
        if isSelected { return .white }
        if isToday { return .blue }
        return .primary
    }

    private var backgroundView: some View {
        Group {
            if isSelected { Color.blue }
            else if isToday { Color.blue.opacity(0.1) }
            else { Color.clear }
        }
    }
}
