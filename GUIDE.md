# Cognitive OS 使用指南

[简体中文](GUIDE.md) | [繁體中文](docs/zh-tw/GUIDE.md) | [English](docs/en/GUIDE.md)

## 这是什么

Cognitive OS 是一个运行在 Claude Code 中的认知操作系统。它帮你：

- **记录** — 低门槛记录情绪、事件、想法
- **理解** — 自动分析原因、发现重复模式
- **提炼** — 把散落的经验浓缩成原因和方法
- **构建** — 组装可复用的个人规律和策略
- **行动** — 生成微行动、设计行为实验
- **进化** — 追踪成长轨迹，阶段性升级

整个系统以 **对话** 为核心交互方式，你只需要说话，AI 会判断你当前需要什么。

---

## 前置要求

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) 已安装并登录
- 推荐：[Obsidian](https://obsidian.md) 用于可视化浏览数据（非必需）

---

## 安装

### 方式零：AI 指令部署（最快）

直接把下面的指令复制粘贴到你的 AI 工具中，它会自动帮你完成所有操作：

**Claude Code 用户**，打开 Claude Code 后粘贴：

```
克隆 https://github.com/Tapmoay/Cognitive-OS 到我指定的目录，然后将 agents/ 目录下的所有 .md 文件复制到 ~/.claude/agents/，再运行 setup.ps1 初始化 vault。完成后告诉我可以用 /cognitive 开始。
```

**Codex 用户**，打开 Codex 后粘贴：

```
克隆 https://github.com/Tapmoay/Cognitive-OS 并部署：将 agents/ 目录下所有文件复制到 ~/.claude/agents/，然后运行安装脚本初始化 vault 目录结构。完成后确认。
```

### 方式一：一键安装

```powershell
# 克隆或下载项目后，在项目目录下运行
.\setup.ps1

# 或指定自定义 Vault 路径
.\setup.ps1 -VaultPath "D:\MyCognitiveVault"
```

安装脚本会自动：
1. 检查 Claude Code 是否可用
2. 创建 Vault 目录结构
3. 初始化数据文件
4. 安装 Skills 到项目 `.claude/commands/`
5. 安装 Agents 到全局 `~/.claude/agents/`

### 方式二：手动安装

1. **创建 Vault 目录**

```
你的Vault/
├── memory/
│   ├── short-term/
│   ├── long-term/
│   ├── user-profile.md
│   └── growth-log.md
├── cognitive-db/
│   ├── why-reasons/
│   ├── how-methods/
│   ├── cognitive-models/
│   ├── decision-frameworks/
│   └── events/
├── actions/
├── .claude/
│   └── commands/
│       ├── cognitive.md
│       ├── cognitive-record.md
│       ├── cognitive-analyze.md
│       ├── cognitive-review.md
│       ├── cognitive-build.md
│       ├── cognitive-db.md
│       ├── cognitive-dashboard.md
│       └── cognitive-check.md
```

2. **复制 Agents**

将以下 7 个 Agent 文件复制到 `~/.claude/agents/`：

| Agent 文件 | 用途 |
|-----------|------|
| emotion-agent.md | 情绪识别与拆分 |
| cognitive-agent.md | TEBAR 因果链分析 |
| reflection-agent.md | 顿悟生成、复盘引导、规律构建 |
| memory-agent.md | 存储决策与画像更新 |
| pattern-detector.md | 模式检测（两层引擎） |
| action-agent.md | 行为干预与实验设计 |
| sentinel-agent.md | 守夜人（异常检测+定时推送） |

---

## 快速开始

```bash
# 1. 进入 Vault 目录
cd 你的Vault路径

# 2. 启动 Claude Code
claude

# 3. 输入命令开始
/cognitive
```

首次使用时，系统会自动识别你是新用户，进入引导模式，帮你建立基本画像。

---

## 命令一览

| 命令 | 用途 | 最低阶段 |
|------|------|---------|
| `/cognitive` | 主入口，自动检测状态并开始对话 | 记录者 |
| `/cognitive-record` | 快速记录模式 | 记录者 |
| `/cognitive-check` | 主动检查待跟进事项 | 记录者 |
| `/cognitive-analyze` | 深度分析模式 | 思考者 |
| `/cognitive-review` | 复盘反思模式 | 思考者 |
| `/cognitive-build` | 显式触发构建（通常自动触发） | 构建者 |
| `/cognitive-db` | 查询认知数据库 | 记录者 |
| `/cognitive-dashboard` | 生成仪表盘汇总 | 思考者 |

你不需要记住所有命令——大多数时候只需要 `/cognitive`，系统会根据你的输入自动选择合适的策略。

---

## 成长过程：6 阶段循环

```
记录 → 理解 → 提炼 → 构建 → 行动 → 进化
  ↑                                      |
  └──────────────────────────────────────┘
```

### 每个阶段发生了什么

| 阶段 | 你做什么 | 系统做什么 |
|------|---------|-----------|
| **记录** | 随意说话，描述感受/事件 | 存储到短期记忆，轻量共情 |
| **理解** | 回答追问，把模糊变具体 | TEBAR 分析，提取原因和信念 |
| **提炼** | 积累多条同类原因/方法 | 自动提议"要不要整理一下？" |
| **构建** | 同意整理 | 组装个人规律/策略，写入认知数据库 |
| **行动** | 尝试微行动或行为实验 | 生成行动方案，追踪执行结果 |
| **进化** | 持续使用系统 | 阶段评估，里程碑记录，成长可视化 |

---

## 成长阶段：4 级进化

随着你的认知资产积累，系统会自动评估并通知你阶段晋升：

| 阶段 | 判定条件 | 解锁能力 |
|------|---------|---------|
| **记录者** | 刚开始使用 | 基础记录 + 情绪容器 |
| **思考者** | 短期记忆 ≥ 10 条，或原因 ≥ 3 条 | 深度分析 + Pattern Engine + Action Agent |
| **构建者** | 个人规律 ≥ 1 条，或个人策略 ≥ 1 条 | 规律构建 + 策略组装 + Reflection Agent |
| **主导者** | 行为实验成功 ≥ 3 次，且个人策略 ≥ 1 条 | 全 Agent 可用 + 自主探索 |

**阶段晋升是自动的**——你只需要持续使用，系统会在合适的时机告诉你升级了。

---

## 认知数据库

你的认知资产存储在以下 5 个库中，全部用 Obsidian 双链互相关联：

| 库 | 路径 | 存什么 |
|----|------|-------|
| 原因库 | `cognitive-db/why-reasons/` | 为什么难过/失败/卡住 |
| 方法库 | `cognitive-db/how-methods/` | 怎么解决的思考方式和方法 |
| 个人规律 | `cognitive-db/cognitive-models/` | "我发现我总是..."的可复用规律 |
| 个人策略 | `cognitive-db/decision-frameworks/` | "下次遇到X，我按这个步骤来" |
| 事件库 | `cognitive-db/events/` | 转折点、高影响、里程碑事件 |

### 构建触发

构建 **不需要** 手动操作。当同类原因/方法积累 ≥ 3 条时，系统会在对话中自然提议：

> "我发现你总是 [模式]，要不要把它整理一下，下次直接用？"

你也可以随时用 `/cognitive-build` 显式触发。

---

## 查询你的数据

```
/cognitive-db                    — 概览：画像摘要 + 各库数量 + 待跟进
/cognitive-db profile            — 完整用户画像
/cognitive-db reasons            — 查看所有原因
/cognitive-db methods            — 查看所有方法
/cognitive-db models             — 查看所有个人规律
/cognitive-db frameworks         — 查看所有个人策略
/cognitive-db actions            — 查看行动记录
/cognitive-db pending            — 查看待跟进的微行动和实验
/cognitive-db growth             — 查看成长轨迹
/cognitive-db search 关键词      — 全库搜索
/cognitive-db dashboard          — 查看仪表盘
```

---

## 6 种认知状态

系统会自动检测你当前的状态，选择最合适的对话方式：

| 状态 | 信号 | 系统行为 |
|------|------|---------|
| **ENTRY_RECORD** | 短输入，无明确问题 | 轻量共情 + 记录 |
| **EMOTION_RELEASE** | 强情绪词，情绪 ≥ 7 | 情绪容器（先接住，不分析） |
| **PROBLEM_EXPLORATION** | "我总是..."、"为什么我..." | 引导提问，找原因 |
| **COGNITIVE_REFLECTION** | "我发现我..."、"好像每次..." | 深度分析，连接已有规律 |
| **ACTION_BLOCK** | "我就是做不到"、"改不掉" | 停止说理，转向行动 |
| **FAILURE_REVIEW** | "又搞砸了"、"又失败了" | 复盘引导，归因+方法修正 |

你不需要判断自己处于什么状态——只需要说你想说的。

---

## 行动层

当你在"知道问题但做不到"的状态时，系统会切换到行动模式：

### 微行动
5 分钟内可完成的最小行动步骤。降低行动门槛。

### 行为实验
假设 → 实验 → 预期 → 实际。用科学方法验证认知假设。

### 阻力分析
四维拆解：情绪阻力 / 认知阻力 / 环境阻力 / 隐藏收益。

### 结果反馈
追踪行动结果，成功则提炼方法，失败则分析阻力并生成新行动。

---

## 定时推送

系统会在每天早上 9:03 自动检查：
- 待跟进的微行动和实验
- 异常预警（如长期未记录、情绪持续走低）
- 周期回顾提醒

需要保持 Claude Code 会话活跃才能收到推送。

---

## 典型使用场景

### 场景 1：心情不好，想倾诉

```
/cognitive
> 今天特别烦

系统：识别为 EMOTION_RELEASE → 情绪容器模式
→ 先共情，不分析，等情绪缓和后温和追问
```

### 场景 2：发现自己总是同一个模式

```
/cognitive
> 我发现我每次面对新任务都先拖延，然后焦虑

系统：识别为 COGNITIVE_REFLECTION → 深度分析
→ TEBAR 因果链分析 → 提取原因 → 检查是否积累了足够条目触发构建
```

### 场景 3：知道问题但做不到

```
/cognitive
> 我知道应该早睡但就是做不到

系统：识别为 ACTION_BLOCK → 行动模式
→ 检查是否有匹配的个人策略 → 生成微行动
```

### 场景 4：想复盘一次失败

```
/cognitive-review
> 昨天的面试又搞砸了

系统：FAILURE_REVIEW → 复盘引导
→ 事件还原 → 归因分析 → 核心教训 → 方法修正
```

### 场景 5：查看成长情况

```
/cognitive-db growth     — 查看成长轨迹
/cognitive-db dashboard  — 查看仪表盘
/cognitive-check         — 主动检查待跟进
```

---

## 数据安全

所有数据存储在你的本地文件系统中，不上传任何外部服务器。Claude Code 的对话通过 Anthropic API 处理，但你的认知数据（记忆、原因库、方法库等）始终在你自己的硬盘上。

**建议**：定期用 Obsidian 或 Git 备份你的 Vault 目录。

---

## 打包分享

如果你想把这个系统分享给他人：

1. **确保项目目录包含所有文件**

```
CognitiveOS/
├── .claude/commands/     ← 8 个 skill 文件
├── agents/               ← 7 个 agent 文件（需手动从 ~/.claude/agents/ 复制出来）
├── cognitive-db/         ← 模板文件
├── memory/               ← 初始化模板
├── actions/              ← 初始化模板
├── setup.ps1             ← 安装脚本
├── GUIDE.md              ← 本文件
└── README.md             ← 项目说明
```

2. **Agent 文件需单独打包**

Agent 文件在全局 `~/.claude/agents/` 中，需要单独收集。在 `agents/` 目录下创建一份副本：

```powershell
# 将 Cognitive OS 的 7 个 Agent 复制到项目的 agents/ 目录
$agents = @("emotion-agent.md","cognitive-agent.md","reflection-agent.md",
            "memory-agent.md","pattern-detector.md","action-agent.md","sentinel-agent.md")
foreach ($a in $agents) {
    Copy-Item "$env:USERPROFILE\.claude\agents\$a" ".\agents\$a"
}
```

3. **打包分发**

将整个目录打包为 zip，接收者解压后运行 `setup.ps1` 即可。

4. **接收者需要**

- 安装 Claude Code CLI
- 有 Anthropic API 访问权限
- （推荐）安装 Obsidian

---

## 常见问题

### Q: 我的认知数据会不会丢？
A: 所有数据都是本地 Markdown 文件，只要文件在就不会丢。建议定期备份 Vault 目录，或用 Git 管理。

### Q: 我必须用 Obsidian 吗？
A: 不必须。Obsidian 只是用来可视化浏览双链和标签，系统本身完全在 Claude Code 中运行。但 Obsidian 能让你更直观地看到认知资产之间的关联。

### Q: 为什么记录者阶段有些命令不能用？
A: 系统会根据你的认知阶段自动调整能力。记录者阶段专注记录，等数据积累够了自动升级。这是为了降低认知负担——不是限制你，是保护你。

### Q: 个人规律和个人策略有什么区别？
A: **个人规律** = "我发现我总是..."（描述性的，帮你认识自己）；**个人策略** = "下次遇到X，我按这个步骤来"（指导性的，帮你行动）。规律是认识，策略是应用。

### Q: 每天都会推送吗？
A: 系统会尝试每天早上 9:03 推送检查结果，但需要 Claude Code 会话处于活跃状态。如果没开 Claude Code，下次启动时会自动检查待跟进事项。

### Q: 可以删除或修改已有的认知条目吗？
A: 可以，所有条目都是 Markdown 文件，你可以直接编辑或删除。但建议通过 `/cognitive-db` 查看后再决定，避免误删。
