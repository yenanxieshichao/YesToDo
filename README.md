<div align="center">
  <img src="./AppIcon.png" width="108" height="108" alt="YesToDo app icon">

  <h1>YesToDo</h1>

  <p><strong>A calm native macOS todo app for the work that actually matters today.</strong></p>

  <p>
    <a href="https://github.com/yenanxieshichao/YesToDo">GitHub 仓库</a>
    ·
    <a href="./PROJECT.md">项目说明</a>
  </p>
</div>

## 产品定位

YesToDo 是一个原生 macOS 每日待办应用，使用 SwiftUI + SwiftData 构建。

它不做复杂项目管理、不做账号体系、不把你推进一堆看板和报表里。它只服务一个高频问题：今天真正需要推进的事是什么？

应用主界面保持克制：日期、输入框、进度统计、待办列表。你可以快速添加事项，把大事项拆成子任务，切换日期查看历史，并把最近一天未完成的事项继承到今天，同时保留原日期的记录。

## 核心能力

- 按日期组织每日待办
- 主界面快速添加任务
- 待办和子任务的完成、编辑、删除
- 轻量子任务拆解
- 最近未完成事项继承到今天
- SwiftData 本地持久化
- macOS 原生命令菜单与快捷键
- 原生 app 图标与本地 app bundle 构建

## 设计原则

| 原则 | 落地方式 |
| --- | --- |
| 保持主界面轻 | 只保留日期、输入、统计、清单。 |
| 尊重历史记录 | 继承未完成事项时复制到今天，原事项仍保留在历史日期。 |
| 操作尽量原生 | 使用 SwiftUI、macOS 菜单、本地存储，不引入账号依赖。 |
| 高级操作不抢注意力 | 编辑、删除、添加子任务只在 hover 或选中时出现。 |

## 构建要求

- macOS 14+
- Xcode 15 或更新版本
- Swift 5.9+

Swift Package Manager 构建：

```bash
swift build
```

构建 macOS app bundle：

```bash
xcodebuild -project ClarityTodo.xcodeproj -target ClarityTodo -configuration Debug build
```

构建产物：

```text
build/Debug/YesToDo.app
```

## 本地验收清单

1. 打开 `build/Debug/YesToDo.app`。
2. 确认 Dock 和窗口中的 app 图标显示为 YesToDo 图标。
3. 在输入框添加待办，确认回车和按钮都可用。
4. 勾选待办完成，确认统计同步变化。
5. 双击待办标题编辑，按 Return 保存。
6. hover 或选中待办，添加子任务。
7. 用日历切换到其他日期并添加待办。
8. 回到今天，存在历史未完成事项时使用“继承未完成”。
9. 退出后重新打开，确认数据仍然存在。

## 仓库

<https://github.com/yenanxieshichao/YesToDo>
