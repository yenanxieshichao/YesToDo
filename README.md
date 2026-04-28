<p align="center">
  <img src="AppIcon.png" width="128" height="128" alt="Yes To Do" />
</p>

<h1 align="center">Yes To Do</h1>

<p align="center">
  <strong>macOS 原生每日待办 · 极简 · 高效 · 精致</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS%2014%2B-blue?logo=apple" alt="Platform" />
  <img src="https://img.shields.io/badge/language-Swift%205.9-FA7343?logo=swift" alt="Swift" />
  <img src="https://img.shields.io/badge/framework-SwiftUI%20%2B%20SwiftData-007AFF" alt="Framework" />
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License" />
</p>

---

## ✨ 特性

- 📅 **按日管理** — 每天独立待办清单，日历快速切换
- ✅ **子任务** — 大任务拆分子任务，逐项完成
- 📝 **富文本描述** — 粗体 / 斜体 / 下划线，⌘B ⌘I ⌘U 快捷键
- 🏷️ **8 色标签** — 红橙黄绿蓝紫粉灰，视觉区分
- 🔄 **智能继承** — 一键把昨天未完成的待办带到今天（仅复制、不删除历史）
- 📊 **完成率统计** — 实时显示今日待办数 / 已完成 / 完成率
- 🎚️ **全局字体缩放** — 小字大字随心调
- ⌨️ **键盘驱动** — ⌘N 新建、⌘Z 撤销、⇧⌘Z 重做、双击编辑标题
- 🌓 **自动深色模式** — 跟随系统

---

## 📸 截图

<img width="973" alt="Yes To Do Screenshot" src="https://github.com/user-attachments/assets/8d6c6fd8-ab9e-43ea-96ac-024502bdc57d" />

---

## 📦 安装

### 直接下载

从 [Releases](../../releases) 下载 `Yes To Do.dmg`，拖入 Applications 即可。

### 从源码编译

```bash
git clone https://github.com/yenanxieshichao/YesToDo.git
cd YesToDo
swift build
```

---

## 🏗️ 技术栈

| 层级 | 技术 |
|------|------|
| UI | SwiftUI |
| 数据持久化 | SwiftData |
| 富文本 | AppKit NSTextView (NSViewRepresentable) |
| 构建 | Swift Package Manager |
| 最低系统 | macOS 14.0 |

### 项目结构

```
ClarityTodo/
├── Models/
│   ├── TodoItem.swift          # 主待办模型
│   └── SubtaskItem.swift       # 子任务模型
├── Views/
│   ├── ContentView.swift        # 视图入口
│   └── MainList/
│       ├── MainListView.swift   # 主列表 + 继承按钮 + 浮动添加栏
│       ├── TodoCardView.swift   # 待办卡片 + 子任务交互
│       └── CalendarView.swift   # 日历选择器
├── ViewModels/
│   └── TodoViewModel.swift      # MVVM 核心逻辑
├── Services/
│   ├── DataService.swift        # RTF 数据存取
│   └── RichTextService.swift    # NSTextView 封装
├── Components/
│   └── PremiumControls.swift    # 可复用 UI 组件库
└── Utilities/
    └── DesignSystem.swift       # 设计令牌（颜色/字体/阴影/圆角）
```

---

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `⌘N` | 新建待办 |
| `⌘Z` | 撤销 |
| `⇧⌘Z` | 重做 |
| `⌘B` | 粗体 |
| `⌘I` | 斜体 |
| `⌘U` | 下划线 |
| 双击标题 | 编辑 |
| Esc | 取消编辑 |

---

## 🚀 开发计划

- [ ] iCloud 同步
- [ ] 通知提醒
- [ ] 导出 Markdown
- [ ] 标签筛选
- [ ] 搜索

---

## 📄 许可

MIT License — 自由使用、修改、分发。

---

<p align="center">
  <sub>Built with ❤️ using SwiftUI + SwiftData</sub>
</p>
