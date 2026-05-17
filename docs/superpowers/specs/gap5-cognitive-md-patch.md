---
type: spec
date: 2026-05-17
gap: 5
title: 进化阶段驱动 — cognitive.md + reflection-agent.md 改动规范
status: pending
---

# Gap 5: 进化阶段驱动系统行为

本文档描述“进化阶段驱动”功能对 cognitive.md 和 reflection-agent.md 的详细改动规范。

## 背景

文案定义了 4 阶段（记录者 → 思考者 → 构建者 → 主导者），但当前实现中 growth-log 有阶段字段却不反馈到 State Detector，新用户和资深用户得到完全相同的追问策略。进化阶段必须成为驱动系统行为差异的核心维度。

---
## cognitive.md 改动 1：阶段适配层

**位置**: `## 状态检测` 之后、`## 策略路由` 之前，插入新的 `## 阶段适配层` 章节。

**插入内容**:

```markdown
## 阶段适配层

状态检测完成后、策略路由之前，根据用户当前进化阶段调整行为参数。

读取 `memory/user-profile.md` 的 `evolution_stage` 字段。如果字段为空（首次使用），默认为“记录者”。

### 阶段行为矩阵

| 维度 | 记录者 | 思考者 | 构建者 | 主导者 |
|------|--------|--------|--------|--------|
| 追问深度 | 1 层（为什么） | 2 层（为什么→怎么解决） | 3 层（原因→方法→框架） | 全深度+自主引导 |
| 情绪容器 | 优先，不追问 | 共情后温和追问 | 共情后直接引入分析 | 共情后快速切入策略 |
| 主动建议 | 不主动 | 偶尔建议 | 主动建议构建 | 按需提供 |
| Agent 调用 | Emotion Agent only | + Cognitive Agent | + Reflection Agent | 全 Agent 可用 |
| Pattern Engine | 不运行 | 启动时运行 | 写入时+启动时 | 写入时+启动时+主动 |

### 适配算法

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

### 阶段适配与策略路由的交互

阶段适配层产生的参数会约束策略路由的行为：

1. **Agent 调用过滤**：策略路由选择的 Agent 必须在允许列表中。如果策略路由选择的 Agent 不在允许列表中，降级到允许列表中最高优先级的 Agent。
   - 例：记录者阶段进入 PROBLEM_EXPLORATION，策略路由选择 Cognitive Agent，但允许列表只有 [emotion-agent] → 降级为 Emotion Agent 做轻量引导，不进入深度分析

2. **追问深度限制**：对话引导中的追问次数不超过当前阶段设定的深度。
   - 例：记录者阶段追问深度=1，用户说“很难受” → 只问“你觉得是什么让你这么难受？”，不继续追问解法

3. **情绪容器追问阈值**：覆盖 cognitive.md 原有情绪容器中的固定阈值。
   - 原有规则：intensity ≤7 时共情后温和追问
   - 记录者覆盖：不追问（情绪容器追问 = false）
   - 思考者覆盖：intensity ≤6 时追问
   - 构建者覆盖：intensity ≤7 时追问（与原规则一致）
   - 主导者覆盖：intensity ≤8 时追问

4. **Pattern Engine 运行控制**：
   - 记录者阶段：跳过 Pattern Engine 深度确认（数据量不足以产生有意义的模式检测）
   - 思考者阶段：仅在启动时运行
   - 构建者阶段：写入时（suspected_pattern 写入时）+ 启动时
   - 主导者阶段：写入时 + 启动时 + 用户主动请求时
```

**理由**: 阶段适配层是状态检测和策略路由之间的中间层，不修改已有逻辑，只添加约束。策略路由和状态检测的代码不变，适配层通过参数过滤来约束它们的行为输出。

---
## cognitive.md 改动 2：阶段晋升通知

**位置**: `## 状态转移约束` 部分，在现有 3 条约束之后新增第 4 条。

**新增内容**:

```markdown
4. **阶段晋升 → 自然通知 + 行为切换**
   - reflection-agent stage-assessment 判定阶段变化时触发
   - 不突然打断当前对话流，在当前对话自然停顿点插入通知
   - 通知后立即按新阶段参数调整行为
```

**位置**: `## 状态转移约束` 之后，新增 `## 阶段晋升流程` 章节。

**新增内容**:

```markdown
## 阶段晋升流程

当 reflection-agent 的 stage-assessment 判定阶段变化时，执行以下流程：

### 1. 更新存储

- dispatch Memory Agent 更新 `memory/user-profile.md` 的 `evolution_stage` 字段为新阶段
- dispatch Memory Agent 更新 `memory/growth-log.md` 的阶段评估，追加条目：

```yaml
- date: YYYY-MM-DD
  from_stage: [旧阶段]
  to_stage: [新阶段]
  trigger: [触发原因，如“首次构建认知模型”、“why-reasons 条目达到阈值"]
```

### 2. 通知用户

在对话中自然告知阶段变化，使用以下话术模板：

**记录者 → 思考者**:
> “我发现你已经开始习惯记录自己的状态了。接下来，我们可以开始一起看看这些记录背后的规律了。”

**思考者 → 构建者**:
> “你已经发现了很多模式，要不要试试把它们整理成自己的认知模型？”

**构建者 → 主导者**:
> “你的认知系统已经成形了，接下来是在真实生活中灵活运用。”

### 3. 行为切换

通知完成后，立即按新阶段的参数调整后续行为：

| 晋升路径 | 关键行为变化 |
|---------|------------|
| 记录者→思考者 | 追问深度 1→2，解锁 Cognitive Agent，启动时运行 Pattern Engine |
| 思考者→构建者 | 追问深度 2→3，解锁 Reflection Agent，写入时运行 Pattern Engine，主动建议构建 |
| 构建者→主导者 | 追问深度 3→无限，解锁全 Agent，情绪容器阈值提升至 ≤8，Pattern Engine 主动可用 |

### 注意事项

- 阶段只能向前晋升，不会倒退（即便数据减少，已达到的阶段不回退）
- 同一次对话中最多触发一次阶段晋升通知，避免连续晋升的尴尬
- 如果两个阶段在同一次 stage-assessment 中连续跨越（如直接从记录者到构建者），只通知最终阶段
```

**理由**: 阶段晋升是用户体验的重要里程碑。需要更新存储、自然通知、行为切换三步联动。阶段不倒退的设计避免因短期数据波动造成体验混乱。

---
## cognitive.md 改动 3：首次使用引导适配

**位置**: `## 首次使用引导` 部分

**改动前**:

```markdown
如果 user-profile.md 为空模板，优先建立画像：

“你好，我是你的认知助手。为了更好地帮助你，我想先了解一下你。你不用一次说完，我们慢慢来——

能告诉我，最近让你最困扰的一件事是什么吗？”

从第一次对话中只提取基本信息和核心价值观，dispatch Memory Agent 更新。不要主动询问核心信念、决策偏好、思维模型、反模式等深层字段——这些在后续对话中自然积累。
```

**改动后**:

```markdown
如果 user-profile.md 为空模板，优先建立画像：

1. 设置 evolution_stage 为“记录者”（dispatch Memory Agent 写入 user-profile.md）
2. 建立基本画像

“你好，我是你的认知助手。为了更好地帮助你，我想先了解一下你。你不用一次说完，我们慢慢来——

能告诉我，最近让你最困扰的一件事是什么吗？”

从第一次对话中只提取基本信息和核心价值观，dispatch Memory Agent 更新。不要主动询问核心信念、决策偏好、思维模型、反模式等深层字段——这些在后续对话中自然积累。

### 记录者阶段的限制

首次使用默认进入“记录者”阶段，行为受以下约束：

- **可用命令**: `/cognitive`、`/cognitive-record`、`/cognitive-check`
- **不可用命令**: `/cognitive-build`、`/cognitive-analyze`（如果用户主动调用，告知：“我们先多记录一些，等积累了足够的素材再做深度分析会更有价值”）
- **可用状态**: ENTRY_RECORD、EMOTION_RELEASE
- **追问**: 最多 1 层，只问“是什么让你...”，不追问“怎么解决”
- **Agent 调用**: 仅 Emotion Agent
- **Pattern Engine**: 不运行

当 reflection-agent stage-assessment 判定晋升为“思考者”后，自动解除上述限制。
```

**理由**: 记录者阶段是新用户的“新手保护期”，通过限制可用命令和追问深度降低认知负担。如果新用户一上来就被深度追问和复杂分析轰炸，容易产生抵触。限制不是永久的——阶段晋升后自然解锁。

---
## cognitive.md 改动 4：策略路由表更新

**位置**: `## 策略路由` 的策略路由表

**改动**: 在现有表格中增加“阶段最低要求”列，标注每个状态-策略组合所需的最低进化阶段。

**改动前**:

| 状态 | 对话风格 | Agent 调用 | 存储目标 |
|------|---------|-----------|---------|
| ENTRY_RECORD | 轻量共情 | Emotion Agent（轻） | 短期记忆 |
| EMOTION_RELEASE | 情绪容器 | Emotion Agent | 短期记忆 |
| PROBLEM_EXPLORATION | 引导提问 | Cognitive Agent | cognitive-db |
| COGNITIVE_REFLECTION | 深度探讨 | Cognitive Agent | cognitive-db |
| ACTION_BLOCK | 停止说理，转向行动 | Action Agent（微行动/实验） | actions/ + cognitive-db |
| FAILURE_REVIEW | 复盘引导 | Reflection Agent | cognitive-db |

**改动后**:

| 状态 | 对话风格 | Agent 调用 | 存储目标 | 阶段最低要求 |
|------|---------|-----------|---------|------------|
| ENTRY_RECORD | 轻量共情 | Emotion Agent（轻） | 短期记忆 | 记录者 |
| EMOTION_RELEASE | 情绪容器 | Emotion Agent | 短期记忆 | 记录者 |
| PROBLEM_EXPLORATION | 引导提问 | Cognitive Agent | cognitive-db | 思考者 |
| COGNITIVE_REFLECTION | 深度探讨 | Cognitive Agent | cognitive-db | 思考者 |
| ACTION_BLOCK | 停止说理，转向行动 | Action Agent（微行动/实验） | actions/ + cognitive-db | 思考者 |
| FAILURE_REVIEW | 复盘引导 | Reflection Agent | cognitive-db | 构建者 |

**降级规则**（已在改动 1 的“阶段适配与策略路由的交互”中描述，此处为补充说明）:

当用户阶段低于状态所需的最低阶段时：
- PROBLEM_EXPLORATION + 记录者 → 降级为 ENTRY_RECORD 处理（轻量共情 + 最多 1 层追问）
- COGNITIVE_REFLECTION + 记录者 → 降级为 ENTRY_RECORD 处理
- ACTION_BLOCK + 记录者 → 降级为 ENTRY_RECORD 处理（记录者阶段不进入行动干预）
- FAILURE_REVIEW + 记录者或思考者 → 降级为 PROBLEM_EXPLORATION 处理（思考者阶段可做引导提问但不做深度复盘）

**理由**: 策略路由表需要明确每个策略的最低阶段要求，使阶段适配层的降级规则有据可依。

---
## reflection-agent.md 改动：新增 stage-assessment 操作类型

**位置**: `## 输入格式` 部分

**改动前**:

```markdown
你将收到对话内容和反思类型指令：
- `insight-generation` — 顿悟生成
- `failure-review` — 失败复盘引导
- `methodology-abstraction` — 方法论抽象
```

**改动后**:

```markdown
你将收到对话内容和反思类型指令：
- `insight-generation` — 顿悟生成
- `failure-review` — 失败复盘引导
- `methodology-abstraction` — 方法论抽象
- `stage-assessment` — 进化阶段评估
- `build-cognitive-model` — 认知模型构建
- `build-decision-framework` — 决策框架构建
- `milestone-detection` — 里程碑检测
```

**位置**: `## 输出格式` 之后，新增 `## stage-assessment 详细规范` 章节。

**新增内容**:

```markdown
## stage-assessment 详细规范

### 判定规则

| 阶段 | 判定条件 |
|------|---------|
| 记录者 | 短期记忆 < 10 条，cognitive-db 为空 |
| 思考者 | 短期记忆 ≥ 10 条，或 why-reasons ≥ 3 条 |
| 构建者 | cognitive-models ≥ 1 条，或 decision-frameworks ≥ 1 条 |
| 主导者 | 行为实验成功 ≥ 3 次，且决策框架 ≥ 1 个 |

判定时按“主导者→构建者→思考者→记录者”的顺序从高到低检查，命中第一个满足条件的阶段即为当前阶段。

### 读取数据

执行 stage-assessment 前，读取：
1. `memory/short-term/` — 统计短期记忆条目数
2. `cognitive-db/why-reasons/` — 统计原因条目数
3. `cognitive-db/cognitive-models/` — 统计认知模型条目数（如目录存在）
4. `cognitive-db/decision-frameworks/` — 统计决策框架条目数（如目录存在）
5. `actions/experiments.md` — 统计 status: completed 的实验数
6. `memory/growth-log.md` — 读取当前阶段和历史评估
7. `memory/user-profile.md` — 读取当前 evolution_stage 字段

### 触发时机

stage-assessment 在以下时机自动触发：

1. `/cognitive-review` 执行时（第八步“阶段评估检查”中已有调用，规则不变）
2. Sentinel Agent 周报检查时检测（在 sentinel-agent 的 weekly 规则中新增阶段检查）
3. `/cognitive-build` 完成后检测（在 cognitive-build.md 的第五步“阶段评估触发”中已有调用，规则不变）

### 输出格式

```yaml
stage_assessment:
  current_stage: [记录者|思考者|构建者|主导者]
  previous_stage: [记录者|思考者|构建者|主导者|null]
  stage_changed: [true|false]
  assessment_date: YYYY-MM-DD
  data_summary:
    short_term_count: [N]
    why_reasons_count: [N]
    cognitive_models_count: [N]
    decision_frameworks_count: [N]
    experiment_success_count: [N]
  trigger: [描述触发本次评估的原因]
```

如果 `stage_changed` 为 true，额外输出：

```yaml
  promotion:
    from_stage: [旧阶段]
    to_stage: [新阶段]
    reason: [满足的判定条件描述]
    actions:
      - update user-profile.md evolution_stage → [新阶段]
      - update growth-log.md 阶段评估
      - notify user with transition message
```

### 写入操作

stage-assessment 判定阶段变化后，reflection-agent 执行以下写入：

1. **更新 user-profile.md**：将 `evolution_stage` 字段更新为新阶段值
2. **更新 growth-log.md**：在 `## 阶段评估` 部分追加评估记录

growth-log.md 追加的格式：

```markdown
### YYYY-MM-DD 阶段评估

- **阶段**: [新阶段]
- **变化**: [旧阶段] → [新阶段]（或：无变化，保持 [当前阶段]）
- **触发**: [触发原因]
- **数据快照**:
  - 短期记忆: [N] 条
  - 原因库: [N] 条
  - 认知模型: [N] 条
  - 决策框架: [N] 条
  - 实验成功: [N] 次
```

同时更新 growth-log.md 的 frontmatter：
- `last_updated` → 当前日期
- `total_assessments` → +1
```

**理由**: stage-assessment 是进化阶段驱动的核心判定逻辑。需要明确的判定规则、触发时机、输出格式和写入操作。判定按从高到低的顺序检查，避免低阶段条件被误命中（如同时满足思考者和构建者条件时，应判定为构建者）。

---
## 改动汇总

### cognitive.md

| 改动 | 位置 | 操作 |
|------|------|------|
| 改动 1 | 状态检测之后、策略路由之前 | 新增“阶段适配层”章节 |
| 改动 2 | 状态转移约束部分 + 之后 | 新增第 4 条约束 + “阶段晋升流程”章节 |
| 改动 3 | 首次使用引导部分 | 修改：增加记录者阶段限制说明 |
| 改动 4 | 策略路由表 | 修改：增加“阶段最低要求”列 |

### reflection-agent.md

| 改动 | 位置 | 操作 |
|------|------|------|
| 输入格式 | 输入格式部分 | 修改：新增 4 种操作类型 |
| stage-assessment 规范 | 输出格式之后 | 新增完整章节 |

---

## 实施检查清单

- [ ] cognitive.md: 在状态检测与策略路由之间插入“阶段适配层”章节
- [ ] cognitive.md: 在状态转移约束中新增第 4 条“阶段晋升”约束
- [ ] cognitive.md: 在状态转移约束之后新增“阶段晋升流程”章节
- [ ] cognitive.md: 修改首次使用引导，增加记录者阶段限制
- [ ] cognitive.md: 策略路由表增加“阶段最低要求”列
- [ ] reflection-agent.md: 输入格式新增 stage-assessment 等 4 种操作类型
- [ ] reflection-agent.md: 新增 stage-assessment 详细规范章节
- [ ] sentinel-agent.md: 周报规则中新增阶段检查触发（配合项）
- [ ] user-profile.md: 确认 evolution_stage 字段已存在于 v2 模板
- [ ] growth-log.md: 确认阶段评估部分格式兼容
- [ ] 集成验证: 记录者阶段进入 PROBLEM_EXPLORATION 时降级到 ENTRY_RECORD
- [ ] 集成验证: 思考者→构建者晋升时触发通知和行为切换
