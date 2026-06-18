# YesToDo 项目说明

YesToDo 是一个原生 macOS 每日待办应用。当前版本的产品边界刻意保持小：一张干净的每日清单、快速输入、子任务、完成状态、日期切换，以及把未完成事项继承到今天。

仓库地址：<https://github.com/yenanxieshichao/YesToDo>

## 当前产品范围

保留：

- 按日期管理待办
- 主界面快速创建待办
- 待办和子任务完成状态
- 待办和子任务内联编辑
- 选中行与删除命令
- 紧凑日历日期选择
- 最近历史未完成事项继承
- SwiftData 本地持久化

暂不做：

- 账号系统
- 云同步
- 多项目/多空间规划
- 富文本笔记
- 重型数据仪表盘
- 应用内营销落地页

## 项目结构

```text
ClarityTodo/
├── ClarityTodoApp.swift          App 入口、菜单命令、AppState、SwiftData 容器
├── Components/
│   └── Controls.swift            小型复用控件：统计 chip、按钮、勾选框
├── Models/
│   ├── SubtaskItem.swift         SwiftData 子任务模型
│   └── TodoItem.swift            SwiftData 待办模型
├── Utilities/
│   └── DesignSystem.swift        色彩、圆角和基础 View modifier
├── ViewModels/
│   └── TodoViewModel.swift       数据操作和继承未完成逻辑
└── Views/
    ├── ContentView.swift         环境对象与 SwiftData 查询接线
    └── MainList/
        ├── CalendarView.swift    紧凑日期选择器
        ├── MainListView.swift    每日待办主流程
        └── TodoCardView.swift    待办行与子任务行
```

## 数据说明

`TodoItem` 中仍保留了旧版本的富文本和颜色字段。它们不再出现在当前用户体验中，但暂时保留在模型里，避免对已有 SwiftData 本地存储做不必要的破坏性迁移。

“继承未完成”会找到最近一个存在未完成事项的历史日期，把符合条件的事项复制到今天。原事项仍留在历史日期，并记录 `carriedOverDate`，避免重复继承。

## 构建与验证

```bash
swift build
xcodebuild -project ClarityTodo.xcodeproj -target ClarityTodo -configuration Debug build
```

产物位置：

```text
build/Debug/YesToDo.app
```

图标资源验证：

```bash
find build/Debug/YesToDo.app/Contents/Resources -maxdepth 1 -name "AppIcon.icns"
```

## 发布卫生

- `build/`、`.build/`、`dist/`、`.DS_Store` 不进入 git。
- `AppIcon.icns` 和 `AppIcon.png` 需要进入 git：前者用于 app bundle，后者用于 README 首屏。
- 每次推送前至少运行 `swift build` 和 Xcode Debug 构建。
