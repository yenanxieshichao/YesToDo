# 项目架构与源码概览

## 1. 目录结构
```text
clarity-todo/
    Package.swift
    .build/
        artifacts/
        checkouts/
        repositories/
        arm64-apple-macosx/
            debug/
                ClarityTodo.build/
                ClarityTodo.product/
                ClarityTodo.dSYM/
                    Contents/
                        Resources/
                            Relocations/
                                aarch64/
                            DWARF/
                ModuleCache/
                    2HQ24IOL88SUP/
                index/
                    store/
                        v5/
                            records/
                                5R/
                                Y2/
                                V6/
                                VZ/
                                ZQ/
                                0D/
                                9Y/
                                UU/
                                SL/
                                U9/
                                PD/
                                V1/
                                YY/
                                Y5/
                                59/
                                3L/
                                SK/
                                UR/
                                0C/
                                6Z/
                                ZV/
                                SB/
                                U7/
                                6S/
                                0J/
                                V8/
                                PM/
                                VT/
                                YP/
                                50/
                                Z4/
                                ZX/
                                0M/
                                6T/
                                9P/
                                U0/
                                57/
                                3B/
                                YW/
                                PJ/
                                6F/
                                03/
                                ZJ/
                                SW/
                                UN/
                                9B/
                                YE/
                                5I/
                                3P/
                                VA/
                                P4/
                                9E/
                                SP/
                                04/
                                0X/
                                P3/
                                VF/
                                3W/
                                5N/
                                YB/
                                VO/
                                PV/
                                YK/
                                9L/
                                S5/
                                SY/
                                ZD/
                                6H/
                                YL/
                                3Y/
                                35/
                                PQ/
                                VH/
                                6O/
                                ZC/
                                UG/
                                9K/
                                9Q/
                                SD/
                                U1/
                                Z5/
                                69/
                                0L/
                                6U/
                                VR/
                                PK/
                                56/
                                YV/
                                0K/
                                Z2/
                                U6/
                                UZ/
                                9V/
                                YQ/
                                51/
                                3D/
                                PL/
                                VU/
                                V9/
                                Y4/
                                YX/
                                3M/
                                67/
                                ZW/
                                SJ/
                                US/
                                93/
                                PB/
                                V7/
                                3J/
                                5S/
                                Y3/
                                9X/
                                94/
                                U8/
                                UT/
                                SM/
                                ZP/
                                0E/
                                60/
                                VI/
                                34/
                                3X/
                                5A/
                                S3/
                                UF/
                                9J/
                                0W/
                                ZB/
                                5F/
                                33/
                                YJ/
                                VN/
                                PW/
                                ZE/
                                0P/
                                6I/
                                SX/
                                UA/
                                S4/
                                ZL/
                                0Y/
                                05/
                                UH/
                                3V/
                                YC/
                                SV/
                                UO/
                                9C/
                                02/
                                6G/
                                ZK/
                                P5/
                                PY/
                                YD/
                                5H/
                                3Q/
                                AX/
                                A4/
                                HE/
                                N0/
                                BW/
                                DN/
                                KJ/
                                N7/
                                A3/
                                GF/
                                KM/
                                M8/
                                DI/
                                M1/
                                B5/
                                BY/
                                HK/
                                NR/
                                GO/
                                AV/
                                DG/
                                B2/
                                M6/
                                AQ/
                                GH/
                                N9/
                                HL/
                                DU/
                                BL/
                                KQ/
                                MH/
                                G6/
                                AC/
                                H2/
                                NG/
                                MO/
                                KV/
                                DR/
                                HY/
                                H5/
                                AD/
                                G1/
                                HP/
                                G8/
                                AM/
                                GT/
                                MF/
                                K3/
                                D7/
                                GS/
                                HW/
                                NN/
                                D0/
                                BE/
                                K4/
                                MA/
                                KX/
                                M7/
                                KB/
                                B3/
                                DF/
                                NT/
                                HM/
                                N8/
                                GI/
                                BX/
                                DA/
                                B4/
                                KE/
                                GN/
                                AW/
                                HJ/
                                GG/
                                A2/
                                NZ/
                                HC/
                                N6/
                                DH/
                                BQ/
                                M9/
                                KL/
                                HD/
                                A5/
                                AY/
                                MR/
                                BV/
                                DO/
                                HV/
                                GR/
                                KY/
                                K5/
                                BD/
                                D1/
                                AL/
                                GU/
                                G9/
                                HQ/
                                D6/
                                DZ/
                                BC/
                                K2/
                                MG/
                                DS/
                                MN/
                                KW/
                                G0/
                                AE/
                                H4/
                                KP/
                                D8/
                                DT/
                                BM/
                                NF/
                                H3/
                                AB/
                                G7/
                                LD/
                                EY/
                                OK/
                                IR/
                                FV/
                                CG/
                                LC/
                                JZ/
                                J6/
                                FQ/
                                I9/
                                IU/
                                FX/
                                F4/
                                OE/
                                I0/
                                EW/
                                CN/
                                LJ/
                                I7/
                                JT/
                                J8/
                                CI/
                                EP/
                                II/
                                OP/
                                FM/
                                L3/
                                OW/
                                IN/
                                C0/
                                L4/
                                JA/
                                EL/
                                C9/
                                LQ/
                                JH/
                                FC/
                                O2/
                                IG/
                                JO/
                                LV/
                                EK/
                                CR/
                                OY/
                                FD/
                                IZ/
                                OC/
                                I6/
                                CH/
                                EQ/
                                J9/
                                LL/
                                JU/
                                OD/
                                F5/
                                FY/
                                JR/
                                CO/
                                J7/
                                E3/
                                CF/
                                OM/
                                I8/
                                FP/
                                EX/
                                CA/
                                LE/
                                J0/
                                FW/
                                OJ/
                                IS/
                                EJ/
                                CS/
                                LW/
                                O4/
                                OX/
                                IA/
                                LP/
                                JI/
                                C8/
                                CT/
                                EM/
                                IF/
                                FB/
                                OV/
                                FK/
                                ED/
                                C1/
                                IH/
                                OQ/
                                CZ/
                                L2/
                                JG/
                                R7/
                                8N/
                                7J/
                                Q8/
                                QT/
                                XI/
                                4E/
                                7M/
                                1T/
                                18/
                                8I/
                                R0/
                                27/
                                4B/
                                QS/
                                WJ/
                                4K/
                                2R/
                                XG/
                                Q6/
                                11/
                                7D/
                                RU/
                                R9/
                                Q1/
                                29/
                                2U/
                                4L/
                                TK/
                                1Z/
                                16/
                                QO/
                                WV/
                                42/
                                2G/
                                XR/
                                8U/
                                89/
                                T5/
                                TY/
                                7Q/
                                1H/
                                X9/
                                4Y/
                                45/
                                WQ/
                                QH/
                                1O/
                                7V/
                                RG/
                                T2/
                                8R/
                                1F/
                                73/
                                TW/
                                RN/
                                87/
                                X0/
                                2I/
                                QA/
                                WX/
                                80/
                                RI/
                                TP/
                                74/
                                1A/
                                7X/
                                QF/
                                4W/
                                2N/
                                X7/
                                XA/
                                28/
                                WE/
                                17/
                                7B/
                                TJ/
                                RS/
                                8F/
                                WB/
                                Q7/
                                4J/
                                2S/
                                XF/
                                8A/
                                R8/
                                TM/
                                7E/
                                10/
                                8H/
                                TD/
                                WK/
                                2Z/
                                4C/
                                26/
                                1R/
                                7K/
                                R6/
                                RZ/
                                TC/
                                XH/
                                21/
                                4D/
                                WL/
                                QU/
                                75/
                                81/
                                TQ/
                                X6/
                                W2/
                                TV/
                                86/
                                8Z/
                                1G/
                                W5/
                                X1/
                                2H/
                                4Q/
                                WP/
                                QI/
                                44/
                                4X/
                                2A/
                                T3/
                                RF/
                                8S/
                                1N/
                                7W/
                                2F/
                                XS/
                                QN/
                                WW/
                                7P/
                                1I/
                                88/
                                8T/
                                RA/
                                T4/
                                9F/
                                UJ/
                                SS/
                                ZN/
                                6B/
                                07/
                                VE/
                                38/
                                5M/
                                YA/
                                00/
                                6E/
                                ZI/
                                UM/
                                S8/
                                9A/
                                5J/
                                P7/
                                VB/
                                YO/
                                36/
                                3Z/
                                5C/
                                PR/
                                VK/
                                6L/
                                0U/
                                S1/
                                UD/
                                9H/
                                VL/
                                PU/
                                5D/
                                31/
                                YH/
                                9O/
                                SZ/
                                S6/
                                ZG/
                                6K/
                                V2/
                                PG/
                                Y6/
                                YZ/
                                5V/
                                3O/
                                SH/
                                UQ/
                                65/
                                ZU/
                                Z9/
                                3H/
                                5Q/
                                Y1/
                                ZR/
                                0G/
                                9Z/
                                UV/
                                SO/
                                Z7/
                                6W/
                                9S/
                                SF/
                                U3/
                                5X/
                                3A/
                                54/
                                Y8/
                                YT/
                                VP/
                                PI/
                                UX/
                                SA/
                                98/
                                6P/
                                Z0/
                                PN/
                                VW/
                                YS/
                                53/
                                3F/
                                30/
                                YI/
                                PT/
                                P8/
                                ZF/
                                0S/
                                9N/
                                S7/
                                UB/
                                PS/
                                VJ/
                                5B/
                                37/
                                UE/
                                S0/
                                9I/
                                08/
                                6M/
                                0T/
                                ZA/
                                S9/
                                SU/
                                UL/
                                01/
                                ZH/
                                VC/
                                PZ/
                                P6/
                                YG/
                                3R/
                                ZO/
                                06/
                                6C/
                                0Z/
                                9G/
                                UK/
                                SR/
                                3U/
                                5L/
                                39/
                                P1/
                                VD/
                                6Q/
                                0H/
                                Z1/
                                UY/
                                U5/
                                99/
                                9U/
                                YR/
                                3G/
                                52/
                                VV/
                                9R/
                                U2/
                                SG/
                                Z6/
                                ZZ/
                                0O/
                                6V/
                                VQ/
                                PH/
                                55/
                                5Y/
                                YU/
                                Y9/
                                VX/
                                5P/
                                Y0/
                                97/
                                UW/
                                SN/
                                63/
                                0F/
                                Y7/
                                5W/
                                3N/
                                V3/
                                0A/
                                6X/
                                64/
                                Z8/
                                ZT/
                                SI/
                                UP/
                                90/
                                ML/
                                K9/
                                H6/
                                NC/
                                G2/
                                AG/
                                BO/
                                MK/
                                G5/
                                ND/
                                H1/
                                GP/
                                AI/
                                H8/
                                HT/
                                NM/
                                BF/
                                D3/
                                MB/
                                K7/
                                NJ/
                                HS/
                                GW/
                                K0/
                                ME/
                                D4/
                                DX/
                                BA/
                                NX/
                                HA/
                                N4/
                                GE/
                                KN/
                                MW/
                                BS/
                                A7/
                                N3/
                                BT/
                                DM/
                                B8/
                                KI/
                                B1/
                                DD/
                                MY/
                                AR/
                                GK/
                                NV/
                                KG/
                                M2/
                                BZ/
                                DC/
                                HH/
                                NQ/
                                GL/
                                AU/
                                AO/
                                GV/
                                NK/
                                DY/
                                MD/
                                K1/
                                HU/
                                NL/
                                H9/
                                GQ/
                                AH/
                                K6/
                                MC/
                                BG/
                                KS/
                                MJ/
                                H0/
                                G4/
                                AA/
                                GX/
                                BI/
                                DP/
                                K8/
                                MM/
                                KT/
                                AF/
                                G3/
                                NB/
                                H7/
                                B7/
                                M3/
                                GM/
                                AT/
                                A8/
                                NP/
                                KA/
                                DE/
                                NW/
                                HN/
                                HG/
                                N2/
                                GC/
                                AZ/
                                A6/
                                MQ/
                                KH/
                                DL/
                                A1/
                                N5/
                                NY/
                                DK/
                                BR/
                                MV/
                                FI/
                                O8/
                                OT/
                                EF/
                                C3/
                                L7/
                                IJ/
                                OS/
                                FN/
                                JE/
                                C4/
                                CX/
                                JL/
                                LU/
                                L9/
                                CQ/
                                IC/
                                CV/
                                EO/
                                LR/
                                O1/
                                E1/
                                J5/
                                JY/
                                FR/
                                IV/
                                OO/
                                LG/
                                J2/
                                EZ/
                                CC/
                                E6/
                                OH/
                                IQ/
                                FU/
                                IX/
                                OA/
                                F0/
                                LN/
                                JW/
                                CJ/
                                ES/
                                F7/
                                I3/
                                OF/
                                ET/
                                CM/
                                JP/
                                LI/
                                LS/
                                CW/
                                EN/
                                O0/
                                IE/
                                FA/
                                EI/
                                CP/
                                L8/
                                JM/
                                LT/
                                FF/
                                IB/
                                O7/
                                FO/
                                IK/
                                OR/
                                CY/
                                C5/
                                L1/
                                OU/
                                IL/
                                O9/
                                L6/
                                LZ/
                                C2/
                                EG/
                                OG/
                                I2/
                                F6/
                                LH/
                                E9/
                                EU/
                                I5/
                                CK/
                                ER/
                                LO/
                                JV/
                                E7/
                                CB/
                                J3/
                                LF/
                                FT/
                                F8/
                                OI/
                                IP/
                                LA/
                                J4/
                                CE/
                                IW/
                                ON/
                                FS/
                                WR/
                                QK/
                                1L/
                                79/
                                T1/
                                RD/
                                W9/
                                QL/
                                2D/
                                XQ/
                                8V/
                                TZ/
                                T6/
                                7R/
                                83/
                                RJ/
                                TS/
                                1B/
                                77/
                                W0/
                                48/
                                4T/
                                2M/
                                XX/
                                X4/
                                70/
                                1E/
                                TT/
                                RM/
                                T8/
                                84/
                                8X/
                                X3/
                                4S/
                                W7/
                                QB/
                                7N/
                                1W/
                                8J/
                                TF/
                                24/
                                XM/
                                QP/
                                WI/
                                R4/
                                RX/
                                TA/
                                8M/
                                1P/
                                7I/
                                WN/
                                QW/
                                XJ/
                                4F/
                                Q2/
                                XC/
                                2V/
                                RQ/
                                8D/
                                15/
                                1Y/
                                4H/
                                2Q/
                                XD/
                                QY/
                                Q5/
                                7G/
                                12/
                                8C/
                                RV/
                                T9/
                                TU/
                                RL/
                                8Y/
                                85/
                                1D/
                                QC/
                                WZ/
                                W6/
                                X2/
                                2K/
                                76/
                                1C/
                                7Z/
                                82/
                                TR/
                                4U/
                                2L/
                                49/
                                X5/
                                W1/
                                QD/
                                40/
                                XP/
                                QM/
                                WT/
                                7S/
                                1J/
                                T7/
                                WS/
                                XW/
                                2B/
                                RE/
                                T0/
                                8P/
                                78/
                                1M/
                                Q4/
                                WA/
                                QX/
                                4I/
                                2P/
                                XE/
                                8B/
                                RW/
                                13/
                                4N/
                                Q3/
                                7A/
                                1X/
                                TI/
                                RP/
                                8E/
                                1Q/
                                7H/
                                RY/
                                8L/
                                XK/
                                4G/
                                WO/
                                QV/
                                R2/
                                TG/
                                7O/
                                QQ/
                                WH/
                                XL/
                            units/
                Modules/
    ClarityTodo/
        ClarityTodoApp.swift
        ViewModels/
            TodoViewModel.swift
        Models/
            TodoItem.swift
            SubtaskItem.swift
        Utilities/
        Components/
        Views/
            ContentView.swift
            Sidebar/
                SidebarView.swift
            Detail/
                DetailView.swift
            MainList/
                MainListView.swift
                TodoCardView.swift
                CalendarView.swift
        Services/
            RichTextService.swift
            DataService.swift
    dist/
        Clarity Todo.app/
            Contents/
                _CodeSignature/
                MacOS/
                Resources/
    ClarityTodo.xcodeproj/
```

## 2. 源代码详情

### 文件位置: `Package.swift`
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClarityTodo",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "ClarityTodo",
            path: "ClarityTodo"
        )
    ]
)

```

---

### 文件位置: `ClarityTodo/ClarityTodoApp.swift`
```swift
import SwiftUI
import SwiftData

@main
struct ClarityTodoApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .modelContainer(for: [TodoItem.self, SubtaskItem.self])
                .frame(minWidth: 960, minHeight: 640)
                .preferredColorScheme(appState.colorScheme)
        }
        .windowStyle(.titleBar)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("新建待办") {
                    appState.createNewTodo()
                }
                .keyboardShortcut("n", modifiers: .command)
            }
            CommandGroup(replacing: .undoRedo) {
                Button("撤销") {
                    appState.undo()
                }
                .keyboardShortcut("z", modifiers: .command)
                Button("重做") {
                    appState.redo()
                }
                .keyboardShortcut("z", modifiers: [.command, .shift])
            }
            CommandGroup(replacing: .textFormatting) {
                Button("粗体") {
                    NotificationCenter.default.post(name: .boldCommand, object: nil)
                }
                .keyboardShortcut("b", modifiers: .command)
                Button("斜体") {
                    NotificationCenter.default.post(name: .italicCommand, object: nil)
                }
                .keyboardShortcut("i", modifiers: .command)
                Button("下划线") {
                    NotificationCenter.default.post(name: .underlineCommand, object: nil)
                }
                .keyboardShortcut("u", modifiers: .command)
            }
        }
    }
}

extension Notification.Name {
    static let boldCommand = Notification.Name("boldCommand")
    static let italicCommand = Notification.Name("italicCommand")
    static let underlineCommand = Notification.Name("underlineCommand")
    static let deleteTodoCommand = Notification.Name("deleteTodoCommand")
}

class AppState: ObservableObject {
    @Published var colorScheme: ColorScheme? = nil
    @Published var selectedSidebarItem: SidebarItem = .today
    @Published var selectedTodo: TodoItem? = nil
    @Published var filterDate: Date? = nil
    @Published var searchText: String = ""
    @Published var isCalendarOpen: Bool = false

    func createNewTodo() {
        let context = ModelContext(
            try! ModelContainer(for: TodoItem.self, SubtaskItem.self)
        )
        let newTodo = TodoItem(
            title: "",
            dueDate: filterDate,
            isCompleted: false
        )
        context.insert(newTodo)
        selectedTodo = newTodo
    }

    func undo() {
        NotificationCenter.default.post(name: .undoCommand, object: nil)
    }

    func redo() {
        NotificationCenter.default.post(name: .redoCommand, object: nil)
    }
}

extension Notification.Name {
    static let undoCommand = Notification.Name("undoCommand")
    static let redoCommand = Notification.Name("redoCommand")
}

enum SidebarItem: String, CaseIterable, Identifiable {
    case today = "今天"
    case upcoming = "接下来"
    case calendar = "日历"
    case completed = "已完成"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .today: return "sun.max.fill"
        case .upcoming: return "calendar.badge.clock"
        case .calendar: return "calendar"
        case .completed: return "checkmark.circle.fill"
        }
    }
}

```

---

### 文件位置: `ClarityTodo/ViewModels/TodoViewModel.swift`
```swift
import SwiftUI
import SwiftData
import Combine

@MainActor
class TodoViewModel: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var selectedTodo: TodoItem? = nil
    @Published var searchText: String = ""
    @Published var filterCompleted: Bool = false
    @Published var isLoading: Bool = false

    private var modelContext: ModelContext?
    private var cancellables = Set<AnyCancellable>()

    init() {
        NotificationCenter.default.publisher(for: .newTodoCommand)
            .sink { [weak self] _ in
                self?.createNewTodo()
            }
            .store(in: &cancellables)
    }

    func setup(with context: ModelContext) {
        self.modelContext = context
        loadTodos()
    }

    func loadTodos() {
        guard let context = modelContext else { return }
        isLoading = true
        let descriptor = FetchDescriptor<TodoItem>(
            sortBy: [SortDescriptor(\.sortOrder), SortDescriptor(\.createdAt)]
        )
        do {
            todos = try context.fetch(descriptor)
        } catch {
            print("Failed to load todos: \(error)")
        }
        isLoading = false
    }

    func createNewTodo(date: Date? = nil) {
        guard let context = modelContext else { return }
        let newTodo = TodoItem(
            title: "",
            dueDate: date,
            isCompleted: false
        )
        context.insert(newTodo)
        try? context.save()
        loadTodos()
        selectedTodo = newTodo
    }

    func saveTodo(_ todo: TodoItem) {
        guard let context = modelContext else { return }
        todo.updateTimestamp()
        try? context.save()
        loadTodos()
    }

    func deleteTodo(_ todo: TodoItem) {
        guard let context = modelContext else { return }
        context.delete(todo)
        if selectedTodo?.id == todo.id {
            selectedTodo = nil
        }
        try? context.save()
        loadTodos()
    }

    func toggleTodoCompletion(_ todo: TodoItem) {
        todo.isCompleted.toggle()
        saveTodo(todo)
    }

    func addSubtask(to todo: TodoItem, title: String) {
        guard let context = modelContext else { return }
        let subtask = SubtaskItem(
            title: title,
            sortOrder: todo.subtasks.count
        )
        todo.subtasks.append(subtask)
        todo.updateTimestamp()
        try? context.save()
        loadTodos()
    }

    func toggleSubtaskCompletion(_ subtask: SubtaskItem) {
        subtask.isCompleted.toggle()
        subtask.updateTimestamp()
        saveSubtask(subtask)
    }

    func deleteSubtask(_ subtask: SubtaskItem) {
        guard let context = modelContext else { return }
        context.delete(subtask)
        try? context.save()
        loadTodos()
    }

    private func saveSubtask(_ subtask: SubtaskItem) {
        guard let context = modelContext else { return }
        try? context.save()
        loadTodos()
    }

    func filteredTodos(for sidebarItem: SidebarItem) -> [TodoItem] {
        var result = todos

        // Apply search filter
        if !searchText.isEmpty {
            result = result.filter { todo in
                todo.title.localizedCaseInsensitiveContains(searchText) ||
                todo.plainTextDescription.localizedCaseInsensitiveContains(searchText)
            }
        }

        // Apply sidebar filter
        switch sidebarItem {
        case .today:
            let calendar = Calendar.current
            result = result.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInToday(dueDate) && !todo.isCompleted
            }
        case .upcoming:
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            result = result.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.startOfDay(for: dueDate) >= today && !todo.isCompleted
            }
            result.sort { a, b in
                (a.dueDate ?? .distantFuture) < (b.dueDate ?? .distantFuture)
            }
        case .calendar:
            // Filter is handled separately when a date is selected
            break
        case .completed:
            result = result.filter { $0.isCompleted }
        }

        return result
    }

    func todosForDate(_ date: Date) -> [TodoItem] {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }
}

extension Notification.Name {
    static let newTodoCommand = Notification.Name("newTodoCommand")
}

```

---

### 文件位置: `ClarityTodo/Models/TodoItem.swift`
```swift
import SwiftData
import Foundation

@Model
final class TodoItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var richTextDescription: Data?
    var plainTextDescription: String
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
    var isCompleted: Bool
    var colorTag: String
    @Relationship(deleteRule: .cascade) var subtasks: [SubtaskItem] = []
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        title: String,
        richTextDescription: Data? = nil,
        plainTextDescription: String = "",
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        dueDate: Date? = nil,
        isCompleted: Bool = false,
        colorTag: String = "blue",
        subtasks: [SubtaskItem] = [],
        sortOrder: Int = 0
    ) {
        self.id = id
        self.title = title
        self.richTextDescription = richTextDescription
        self.plainTextDescription = plainTextDescription
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.colorTag = colorTag
        self.subtasks = subtasks
        self.sortOrder = sortOrder
    }

    func updateTimestamp() {
        updatedAt = Date()
    }
}

extension TodoItem {
    var dueDateString: String? {
        guard let date = dueDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

let colorTags: [(name: String, color: String)] = [
    ("Red", "red"),
    ("Orange", "orange"),
    ("Yellow", "yellow"),
    ("Green", "green"),
    ("Blue", "blue"),
    ("Purple", "purple"),
    ("Pink", "pink"),
    ("Gray", "gray")
]

extension String {
    var displayColor: String {
        switch self {
        case "red": return "#FF3B30"
        case "orange": return "#FF9500"
        case "yellow": return "#FFCC00"
        case "green": return "#34C759"
        case "blue": return "#007AFF"
        case "purple": return "#AF52DE"
        case "pink": return "#FF2D55"
        case "gray": return "#8E8E93"
        default: return "#007AFF"
        }
    }
}

```

---

### 文件位置: `ClarityTodo/Models/SubtaskItem.swift`
```swift
import SwiftData
import Foundation

@Model
final class SubtaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date
    var sortOrder: Int
    var parentTodo: TodoItem?

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sortOrder: Int = 0,
        parentTodo: TodoItem? = nil
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sortOrder = sortOrder
        self.parentTodo = parentTodo
    }

    func updateTimestamp() {
        updatedAt = Date()
    }
}

```

---

### 文件位置: `ClarityTodo/Views/ContentView.swift`
```swift
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

```

---

### 文件位置: `ClarityTodo/Views/Sidebar/SidebarView.swift`
```swift
import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        VStack(spacing: 0) {
            // 应用图标和标题
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

            // 搜索框
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                    .font(.caption)
                TextField("搜索待办...", text: $appState.searchText)
                    .textFieldStyle(.plain)
                    .font(.body)
            }
            .padding(8)
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            // 侧边栏列表
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

```

---

### 文件位置: `ClarityTodo/Views/Detail/DetailView.swift`
```swift
import SwiftUI
import AppKit

struct DetailView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        Group {
            if let todo = appState.selectedTodo {
                TodoDetailContent(todo: todo)
            } else {
                DetailEmptyState()
            }
        }
        .frame(minWidth: 300)
    }
}

struct DetailEmptyState: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 36))
                .foregroundStyle(.quaternary)
            Text("选择一个待办来编辑")
                .font(.body)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}

struct TodoDetailContent: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var title: String = ""
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false
    @State private var selectedColor: String = "blue"
    @State private var attributedDescription: NSAttributedString = NSAttributedString(string: "")
    @State private var showDeleteAlert = false
    @State private var showColorPicker = false

    let todo: TodoItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // 标题
                TextField("待办标题", text: $title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        todo.title = title
                        viewModel.saveTodo(todo)
                    }

                // 元数据行
                HStack(spacing: 12) {
                    // 截止日期开关
                    Button(action: {
                        hasDueDate.toggle()
                        if hasDueDate {
                            todo.dueDate = dueDate
                        } else {
                            todo.dueDate = nil
                        }
                        viewModel.saveTodo(todo)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: hasDueDate ? "calendar.circle.fill" : "calendar.circle")
                            Text(hasDueDate ? "截止 \(formatDate(dueDate))" : "添加截止日期")
                                .font(.caption)
                        }
                        .foregroundStyle(hasDueDate ? .blue : .secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)

                    if hasDueDate {
                        DatePicker("", selection: $dueDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .onChange(of: dueDate) { _, newDate in
                                todo.dueDate = newDate
                                viewModel.saveTodo(todo)
                            }
                    }

                    Spacer()

                    // 颜色选择
                    Button(action: { showColorPicker.toggle() }) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(colorFromTag(selectedColor))
                                .frame(width: 10, height: 10)
                            Text("颜色")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.quaternary.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: $showColorPicker) {
                        ColorPickerView(selectedColor: $selectedColor) { newColor in
                            todo.colorTag = newColor
                            viewModel.saveTodo(todo)
                        }
                        .padding(8)
                    }
                }

                Divider()

                // 子任务列表
                VStack(alignment: .leading, spacing: 4) {
                    Text("子任务")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    ForEach(todo.subtasks.sorted(by: { $0.sortOrder < $1.sortOrder })) { subtask in
                        SubtaskRow(subtask: subtask)
                    }

                    Button(action: { addSubtask() }) {
                        HStack(spacing: 6) {
                            Image(systemName: "plus.circle")
                                .font(.caption)
                            Text("添加子任务")
                                .font(.caption)
                        }
                        .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }

                // 富文本描述
                VStack(alignment: .leading, spacing: 6) {
                    Text("详细描述")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    RichTextEditor(attributedString: $attributedDescription)
                        .frame(minHeight: 120, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                        )
                }

                // 删除按钮
                Button(action: { showDeleteAlert = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                        Text("删除待办")
                    }
                    .font(.body)
                    .foregroundStyle(.red)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
            .padding(20)
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .onAppear {
            loadTodoData()
        }
        .onChange(of: todo) { _, _ in
            loadTodoData()
        }
        .onChange(of: attributedDescription) { _, newValue in
            saveRichText(newValue)
        }
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                viewModel.deleteTodo(todo)
            }
        } message: {
            Text("确定要删除「\(todo.title)」吗？")
        }
    }

    private func loadTodoData() {
        title = todo.title
        hasDueDate = todo.dueDate != nil
        dueDate = todo.dueDate ?? Date()
        selectedColor = todo.colorTag
        attributedDescription = DataService.shared.loadRichText(from: todo)
    }

    private func saveRichText(_ attrString: NSAttributedString) {
        DataService.shared.saveRichText(attrString, to: todo)
        viewModel.saveTodo(todo)
    }

    private func addSubtask() {
        viewModel.addSubtask(to: todo, title: "新子任务")
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        default: return .blue
        }
    }
}

struct SubtaskRow: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var title: String = ""
    let subtask: SubtaskItem

    var body: some View {
        HStack(spacing: 8) {
            // 完成勾选框
            Button(action: {
                viewModel.toggleSubtaskCompletion(subtask)
            }) {
                Image(systemName: subtask.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(subtask.isCompleted ? .green : .secondary)
                    .font(.system(size: 14))
            }
            .buttonStyle(.plain)

            // 标题
            TextField("子任务", text: $title)
                .textFieldStyle(.plain)
                .font(.callout)
                .strikethrough(subtask.isCompleted)
                .foregroundStyle(subtask.isCompleted ? .secondary : .primary)
                .onSubmit {
                    subtask.title = title
                    subtask.updateTimestamp()
                    viewModel.loadTodos()
                }

            Spacer()

            // 删除
            Button(action: { viewModel.deleteSubtask(subtask) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary.opacity(0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, 4)
        .onAppear {
            title = subtask.title
        }
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: String
    let onSelect: (String) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach(colorTags, id: \.name) { tag in
                Circle()
                    .fill(colorFromTag(tag.color))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle()
                            .stroke(tag.color == selectedColor ? Color.primary : Color.clear, lineWidth: 2)
                    )
                    .onTapGesture {
                        selectedColor = tag.color
                        onSelect(tag.color)
                    }
            }
        }
    }

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        default: return .blue
        }
    }
}

```

---

### 文件位置: `ClarityTodo/Views/MainList/MainListView.swift`
```swift
import SwiftUI

struct MainListView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var showDeleteAlert = false
    @State private var todoToDelete: TodoItem? = nil

    var displayedTodos: [TodoItem] {
        // 日历模式下显示选中日期的待办
        if appState.selectedSidebarItem == .calendar, let date = appState.filterDate {
            return viewModel.todosForDate(date)
        }
        return viewModel.filteredTodos(for: appState.selectedSidebarItem)
    }

    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题
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
                .help("切换日历")

                Button(action: {
                    viewModel.createNewTodo(date: appState.filterDate)
                }) {
                    Image(systemName: "plus")
                        .font(.body)
                        .fontWeight(.semibold)
                }
                .buttonStyle(.plain)
                .help("新建待办 (Command+N)")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // 日历（点击后展开）
            if appState.isCalendarOpen {
                CalendarView()
                    .environmentObject(appState)
                    .environmentObject(viewModel)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            Divider()

            // 待办列表
            if displayedTodos.isEmpty {
                EmptyStateView()
            } else {
                List(selection: $appState.selectedTodo) {
                    ForEach(displayedTodos) { todo in
                        TodoCardView(todo: todo)
                            .tag(todo)
                            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .contextMenu {
                                Button(todo.isCompleted ? "标记为未完成" : "标记为已完成") {
                                    viewModel.toggleTodoCompletion(todo)
                                }
                                Divider()
                                Button("复制标题") {
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(todo.title, forType: .string)
                                }
                                Button("删除", role: .destructive) {
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
        .alert("删除待办", isPresented: $showDeleteAlert) {
            Button("取消", role: .cancel) {}
            Button("删除", role: .destructive) {
                if let todo = todoToDelete {
                    viewModel.deleteTodo(todo)
                }
            }
        } message: {
            Text("确定要删除「\(todoToDelete?.title ?? "")」吗？此操作不可撤销。")
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "M月d日 EEEE"
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
            Text("还没有待办")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            Text("点击 + 按钮或按 Command+N\n 创建你的第一个待办")
                .font(.callout)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

```

---

### 文件位置: `ClarityTodo/Views/MainList/TodoCardView.swift`
```swift
import SwiftUI

struct TodoCardView: View {
    let todo: TodoItem
    @EnvironmentObject var viewModel: TodoViewModel

    var body: some View {
        HStack(spacing: 10) {
            // 完成状态勾选框
            Button(action: { viewModel.toggleTodoCompletion(todo) }) {
                Circle()
                    .strokeBorder(todo.isCompleted ? Color.green : colorFromTag(todo.colorTag), lineWidth: 1.5)
                    .frame(width: 18, height: 18)
                    .overlay {
                        if todo.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.green)
                        }
                    }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                // 标题
                Text(todo.title.isEmpty ? "新待办" : todo.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .strikethrough(todo.isCompleted)
                    .foregroundStyle(todo.isCompleted ? .secondary : .primary)

                // 子任务进度
                if !todo.subtasks.isEmpty {
                    HStack(spacing: 4) {
                        let completed = todo.subtasks.filter { $0.isCompleted }.count
                        Text("\(completed)/\(todo.subtasks.count)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }

                // 截止日期
                if let dueDate = todo.dueDate {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(formatDueDate(dueDate))
                            .font(.caption2)
                    }
                    .foregroundStyle(isDueDatePast(dueDate) && !todo.isCompleted ? .red : .secondary)
                }
            }

            Spacer()

            // 颜色标签
            Circle()
                .fill(colorFromTag(todo.colorTag))
                .frame(width: 8, height: 8)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(nsColor: .controlBackgroundColor))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
    }

    private func colorFromTag(_ tag: String) -> Color {
        switch tag {
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        default: return .blue
        }
    }

    private func formatDueDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        if calendar.isDateInToday(date) {
            return "今天"
        } else if calendar.isDateInTomorrow(date) {
            return "明天"
        } else if calendar.isDateInYesterday(date) {
            return "昨天"
        } else {
            formatter.dateFormat = "M月d日"
            return formatter.string(from: date)
        }
    }

    private func isDueDatePast(_ date: Date) -> Bool {
        return date < Calendar.current.startOfDay(for: Date())
    }
}

```

---

### 文件位置: `ClarityTodo/Views/MainList/CalendarView.swift`
```swift
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date = Date()

    private let calendar = Calendar.current
    private let weekDays = ["日", "一", "二", "三", "四", "五", "六"]

    var body: some View {
        VStack(spacing: 8) {
            // 月份切换
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

            // 星期行
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // 日期网格
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
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: date)
    }

    private func daysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeekday = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start)
        else { return [] }

        var days: [Date?] = []
        let weekdayOffset = calendar.component(.weekday, from: monthInterval.start) - 1
        // 补齐月初前的空白
        for _ in 0..<weekdayOffset {
            days.append(nil)
        }

        // 添加当月所有日期
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

```

---

### 文件位置: `ClarityTodo/Services/RichTextService.swift`
```swift
import AppKit
import SwiftUI

/// Wraps an NSTextView for use in SwiftUI via NSViewRepresentable.
/// Provides rich text editing capabilities including bold, italic, underline,
/// strikethrough, font color, background color, bullet lists, and numbered lists.
struct RichTextEditor: NSViewRepresentable {
    @Binding var attributedString: NSAttributedString
    var isEditable: Bool = true

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = true
        scrollView.backgroundColor = .clear

        let textView = CustomTextView()
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = true
        textView.importsGraphics = false
        textView.allowsImageEditing = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.usesAdaptiveColorMappingForDarkAppearance = true
        textView.textContainerInset = NSSize(width: 8, height: 8)
        textView.delegate = context.coordinator
        textView.textStorage?.setAttributedString(attributedString)

        // Set default font
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.textColor = .labelColor
        textView.drawsBackground = false

        // Enable undo/redo
        textView.allowsUndo = true

        // Enable bullet lists and numbered lists via NSTextList
        textView.enabledTextCheckingTypes = 0

        scrollView.documentView = textView



        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let textView = nsView.documentView as? NSTextView else { return }
        if textView.attributedString() != attributedString {
            textView.textStorage?.setAttributedString(attributedString)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            parent.attributedString = textView.attributedString()
        }
    }
}

/// Custom NSTextView with keyboard shortcut handling for rich text formatting
class CustomTextView: NSTextView {
    override func keyDown(with event: NSEvent) {
        // Let standard key bindings process first
        super.keyDown(with: event)
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == .keyDown {
            // Handle formatting shortcuts
            if event.modifierFlags.contains(.command) {
                switch event.charactersIgnoringModifiers?.lowercased() {
                case "b":
                    toggleBold()
                    return true
                case "i":
                    toggleItalic()
                    return true
                case "u":
                    toggleUnderline()
                    return true
                default:
                    break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }

    // MARK: - Rich Text Formatting Actions

    func toggleBold() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentFont = font ?? NSFont.systemFont(ofSize: 14)
        let isBold = currentFont.fontDescriptor.symbolicTraits.contains(.bold)
        let newFont: NSFont
        if isBold {
            newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: .boldFontMask)
        } else {
            newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .boldFontMask)
        }
        textStorage.addAttribute(.font, value: newFont, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleItalic() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentFont = font ?? NSFont.systemFont(ofSize: 14)
        let isItalic = currentFont.fontDescriptor.symbolicTraits.contains(.italic)
        let newFont: NSFont
        if isItalic {
            newFont = NSFontManager.shared.convert(currentFont, toNotHaveTrait: .italicFontMask)
        } else {
            newFont = NSFontManager.shared.convert(currentFont, toHaveTrait: .italicFontMask)
        }
        textStorage.addAttribute(.font, value: newFont, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleUnderline() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentUnderline = textStorage.attribute(.underlineStyle, at: selectedRange().location, effectiveRange: nil) as? Int ?? 0
        let newValue: Int = currentUnderline == 0 ? NSUnderlineStyle.single.rawValue : 0
        textStorage.addAttribute(.underlineStyle, value: newValue, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func toggleStrikethrough() {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        let currentStrike = textStorage.attribute(.strikethroughStyle, at: selectedRange().location, effectiveRange: nil) as? Int ?? 0
        let newValue: Int = currentStrike == 0 ? NSUnderlineStyle.single.rawValue : 0
        textStorage.addAttribute(.strikethroughStyle, value: newValue, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func setFontColor(_ color: NSColor) {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        textStorage.addAttribute(.foregroundColor, value: color, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func setBackgroundColor(_ color: NSColor) {
        guard let textStorage = textStorage, selectedRange().length > 0 else { return }
        textStorage.addAttribute(.backgroundColor, value: color, range: selectedRange())
        shouldChangeText(in: selectedRange(), replacementString: nil)
        didChangeText()
    }

    func insertBulletList() {
        insertText("• ", replacementRange: selectedRange())
    }

    func insertNumberedList() {
        let paragraphRange = textStorage?.mutableString.paragraphRange(for: selectedRange()) ?? selectedRange()
        let lineNumber = textStorage?.mutableString
            .substring(with: NSRange(location: 0, length: paragraphRange.location))
            .components(separatedBy: "\n").count ?? 1
        insertText("\(lineNumber). ", replacementRange: selectedRange())
    }

    /// Convert attributed text to RTF data for persistence
    func attributedStringToData() -> Data? {
        guard let textStorage = textStorage else { return nil }
        let range = NSRange(location: 0, length: textStorage.length)
        let data = textStorage.rtf(from: range)
        return data
    }

    /// Load attributed text from RTF data
    func loadFromData(_ data: Data) {
        guard let textStorage = textStorage else { return }
        do {
            let attrString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
            textStorage.setAttributedString(attrString)
        } catch {
            print("Failed to load RTF data: \(error)")
        }
    }
}

```

---

### 文件位置: `ClarityTodo/Services/DataService.swift`
```swift
import SwiftData
import Foundation

/// Central data access service for todo operations
class DataService {
    static let shared = DataService()

    private init() {}

    /// Save RTF attributed string data to the todo item
    func saveRichText(_ attributedString: NSAttributedString, to todo: TodoItem) {
        let range = NSRange(location: 0, length: attributedString.length)
        if let data = try? attributedString.rtf(from: range) {
            todo.richTextDescription = data
            todo.plainTextDescription = attributedString.string
            todo.updateTimestamp()
        }
    }

    /// Load RTF attributed string from the todo item
    func loadRichText(from todo: TodoItem) -> NSAttributedString {
        guard let data = todo.richTextDescription else {
            return NSAttributedString(string: "")
        }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.rtf],
                documentAttributes: nil
            )
        } catch {
            print("Failed to load RTF: \(error)")
            return NSAttributedString(string: todo.plainTextDescription)
        }
    }

    /// Check if a todo item exists for a given date
    func hasTodos(for date: Date, in todos: [TodoItem]) -> Bool {
        let calendar = Calendar.current
        return todos.contains { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

    /// Count todos for a given date
    func todoCount(for date: Date, in todos: [TodoItem]) -> Int {
        let calendar = Calendar.current
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }.count
    }
}

```

---

