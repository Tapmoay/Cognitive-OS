# Cognitive OS

**集成在 Claude Code 中的认知操作系统** — 帮你构建认知资产、认知系统、可持续调用的思维方式和方法。

[简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [English](README.md)

---

## 它能帮你做什么？

- **零门槛记录** — 随意说话，系统自动理解并存储
- **自动发现模式** — Pattern Engine 检测你反复出现的思维和行为模式
- **组装可复用规律** — "我发现我总是..." → 个人规律
- **构建行动策略** — "下次遇到X，我按这个步骤来" → 个人策略
- **追踪成长轨迹** — 从记录者到主导者，4 级进化自动评估

## 核心概念

### 6 阶段循环

```
记录 → 理解 → 提炼 → 构建 → 行动 → 进化
  ↑                                      |
  └──────────────────────────────────────┘
```

| 阶段 | 你做什么 | 系统做什么 |
|------|---------|-----------|
| **记录** | 随意说话，描述感受/事件 | 存储到短期记忆，轻量共情 |
| **理解** | 回答追问，把模糊变具体 | TEBAR 分析，提取原因和信念 |
| **提炼** | 积累多条同类原因/方法 | 自动提议"要不要整理一下？" |
| **构建** | 同意整理 | 组装个人规律/策略，写入认知数据库 |
| **行动** | 尝试微行动或行为实验 | 生成行动方案，追踪执行结果 |
| **进化** | 持续使用系统 | 阶段评估，里程碑记录，成长可视化 |

### 4 级进化阶段

| 阶段 | 判定条件 | 解锁能力 |
|------|---------|---------|
| **记录者** | 刚开始使用 | 基础记录 + 情绪容器 |
| **思考者** | 短期记忆 ≥ 10 条，或原因 ≥ 3 条 | 深度分析 + Pattern Engine + Action Agent |
| **构建者** | 个人规律 ≥ 1 条，或个人策略 ≥ 1 条 | 规律构建 + 策略组装 + Reflection Agent |
| **主导者** | 行为实验成功 ≥ 3 次，且个人策略 ≥ 1 条 | 全 Agent 可用 + 自主探索 |

### 6 种认知状态（自动检测）

| 状态 | 信号 | 系统行为 |
|------|------|---------|
| ENTRY_RECORD | 短输入，无明确问题 | 轻量共情 + 记录 |
| EMOTION_RELEASE | 强情绪词，情绪 ≥ 7 | 情绪容器（先接住，不分析） |
| PROBLEM_EXPLORATION | "我总是..."、"为什么我..." | 引导提问，找原因 |
| COGNITIVE_REFLECTION | "我发现我..."、"好像每次..." | 深度分析，连接已有规律 |
| ACTION_BLOCK | "我就是做不到"、"改不掉" | 停止说理，转向行动 |
| FAILURE_REVIEW | "又搞砸了"、"又失败了" | 复盘引导，归因+方法修正 |

## 项目结构

```
CognitiveOS/
├── .claude/commands/          ← 8 个 Skill（Claude Code 命令）
│   ├── cognitive.md           ← 主入口 — 状态检测 + 策略路由
│   ├── cognitive-record.md    ← 快速记录模式
│   ├── cognitive-analyze.md   ← 深度分析模式
│   ├── cognitive-review.md    ← 复盘反思模式
│   ├── cognitive-build.md     ← 显式构建触发
│   ├── cognitive-db.md        ← 认知数据库查询（只读）
│   ├── cognitive-dashboard.md ← 仪表盘生成
│   └── cognitive-check.md     ← 主动检查 + 定时推送
│
├── agents/                    ← 7 个 Agent（由 Skill 调度）
│   ├── emotion-agent.md       ← 情绪识别、拆分、强度评估
│   ├── cognitive-agent.md     ← TEBAR 因果链分析、信念提取
│   ├── reflection-agent.md    ← 顿悟生成、复盘引导、规律/策略构建
│   ├── memory-agent.md        ← 存储决策、画像更新、原因/方法提炼
│   ├── pattern-detector.md    ← 两层 Pattern Engine（快速筛选 + 深度确认）
│   ├── action-agent.md        ← 微行动、行为实验、阻力分析
│   └── sentinel-agent.md      ← 守夜人 — 异常检测 + 定时推送
│
├── cognitive-db/              ← 5 个认知数据库（Obsidian 双链互关）
│   ├── why-reasons/           ← 为什么难过/失败/卡住
│   ├── how-methods/           ← 怎么解决的思考方式和方法
│   ├── cognitive-models/      ← 个人规律 — "我发现我总是..."
│   ├── decision-frameworks/   ← 个人策略 — "下次遇到X，我按这个步骤来"
│   └── events/                ← 转折点、高影响、里程碑事件
│
├── memory/                    ← 记忆层
│   ├── short-term/            ← 短期记忆（近期对话）
│   ├── long-term/             ← 长期记忆（重复出现的模式）
│   ├── user-profile.md        ← 用户画像（信念、偏好、规律）
│   └── growth-log.md          ← 成长轨迹（阶段评估 + 里程碑）
│
├── actions/                   ← 行动追踪
│   ├── micro-actions.md       ← 5 分钟可完成的微行动
│   ├── experiments.md         ← 行为实验
│   ├── resistance-analysis.md ← 四维阻力拆解
│   └── feedback.md            ← 行动结果反馈
│
├── docs/                      ← 设计文档
│   └── superpowers/specs/     ← 功能设计规范
│
├── setup.ps1                  ← 一键安装脚本
├── GUIDE.md                   ← 详细使用指南（简体中文）
└── README.md                  ← 项目说明（English）
```

## 架构

```
Agent 层（分析 + 反思 + 行动）
    ↓
Skill 层（对话引导 + 状态路由）
    ↓
存储层（Markdown + Obsidian 双链）
```

## 命令

| 命令 | 用途 | 最低阶段 |
|------|------|---------|
| `/cognitive` | 主入口 — 自动检测状态 | 记录者 |
| `/cognitive-record` | 快速记录 | 记录者 |
| `/cognitive-check` | 主动检查待跟进事项 | 记录者 |
| `/cognitive-analyze` | 深度分析 | 思考者 |
| `/cognitive-review` | 复盘反思 | 思考者 |
| `/cognitive-build` | 显式构建（通常自动触发） | 构建者 |
| `/cognitive-db` | 查询认知数据库 | 记录者 |
| `/cognitive-dashboard` | 生成仪表盘 | 思考者 |

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/Tapmoay/Cognitive-OS.git
cd Cognitive-OS

# 2. 运行安装
.\setup.ps1

# 3. 启动 Claude Code
claude

# 4. 开始使用
/cognitive
```

**前置要求：**
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) 已安装并登录
- （推荐）[Obsidian](https://obsidian.md) 用于可视化浏览认知数据

## 数据安全

所有数据存储在本地文件系统，不上传任何外部服务器。

## 文档

- [详细使用指南（简体中文）](GUIDE.md)
- [Detailed Usage Guide (English)](docs/en/GUIDE.md)
- [詳細使用指南（繁體中文）](docs/zh-tw/GUIDE.md)
- 设计文档：`docs/superpowers/specs/`

## 许可证

MIT
