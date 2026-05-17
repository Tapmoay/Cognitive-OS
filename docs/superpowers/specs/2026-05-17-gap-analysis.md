# 愿景-实现差距分析

> **日期**: 2026-05-17
> **状态**: 待实施
> **目的**: 对照愿景文案，识别当前实现的 6 大缺口，给出可执行的改进方案

---

## 缺口总览

| # | 缺口 | 严重度 | 影响范围 |
|---|------|--------|---------|
| 1 | 6 阶段闭环缺"构建"和"进化" | 🔴 关键 | 核心循环断裂 |
| 2 | 认知数据库缺事件库和策略库 | 🟡 高 | 数据沉淀不完整 |
| 3 | 长期记忆（user-profile）过薄 | 🟡 高 | 无法形成稳定认知画像 |
| 4 | 工作流 Step 7"系统应用"缺失 | 🔴 关键 | 闭环只有写入没有回读 |
| 5 | 进化阶段不驱动系统行为 | 🟡 高 | 新老用户体验无差异 |
| 6 | 引导提问缺少结构化模板库 | 🟠 中 | 引导质量依赖即时生成 |

---

## 缺口 1：6 阶段闭环缺"构建"和"进化"

### 愿景定义

```
记录 → 理解 → 提炼 → 构建 → 行动 → 进化
```

6 阶段形成完整闭环，每阶段有明确的输入输出。

### 当前实现

| 阶段 | 对应实现 | 状态 |
|------|---------|------|
| 记录 | /cognitive-record, cognitive.md ENTRY_RECORD | ✅ |
| 理解 | cognitive-agent (TEBAR), emotion-agent | ✅ |
| 提炼 | pattern-detector, extract-reason, extract-method | ✅ |
| **构建** | **无对应 skill/agent** | ❌ |
| 行动 | action-agent, actions/ | ✅ |
| **进化** | growth-log 模板（空），无自动触发 | ⚠️ |

### 问题

- 用户从"提炼出规律"到"形成个人认知操作系统"之间没有桥梁
- 提炼出的 why-reasons 和 how-methods 是散落的条目，无法组装成框架
- "进化"阶段只有 growth-log 模板，没有阶段评估的自动触发机制，也没有阶段变化驱动系统行为变更

### 改进方案

#### 1a. 新增构建层

**新 Skill**: `/cognitive-build`

用途：把提炼出的零散原因和方法组装成结构化的认知模型和决策框架。

触发时机：
- 手动：用户主动调用
- 自动：当 why-reasons 中同一 reason_type 积累 ≥3 条，或 how-methods 中同一 method_type 积累 ≥3 条时，Sentinel Agent 建议触发

功能：
1. **认知模型构建** — 从 why-reasons 的同类别条目中抽象出通用认知模型
2. **决策框架构建** — 从 how-methods 的同类别条目中组装出决策流程
3. **价值体系梳理** — 从涉及的信念中提炼核心价值观层级

输出存储：
- `cognitive-db/cognitive-models/` — 认知模型（新建目录）
- `cognitive-db/decision-frameworks/` — 决策框架（新建目录）
- `memory/user-profile.md` — 增补核心信念和价值观字段

**新 Agent 操作**（扩展 reflection-agent）：
- `build-cognitive-model` — 从多个 why-reasons 抽象出通用模型
- `build-decision-framework` — 从多个 how-methods 组装出决策流程

条目格式：

```markdown
---
type: cognitive-model
category: cognitive-models
date: YYYY-MM-DD
model_type: [behavioral|emotional|cognitive]
source_reasons: []
source_methods: []
tags: [#model/[类别]]
---

## 认知模型：[名称]

### 模型描述
[一句话概括这个模型描述的核心规律]

### 触发条件
当 [条件组合] 时

### 因果链
[从多个 why-reasons 抽象出的通用 TEBAR 链]

### 应对策略
1. [从 how-methods 提炼的步骤]
2. [...]

### 证据条目
- [[原因1]]
- [[原因2]]
- [[方法1]]
```

```markdown
---
type: decision-framework
category: decision-frameworks
date: YYYY-MM-DD
framework_type: [daily|crisis|planning|relationship]
source_methods: []
tags: [#framework/[类别]]
---

## 决策框架：[名称]

### 适用场景
[什么时候使用这个框架]

### 决策步骤
1. [识别信号] — 从认知模型中匹配触发条件
2. [暂停判断] — [...]
3. [调用策略] — 从关联方法中选择
4. [执行验证] — [...]
5. [复盘记录] — [...]

### 关联认知模型
- [[认知模型1]]

### 关联方法
- [[方法1]]
- [[方法2]]
```

#### 1b. 强化进化层

**改动位置**: reflection-agent, cognitive-review.md

新增功能：
- `stage-assessment` — 基于数据量自动判断用户当前进化阶段
- 阶段变化时自动更新 `memory/growth-log.md` 和 `memory/user-profile.md`

进化阶段判定规则：

| 阶段 | 判定条件 |
|------|---------|
| 记录者 | 短期记忆 < 10 条，cognitive-db 为空 |
| 思考者 | 短期记忆 ≥ 10 条，或 why-reasons ≥ 3 条 |
| 构建者 | cognitive-models ≥ 1 条，或 decision-frameworks ≥ 1 条 |
| 主导者 | 行为实验成功 ≥ 3 次，且决策框架 ≥ 1 个 |

触发时机：
- `/cognitive-review` 执行时自动检查
- Sentinel Agent 周报检查时检测

---

## 缺口 2：认知数据库缺事件库和策略库

### 愿景定义

5 个子库：事件库、模式库、规律库、策略库、成长轨迹

### 当前实现

2 个子库：why-reasons（原因库）、how-methods（方法库）

重构时精简方向正确（8→2），但事件库和策略库的职能丢失了。

### 丢失职能

| 丢失 | 影响 |
|------|------|
| **事件库** — 重要事件、转折点、高影响经历 | 用户的人生关键节点无处沉淀，复盘时缺乏锚点 |
| **策略库** — 决策策略、行动方案、行为优化方案 | 方法是"怎么想"，策略是"怎么做"——how-methods 只覆盖了思考方式，缺少执行层面的行为策略 |

### 改进方案

#### 2a. 新增事件库

**新目录**: `cognitive-db/events/`

```markdown
---
type: cognitive-entry
category: events
date: YYYY-MM-DD
event_type: [turning-point|high-impact|recurring-milestone]
intensity: [1-10]
related_reasons: []
related_methods: []
tags: [#event/[类别]]
---

## 事件：[名称]

### 事件描述
[发生了什么]

### 时间线
- [时间点]: [发生了什么]

### 影响分析
[这件事对认知/情绪/行为产生了什么影响]

### 关联原因
- [[原因1]]

### 关联方法
- [[方法1]]

### 后续行动
- [ ] [待跟进事项]
```

**触发时机**：
- 用户描述重大事件时，Memory Agent 自动判断 event_type
- `/cognitive-review` 复盘时标记为转折点
- 行为实验成功完成时标记为 recurring-milestone

#### 2b. 扩展 how-methods 覆盖策略

不新增独立策略库，而是扩展 how-methods 的 `method_type`：

现有：`thinking | behavior | coping`

新增：`strategy` — 决策策略和行动方案

策略类型条目模板：

```markdown
---
type: cognitive-entry
category: how-methods
date: YYYY-MM-DD
method_type: strategy
applicable_reasons: []
decision_context: [daily|crisis|planning|relationship]
tags: [#method/strategy]
---

## 策略：[名称]

### 解决什么决策问题
[什么场景下需要做决策]

### 决策步骤
1. [步骤1]
2. [步骤2]
3. [步骤3]

### 判断标准
[如何判断这个策略是否适用]

### 风险提示
[使用这个策略可能踩的坑]

### 来源案例
- [YYYY-MM-DD]: [案例摘要]

### 效果记录
- [YYYY-MM-DD]: [效果评价]
```

这样保持 2 库 + 1 新目录（events）的简洁结构，同时覆盖了文案描述的 5 库职能。

---

## 缺口 3：长期记忆（user-profile）过薄

### 愿景定义

长期记忆应包含：
- 个人认知模型
- 核心信念与价值观
- 优势与偏好
- 决策框架与思维模型
- 人生使命与长期愿景

### 当前实现

user-profile.md 只有 7 个空字段：姓名、年龄、爱好、擅长点、恐惧、性格倾向、核心价值观

### 缺失字段

| 缺失 | 来源 | 重要性 |
|------|------|--------|
| 核心信念 | TEBAR 分析中的 Belief 层 | 高 — 信念驱动行为 |
| 决策偏好 | 历史决策模式分析 | 高 — 指导策略推荐 |
| 思维模型 | Pattern Engine 确认的模式 | 中 — 认知自我画像 |
| 人生使命/长期愿景 | 深度反思中浮现 | 中 — 长期方向 |
| 当前进化阶段 | growth-log 评估结果 | 中 — 驱动系统行为 |
| 反模式（反复踩的坑） | why-reasons 高频条目 | 高 — 避免重复错误 |

### 改进方案

扩展 user-profile.md 模板：

```markdown
---
type: user-profile
last_updated: YYYY-MM-DD
version: 2
evolution_stage: [记录者|思考者|构建者|主导者]
tags: []
---

## 基本信息
- 姓名: （对话中获取）
- 年龄: （对话中获取）

## 爱好
- （对话中获取）

## 擅长点
- [[擅长点1]] #strength/[类别]

## 恐惧
- [[恐惧1]] #fear/[类别]
- 克服后标记：~~[[旧恐惧]]~~ ← [日期] 已克服 #growth/里程碑

## 性格倾向
- （对话中获取）

## 核心价值观
- （对话中获取）

## 核心信念
- [[信念1]] #belief/[类别]
- （从 TEBAR 分析中提取，用 [[双链]] 链接，添加 #belief/ 标签）
- 信念被推翻时标记：~~[[旧信念]]~~ ← [日期] 已推翻 #growth/里程碑

## 决策偏好
- （对话中获取，从历史决策模式中提炼）
- 例如：倾向回避冲突 / 倾向过度准备 / 倾向冲动行动

## 思维模型
- [[认知模型1]] #model/[类别]
- （从 /cognitive-build 构建的模型，双链引用）

## 反模式（反复踩的坑）
- [[反模式1]] #antipattern/[类别]
- （从 why-reasons 高频条目中提炼）

## 人生使命与长期愿景
- （深度反思中浮现，不在首次引导时收集）
```

**自动填充规则**：
- 核心信念 → cognitive-agent TEBAR 分析时自动提取
- 决策偏好 → Memory Agent 在 extract-reason 时识别决策模式
- 思维模型 → /cognitive-build 构建后自动双链
- 反模式 → why-reasons 中 frequency ≥ 3 的条目自动提示
- 进化阶段 → reflection-agent stage-assessment 判定后写入

---

## 缺口 4：工作流 Step 7"系统应用"缺失

### 愿景定义

Step 7：在未来决策中调用、行动中优化、情绪中提醒、人生中迭代。

### 当前实现

只有写入（Memory Agent 存储到各库），没有回读应用。cognitive-db skill 是手动查询，不会在对话中主动注入历史洞察。

### 问题

- 用户重复遇到相似问题，系统不会提醒"上次你遇到类似情况时..."
- 提炼出的方法无法在决策时被调用
- 认知模型和决策框架形同虚设——存了但不用

### 改进方案

#### 4a. 对话启动时自动检索相关历史

**改动位置**: cognitive.md 启动流程

在启动流程 Step 2（读取短期记忆）后，新增 Step 2.5：

```
2.5. 语义检索相关历史洞察
  - 读取 cognitive-db/why-reasons/ — 检查是否有与当前输入相关的历史原因
  - 读取 cognitive-db/how-methods/ — 检查是否有适用的历史方法
  - 读取 cognitive-db/events/ — 检查是否有相似的历史事件
  - 读取 cognitive-db/cognitive-models/ — 检查是否有匹配的认知模型
  - 读取 cognitive-db/decision-frameworks/ — 检查是否有适用的决策框架
```

匹配方式：
- 关键词匹配（标签 + 涉及信念 + 触发场景）
- 用户输入中的情绪词 → why-reasons 的 reason_type: emotion
- 用户输入中的问题模式 → cognitive-models 的触发条件

检索到相关洞察后的注入策略：

| 匹配强度 | 注入方式 |
|---------|---------|
| 强匹配（标签+场景都命中） | 对话中主动提及："之前你遇到类似情况时，[原因/方法]——这次感觉怎么样？" |
| 弱匹配（仅标签命中） | 准备为上下文背景，不主动提及，但在追问时参考 |

#### 4b. 情绪场景自动提醒

**改动位置**: cognitive.md 状态检测 + emotion-agent

当检测到 EMOTION_RELEASE 且 why-reasons 中有 reason_type: emotion 的条目匹配当前情绪：
- 在情绪容器共情后，温和引入："之前你也有过类似的感受，当时是因为 [原因]——这次是一样的吗？"
- 不强推分析，只提供一个参考锚点

#### 4c. 行动场景自动调用策略

**改动位置**: cognitive.md ACTION_BLOCK 路由

当进入 ACTION_BLOCK 且 decision-frameworks 中有匹配的框架：
- 传递给 Action Agent："用户之前构建了 [框架名称]，当前场景匹配，基于此框架生成微行动"
- Action Agent 基于框架的决策步骤生成行动方案，而非从零设计

---

## 缺口 5：进化阶段不驱动系统行为

### 愿景定义

4 阶段：记录者 → 思考者 → 构建者 → 主导者

每个阶段应有不同的交互深度和策略。

### 当前实现

growth-log 有阶段字段，但不反馈到 State Detector。新用户和资深用户得到相同的追问策略。

### 问题

- 记录者阶段的用户需要降低门槛，但当前追问深度与构建者阶段一样
- 主导者阶段应能自主调用深度分析，但系统仍然以引导为主

### 改进方案

#### 5a. 阶段驱动的行为差异

**改动位置**: cognitive.md 状态检测 + 策略路由

在启动流程中读取 user-profile.md 的 `evolution_stage` 字段，根据阶段调整行为：

| 维度 | 记录者 | 思考者 | 构建者 | 主导者 |
|------|--------|--------|--------|--------|
| 追问深度 | 1 层（为什么） | 2 层（为什么→怎么解决） | 3 层（原因→方法→框架） | 全深度+自主引导 |
| 情绪容器 | 优先，不追问 | 共情后温和追问 | 共情后直接引入分析 | 共情后快速切入策略 |
| 主动建议 | 不主动 | 偶尔建议 | 主动建议构建 | 按需提供 |
| Agent 调用 | Emotion Agent only | + Cognitive Agent | + Reflection Agent | 全 Agent 可用 |
| Pattern Engine | 不运行 | 启动时运行 | 写入时+启动时 | 写入时+启动时+主动 |

**实现方式**：

在 cognitive.md 的状态检测后、策略路由前，插入阶段适配层：

```
读取 evolution_stage →
  if 记录者:
    追问深度 = 1
    允许的 Agent = [emotion-agent]
    情绪容器追问 = false
  elif 思考者:
    追问深度 = 2
    允许的 Agent = [emotion-agent, cognitive-agent]
    情绪容器追问 = true (intensity ≤6)
  elif 构建者:
    追问深度 = 3
    允许的 Agent = [emotion-agent, cognitive-agent, reflection-agent]
    情绪容器追问 = true (intensity ≤7)
    主动建议构建 = true
  elif 主导者:
    追问深度 = 无限
    允许的 Agent = [all]
    情绪容器追问 = true (intensity ≤8)
    自主调用 = true
```

#### 5b. 阶段晋升通知

当 reflection-agent stage-assessment 判定阶段变化时：
- 更新 user-profile.md 的 evolution_stage
- 更新 growth-log.md 的阶段评估
- 在对话中自然告知："我发现你已经从 [旧阶段] 走到了 [新阶段]，接下来我们可以 [新阶段的行为建议]"

---

## 缺口 6：引导提问缺少结构化模板库

### 愿景定义

7 类提问模板：事件还原、情绪探索、认知探究、行为分析、结果复盘、规律提炼、未来优化

### 当前实现

5 条 why/how 追问规则存在，但没有可复用的提问模板库。AI 全靠即时生成。

### 问题

- 引导质量不稳定，依赖 AI 的即时发挥
- 没有覆盖"事件还原"和"结果复盘"等维度的结构化引导
- 新用户（记录者阶段）需要更具体的提问引导，当前规则太抽象

### 改进方案

#### 6a. 内嵌提问模板库到 cognitive.md

在 cognitive.md 的对话引导原则中增加结构化提问模板库，按状态和阶段动态组合：

```markdown
## 提问模板库

### 事件还原（适用：ENTRY_RECORD, PROBLEM_EXPLORATION）
- 发生了什么？能按时间顺序说说吗？
- 最让你印象深刻的是哪个瞬间？
- 当时的情境是什么样的（在哪里、和谁、在做什么）？

### 情绪探索（适用：EMOTION_RELEASE, ENTRY_RECORD）
- 你现在的感受是什么？用一两个词形容
- 这种感受有多强烈？（1-10）
- 身体上有什么感觉吗？（胸口紧、肩膀重...）

### 认知探究（适用：PROBLEM_EXPLORATION, COGNITIVE_REFLECTION）
- 你当时脑子里在想什么？
- 有没有一个瞬间你做了某个判断？那个判断是什么？
- 这个想法是一直都有，还是这次才出现的？

### 行为分析（适用：ACTION_BLOCK, COGNITIVE_REFLECTION）
- 你当时做了什么？
- 为什么选择这么做，而不是其他做法？
- 回头看，有没有你当时没考虑到的选项？

### 结果复盘（适用：FAILURE_REVIEW, COGNITIVE_REFLECTION）
- 结果怎么样？和预期有什么不同？
- 如果重来一次，你会改变什么？
- 这件事让你对自己有了什么新认识？

### 规律提炼（适用：COGNITIVE_REFLECTION, 构建者+）
- 这种情况以前出现过吗？有什么相似之处？
- 你觉得这背后有什么共同的规律？
- 能不能用一句话总结这个规律？

### 未来优化（适用：构建者+, 主导者）
- 下次遇到类似情况，你会怎么做？
- 需要什么条件或支持才能做到？
- 能不能把这个策略变成一个可执行的步骤？
```

#### 6b. 阶段限制提问深度

| 模板类别 | 记录者 | 思考者 | 构建者 | 主导者 |
|---------|--------|--------|--------|--------|
| 事件还原 | ✅ | ✅ | ✅ | ✅ |
| 情绪探索 | ✅ | ✅ | ✅ | ✅ |
| 认知探究 | — | ✅ | ✅ | ✅ |
| 行为分析 | — | ✅ | ✅ | ✅ |
| 结果复盘 | — | ✅ | ✅ | ✅ |
| 规律提炼 | — | — | ✅ | ✅ |
| 未来优化 | — | — | ✅ | ✅ |

记录者阶段只用事件还原+情绪探索，降低认知负担。

---

## 实施优先级

### P0 — 立即实施（闭环断裂，不补就无法运行）

1. **缺口 4：系统应用回读** — 没有回读，存的一切数据都是死的
2. **缺口 1a：构建层** — 没有 /cognitive-build，提炼出的数据无法组装成系统

### P1 — 尽快实施（数据结构缺失，影响长期沉淀）

3. **缺口 2：事件库** — 重要事件无处沉淀
4. **缺口 3：user-profile 增厚** — 长期记忆太薄，无法支撑认知画像

### P2 — 后续迭代（体验优化）

5. **缺口 5：进化阶段驱动** — 需要先有数据才能驱动
6. **缺口 6：提问模板库** — 可以快速内嵌，但不影响核心闭环

---

## 实施后的完整架构

```
Agent 层
  Conversation Agent → State Detector → 阶段适配层 → Strategy Router
  Specialist Agents:
    Emotion Agent | Cognitive Agent | Reflection Agent
    Memory Agent | Action Agent | Pattern Detector | Sentinel Agent

Skills 层
  /cognitive           — 主入口（+ 系统应用回读 + 阶段适配 + 提问模板库）
  /cognitive-record    — 快速记录
  /cognitive-analyze   — 深度分析
  /cognitive-review    — 复盘反思（+ 阶段评估）
  /cognitive-build     — 构建模型与框架（新增）
  /cognitive-db        — 只读查询
  /cognitive-dashboard — 仪表盘
  /cognitive-check     — 主动检查

存储层
  memory/
    short-term/        — 短期记忆
    long-term/         — 长期记忆
    user-profile.md    — 用户画像（v2 增厚版）
    growth-log.md      — 成长轨迹
  cognitive-db/
    why-reasons/       — 原因库
    how-methods/       — 方法库（+ strategy 类型）
    events/            — 事件库（新增）
    cognitive-models/  — 认知模型（新增）
    decision-frameworks/ — 决策框架（新增）
  actions/
    micro-actions.md   — 微行动
    experiments.md     — 行为实验
    resistance-analysis.md — 阻力分析
    feedback.md        — 结果反馈
```

### 6 阶段闭环对照

| 阶段 | Skill | Agent | 存储 |
|------|-------|-------|------|
| 记录 | /cognitive, /cognitive-record | Emotion Agent | short-term/ |
| 理解 | /cognitive-analyze | Cognitive Agent | short-term/, why-reasons/ |
| 提炼 | Pattern Engine | Pattern Detector, Memory Agent | why-reasons/, how-methods/ |
| **构建** | **/cognitive-build** | **Reflection Agent** | **cognitive-models/, decision-frameworks/** |
| 行动 | /cognitive | Action Agent | actions/, how-methods/ |
| **进化** | **/cognitive-review** | **Reflection Agent** | **growth-log/, user-profile.md** |

### 7 步工作流对照

| Step | 愿景 | 实现 |
|------|------|------|
| 1. 输入触发 | ✅ | /cognitive 输入 |
| 2. AI 引导提问 | ✅ | why/how 规则 + 提问模板库 |
| 3. 认知解构 | ✅ | TEBAR + Cognitive Agent |
| 4. 反思总结 | ✅ | Reflection Agent |
| 5. 规律提炼 | ✅ | Pattern Engine + extract-reason/method |
| 6. 存入数据库 | ✅ | Memory Agent → 各库 |
| **7. 系统应用** | **✅** | **启动时检索相关历史 + 情绪场景提醒 + 行动场景调用策略** |
