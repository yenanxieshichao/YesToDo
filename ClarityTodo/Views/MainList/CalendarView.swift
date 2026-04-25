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
            // ── 月份标题 ──
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

            // ── 星期行 ──
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: .infinity)
                }
            }

            // ── 日期网格 ──
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

            // ── 今天快捷 ──
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

        // 第一天是周几（1=周日, 2=周一…7=周六）
        let weekday = calendar.component(.weekday, from: monthStart)
        // 转换为周一始（1=周一…7=周日）
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
