# Cognitive OS × Cyber Diary Agent 设计文档

> 日期：2026-05-16
> 状态：已确认

## 1. 产品定位

Cognitive OS 是一个集成在 Claude Code 中的认知操作系统，以 skills + agents 形态运行。不是独立应用，而是 Claude Code 生态的一部分。

用户在终端中与 Agent 对话，Agent 引导用户完成问题拆解、失败复盘、判断逻辑记录、方法论抽象、决策路径结构化。所有数据存储在 Obsidian vault 中，利用 Obsidian 的图谱、看板、日历等做可视化。

核心理念：**偏问题解决导向**，不只是观察和记录，要提炼出能指导行动和解决实际问题的认知资产。

## 2. 技术选型

| 维度 | 选择 | 理由 |
|------|------|------|
| 产品形态 | Claude Code Skills + Agents | 原生集成，无需额外 UI |
| AI 模型 | 复用 Claude Code 当前模型 | 无需额外 API Key |
| 交互方式 | 终端对话 + Obsidian 可视化 | 终端做交互，Obsidian 做展示 |
| 存储 | Obsidian vault（Markdown + YAML） | 原生可读可编辑，支持图谱/看板 |
| 触发方式 | 混合模式 | /cognitive 命令 + 自动检测 |
| 开发语言 | TypeScript（Claude Code skills） | Skills 生态原生语言 |

## 3. 整体架构

三层架构：Agent 层 → Skills 层 → 存储层

Agent 是大脑，负责状态检测和策略路由；Skill 是 Agent 可调用的能力模块。谁做判断，谁就在上面。

```
用户（Claude Code 终端）
    ↓ 对话 / /cognitive 命令
Agent 层（大脑）
    核心链路：Conversation Agent → State Detector → Strategy Router
    专项 Agent：Emotion Agent | Cognitive Agent | Reflection Agent | Memory Agent
    引导能力：问题拆解 | 失败复盘 | 判断逻辑 | 方法论抽象 | 决策路径
    ↓ 判断用户状态，选择策略，调用对应 Skill
Skills 层（能力模块）
    /cognitive-record | /cognitive-analyze | /cognitive-review | /cognitive-db
    ↓ 读写存储
存储层（Obsidian Vault）
    memory/（短期记忆 + 长期记忆 + 用户画像）
    cognitive-db/（问题拆解 + 失败复盘 + 判断逻辑 + 方法论 + 决策路径 + 提炼层）
    ↓ Obsidian 可视化
    图谱 / 看板 / 日历 / 反向链接
```

## 4. Skills 设计

Skills 是 Agent 调用的能力模块，不是独立的入口。Agent 根据用户状态决定调用哪个 Skill。

### `/cognitive` — 主入口（唯一用户入口）
- 混合触发：命令启动或 Agent 自动检测认知对话场景
- 触发后加载 Conversation Agent，由 Agent 接管后续流程
- Agent 读取用户画像 + 最近短期记忆 → State Detector 判断状态 → Strategy Router 选择 Skill

### `/cognitive-record` — 快速记录能力
- 由 Agent 在 ENTRY_RECORD / EMOTION_RELEASE 状态下调用
- 轻量模式：共情 → 简单引导 → 存入短期记忆
- 不触发认知分析链路

### `/cognitive-analyze` — 深度分析能力
- 由 Agent 在 PROBLEM_EXPLORATION / COGNITIVE_REFLECTION 状态下调用
- TEBAR 因果链分析 + 信念提取
- 结果存入 cognitive-db

### `/cognitive-review` — 复盘反思能力
- 由 Agent 在 FAILURE_REVIEW 状态下调用
- 引导用户做失败复盘、方法论修正
- 输出存入 cognitive-db

### `/cognitive-db` — 认知数据库查询
- 可由用户直接调用，也可由 Agent 调用
- 查看和检索已有的认知模式、思维模式、可复用规律
- 也能查看用户画像
- 只读，不触发对话

### Agent → Skill 调用关系
```
/cognitive (用户入口)
  ↓ 触发
Conversation Agent
  ↓ State Detector 判断状态
  ↓ Strategy Router 选择策略
  ├─ ENTRY_RECORD / EMOTION_RELEASE → /cognitive-record
  ├─ PROBLEM_EXPLORATION / COGNITIVE_REFLECTION → /cognitive-analyze
  ├─ FAILURE_REVIEW → /cognitive-review
  └─ ACTION_BLOCK → /cognitive-analyze（含阻力分析）

/cognitive-db（独立查询，只读，用户可直接调用）
```

## 5. Agent 设计

### 核心链路

**Conversation Agent** — 对话引导
- 接收用户输入，降低记录门槛
- 优先共情、具体化、引导表达
- 管理整体对话节奏

**State Detector** — 状态检测
- 判断用户当前认知状态（6 种状态之一）
- 分析维度：情绪强度、输入长度、是否存在明确问题、是否存在自我觉察、是否存在行动意图

**Strategy Router** — 策略路由
- 根据用户状态动态决定：提问方式、Agent 调用、分析深度、是否进入行动层

### 专项 Agent

**Emotion Agent** — 情绪分析
- 帮助用户识别、区分、理解情绪来源
- 做情绪拆分（焦虑 → 害怕失控？害怕失败？害怕被评价？）

**Cognitive Agent** — 认知分析
- 分析 TEBAR 因果链：Trigger → Emotion → Belief → Action → Result
- 提取用户底层信念
- 引导问题拆解、判断逻辑记录、决策路径结构化

**Reflection Agent** — 反思顿悟
- 生成顿悟感："你可能不是讨厌学习，而是害怕面对自己不够好的感觉"
- 引导失败复盘、方法论抽象

**Memory Agent** — 记忆判断 & 用户画像更新
- 判断对话内容存入：短期记忆 / 长期记忆 / 更新用户画像
- 在日常对话中识别用户信息变化（恐惧变了、爱好变了），实时更新 user-profile.md
- 提炼认知模式、思维模式、可复用规律，存入 cognitive-db

## 6. 状态机设计

### 6 种用户状态

| 状态 | 用户特征 | 进入模式 | 存储目标 |
|------|---------|---------|---------|
| ENTRY_RECORD | 输入短，无明确问题 | 轻量记录模式 | 短期记忆 |
| EMOTION_RELEASE | 强情绪，焦虑/崩溃 | 情绪容器模式 | 短期记忆 |
| PROBLEM_EXPLORATION | 有明确问题 | 问题拆解模式 | cognitive-db |
| COGNITIVE_REFLECTION | 已具备反思能力 | 深度分析模式 | cognitive-db |
| ACTION_BLOCK | 知道问题但改不掉 | 行动干预模式 | cognitive-db |
| FAILURE_REVIEW | 尝试后又失败 | 复盘模式 | cognitive-db |

### 状态转移约束

1. **情绪过强 → 禁止深度分析**：高情绪状态下无法真正认知，必须先进入情绪容器模式
2. **重复问题 ≥3 次 → 自动进入模式检测**：从认知分析升级为模式提炼
3. **长期无行动 → 进入阻力分析**：认知清晰但无行动时，停止说理，分析行为阻力

## 7. 存储设计

### 目录结构

```
vault/
├── memory/
│   ├── short-term/          # 短期记忆（session 级）
│   │   ├── 2026-05-16-evening.md
│   │   └── ...
│   ├── long-term/           # 长期记忆（重要事件、重复模式）
│   │   ├── 高压力拖延模式.md
│   │   └── ...
│   └── user-profile.md      # 用户画像（持续更新）
├── cognitive-db/
│   ├── problem-decomposition.md   # 问题拆解
│   ├── failure-review.md          # 失败复盘
│   ├── judgment-logic.md          # 判断逻辑记录
│   ├── methodology-abstraction.md # 方法论抽象
│   ├── decision-paths.md          # 决策路径结构化
│   ├── cognitive-patterns.md      # 认知模式（提炼层）
│   ├── thinking-patterns.md       # 思维模式（提炼层）
│   └── reusable-rules.md          # 可复用规律（提炼层）
```

### 文件格式：Markdown + YAML Frontmatter

所有文件使用 Markdown + YAML frontmatter，Obsidian 原生可读可编辑。

#### 短期记忆示例

```markdown
---
type: short-term-memory
date: 2026-05-16
session_id: "2026-05-16-evening"
emotion: 焦虑
intensity: 7/10
trigger: "考试临近"
current_problem: "学习拖延，刷视频逃避"
status: active
tags: [焦虑, 拖延, 学习]
---

## 当前情绪
焦虑，有压迫感

## 最近事件
- 考试还有一周
- 连续三天熬夜刷视频

## 关键对话摘要
识别到完美主义信念："必须一次学好"
```

#### 长期记忆示例

```markdown
---
type: long-term-memory
date: 2026-05-16
first_seen: 2026-03-10
frequency: 8
category: recurring-pattern
tags: [拖延, 完美主义, 高压力]
---

## 重复模式：高压力→拖延→自责

### 触发条件
高难度任务或考试临近

### 情绪链
焦虑 → 压迫感 → 无力感

### 核心信念
- "必须一次学好"
- "失败会证明我不够好"

### 行为模式
拖延 → 刷视频逃避 → 事后自责 → 更焦虑
```

#### 用户画像示例

```markdown
---
type: user-profile
last_updated: 2026-05-16
version: 12
---

## 基本信息
- 姓名: （对话中获取）
- 年龄: （对话中获取）

## 爱好
- [2026-03] 阅读、编程
- [2026-05] 新增：攀岩

## 擅长点
- 逻辑分析、深度思考
- 技术问题拆解

## 恐惧
- ~~公开演讲~~ ← [2026-05] 已克服
- 失败被否定 ← 仍活跃
- 失去掌控感 ← 仍活跃

## 性格倾向
- 高敏感、高自我要求
- 完美主义倾向

## 核心价值观
- 成长导向
- 在意他人评价
```

#### 认知数据库示例（问题拆解）

```markdown
---
type: cognitive-entry
category: problem-decomposition
date: 2026-05-16
related_patterns: [高压力拖延, 完美主义]
tags: [学习, 拖延, 拆解]
---

## 问题：学习拖延

### 表面问题
知道该学习但一直刷视频

### 拆解
1. **触发层**：任务感知为"太大太难"
2. **情绪层**：焦虑 + 压迫
3. **信念层**："必须学好" → 害怕开始
4. **行为层**：逃避（刷视频）
5. **结果层**：自责 + 更焦虑

### 可操作的切入点
- 拆小任务：从5分钟开始
- 允许不完美：先做再说
```

cognitive-db 其他文件格式同理：
- **failure-review.md** — 归因分析 + 教训 + 方法修正
- **judgment-logic.md** — 决策场景 + 推理过程 + 偏差识别
- **methodology-abstraction.md** — 从具体案例抽象出通用方法
- **decision-paths.md** — 选项 + 判断标准 + 结果 + 反思
- **cognitive-patterns.md** — 重复出现的因果链
- **thinking-patterns.md** — 灾难化/非黑即白等
- **reusable-rules.md** — 场景→规律的映射

## 8. 记忆升级机制

```
用户输入
  ↓
短期记忆（每次对话都记录）
  ↓ Pattern Engine 检测重复
重复出现 ≥3 次
  ↓
长期记忆
  ↓ 从长期记忆中提炼
认知模式 / 思维模式 / 可复用规律
  ↓
cognitive-db（提炼层）
```

用户画像更新不经过此流程，由 Memory Agent 在日常对话中实时识别和更新。

## 9. MVP 范围

### MVP 包含
- `/cognitive` 主入口 skill
- `/cognitive-record` 快速记录 skill
- `/cognitive-analyze` 深度分析 skill
- `/cognitive-review` 复盘 skill
- `/cognitive-db` 查询 skill
- Conversation Agent + State Detector + Strategy Router
- Emotion Agent + Cognitive Agent + Reflection Agent + Memory Agent
- 完整状态机（6 种状态 + 转移约束）
- Obsidian vault 存储层（memory/ + cognitive-db/）
- 用户画像实时更新

### 后续迭代
- Pattern Engine（自动模式检测，MVP 阶段由 Memory Agent 手动判断）
- Action Agent（行动干预、行为实验、微行动生成）
- 行为实验系统
- 更多可视化（自定义 Obsidian 看板、图谱视图）
- 用户认知成长轨迹
