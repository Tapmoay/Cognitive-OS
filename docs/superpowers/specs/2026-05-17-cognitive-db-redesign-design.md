# 认知数据库重构 + 对话行为优化 设计文档

> **日期**: 2026-05-17
> **状态**: 已确认

## 概述

重构认知数据库，从 8 个按认知科学分类的文件精简为 2 个按实用目的分类的文件（原因库 + 方法库），同时优化对话行为——引导用户追问"为什么"和"怎么解决"。

**核心定位**：认知数据库主要记录**可被持续调用的思考方式和方法论**。

## 1. 数据库重构

### 现状问题

现有 8 个文件按认知科学分类（cognitive-patterns, thinking-patterns, reusable-rules, methodology-abstraction, problem-decomposition, failure-review, judgment-logic, decision-paths），但：

- 分类过细，实际使用中难以判断一条记录该归入哪个文件
- thinking-patterns、judgment-logic、decision-paths 与"记录可调用的思考方式"这一核心定位契合度低
- 数据库为空模板，无迁移成本

### 新结构：2 文件极简方案

#### 原因库 `cognitive-db/why-reasons.md`

记录"为什么"——情绪原因、失败原因、卡住原因。

```markdown
---
type: cognitive-db-index
category: why-reasons
last_updated: YYYY-MM-DD
entry_count: 0
---

# 原因库

记录"为什么"——情绪原因、失败原因、卡住原因。

## 条目格式

---
type: cognitive-entry
category: why-reasons
date: YYYY-MM-DD
reason_type: [emotion|failure|stuck]
frequency: 1
related_methods: []
tags: [#reason/[类别]]
---

## 原因：[名称]

### 触发场景
当 [条件] 时

### 原因分析
[为什么会产生这种情绪/失败/卡住]

### 涉及的信念
- [[信念1]]
- [[信念2]]

### 关联的解决方法
- [[方法1]]
- [[方法2]]

### 证据记录
- [YYYY-MM-DD]: [场景摘要]（来源：短期记忆 / 行为实验）

## 条目列表

（尚无条目）
```

**标签规则**：
- `#reason/emotion` — 情绪原因（为什么难过/焦虑/低落）
- `#reason/failure` — 失败原因（为什么搞砸/没做成）
- `#reason/stuck` — 卡住原因（为什么总是走不出来）

#### 方法库 `cognitive-db/how-methods.md`

记录"怎么解决"——可被持续调用的思考方式和方法论。

```markdown
---
type: cognitive-db-index
category: how-methods
last_updated: YYYY-MM-DD
entry_count: 0
---

# 方法库

记录"怎么解决"——可被持续调用的思考方式和方法论。

## 条目格式

---
type: cognitive-entry
category: how-methods
date: YYYY-MM-DD
method_type: [thinking|behavior|coping]
applicable_reasons: []
tags: [#method/[类别]]
---

## 方法：[名称]

### 解决什么问题
[描述这个方法应对的原因/问题]

### 方法步骤
1. [步骤1]
2. [步骤2]
3. [步骤3]

### 适用场景
- [场景1]
- [场景2]

### 来源案例
- [YYYY-MM-DD]: [案例摘要]（来源：[[相关条目]]）

### 效果记录
- [YYYY-MM-DD]: [效果评价]（来源：[[相关行动]]）

## 条目列表

（尚无条目）
```

**标签规则**：
- `#method/thinking` — 思考方式（认知重构、视角转换等）
- `#method/behavior` — 行为策略（微行动、行为实验等）
- `#method/coping` — 应对方法（情绪调节、落地技术等）

#### 双向链接

- 原因库条目通过 `[[方法名称]]` 链接到方法库中能解决此原因的方法
- 方法库条目通过 `[[原因名称]]` 链接到原因库中此方法能应对的原因
- `related_methods` 和 `applicable_reasons` 字段存储双链名称列表

#### 数据来源映射

旧文件内容映射到新结构：

| 旧文件 | 映射到 | 映射规则 |
|--------|--------|----------|
| cognitive-patterns | 原因库 | TEBAR 因果链 → 原因分析，中断策略 → 关联方法 |
| thinking-patterns | 原因库 | 认知偏差 → 涉及的信念 |
| reusable-rules | 方法库 | 场景→规律 → 适用场景 + 方法步骤 |
| methodology-abstraction | 方法库 | 直接映射，通用方法 + 使用步骤 |
| problem-decomposition | 原因库 | 5 层拆解 → 原因分析 |
| failure-review | 原因库 + 方法库 | 归因分析 → 原因，方法修正 → 方法 |
| judgment-logic | 原因库 | 推理偏差 → 涉及的信念 |
| decision-paths | 方法库 | 决策过程 → 方法步骤 |

## 2. 对话行为引导

### 核心原则

对话中主动引导用户追问"为什么"和"怎么解决"，让每次对话都能产出可记录的原因和方法。

### 5 条引导规则

1. **情绪表达 → 追问原因**：用户说"很难受" → "你觉得是什么让你这么难受？"
2. **失败描述 → 追问原因**：用户说"又搞砸了" → "你觉得这次和上次比，问题出在哪里？"
3. **卡住描述 → 追问原因**：用户说"总是卡在这里" → "你觉得是什么让你一直走不出来？"
4. **找到原因 → 追问解法**：识别出原因后 → "以前有没有类似的情况？当时是怎么走出来的？"
5. **找到解法 → 确认步骤**：用户说出解法 → "能不能把步骤理一下？下次可以直接用。"

### 与情绪容器的关系

EMOTION_RELEASE 状态下仍然优先共情，但在共情之后**温和追问**：
- 旧行为：只共情，等情绪降温，不引导
- 新行为：先共情，等情绪缓和后，温和追问"你觉得是什么让你这么难受？"
- 不在强情绪时追问（intensity ≥8 时仍只共情，intensity 7 时共情后可温和追问）

### 与状态模型的关系

6 种状态和优先级不变，但每种状态的对话策略都加入 why/how 引导：

| 状态 | 新增引导 |
|------|---------|
| ENTRY_RECORD | 如果有情绪词 → 追问原因 |
| EMOTION_RELEASE | 情绪缓和后 → 温和追问原因 |
| PROBLEM_EXPLORATION | 找到原因后 → 追问解法 |
| COGNITIVE_REFLECTION | 反思出原因后 → 追问解法并确认步骤 |
| ACTION_BLOCK | 阻力分析出原因 → 记录到原因库 |
| FAILURE_REVIEW | 归因后 → 记录到原因库，方法修正记录到方法库 |

### 存储时机

- 对话中发现"原因" → dispatch Memory Agent 写入原因库
- 对话中发现"方法" → dispatch Memory Agent 写入方法库
- 同时建立双向链接

## 3. 各文件联动调整

### 数据层

- 删除：`cognitive-db/` 下 8 个旧文件
- 新建：`cognitive-db/why-reasons.md` + `cognitive-db/how-methods.md`

### Skills 层

| 文件 | 调整内容 |
|------|---------|
| cognitive.md | 对话引导原则加入 5 条 why/how 规则；EMOTION_RELEASE 增加温和追问；存储目标改为 why-reasons + how-methods |
| cognitive-analyze.md | 分析模式聚焦原因+方法；输出目标改为原因库/方法库 |
| cognitive-record.md | 快速记录也引导追问原因；存储目标改为 why-reasons |
| cognitive-review.md | 复盘从原因库和方法库提取数据；归因→原因库，方法修正→方法库 |
| cognitive-db.md | 查询命令适配新库（why-reasons / how-methods） |
| cognitive-dashboard.md | 仪表盘适配新库（原因库统计 + 方法库统计） |
| cognitive-check.md | 检查命令读取新库文件 |

### Agents 层

| 文件 | 调整内容 |
|------|---------|
| memory-agent.md | extract-pattern 改为写入 why-reasons / how-methods；新增 extract-reason 和 extract-method 操作类型 |
| cognitive-agent.md | TEBAR 分析后产出原因（写入 why-reasons）；分析阻力产出原因 |
| reflection-agent.md | 顿悟/方法论写入 how-methods；milestone-detection 中成功实验的方法提炼到方法库 |
| action-agent.md | 成功行动的方法提炼到 how-methods；阻力分析发现的信念关联到原因库 |
| pattern-detector.md | deep-confirm 的写入目标从 cognitive-patterns.md 改为 why-reasons.md；确认的模式作为"卡住原因"写入（reason_type: stuck），TEBAR 因果链 → 原因分析，中断策略 → 关联方法 |
| sentinel-agent.md | 读取新库文件（why-reasons + how-methods） |

### Memory Agent 操作类型更新

旧操作类型：`store-short-term`, `promote-long-term`, `update-profile`, `extract-pattern`

新操作类型：
- `store-short-term` — 不变
- `promote-long-term` — 不变
- `update-profile` — 不变
- `extract-reason` — 从对话中提炼原因，写入 why-reasons
- `extract-method` — 从对话中提炼方法，写入 how-methods
- 删除 `extract-pattern`（功能被 extract-reason 和 extract-method 替代）

### 项目记忆更新

更新 `project-cognitive-os.md` 中的：
- 认知数据库文件列表（8 → 2）
- Memory Agent 操作类型
- 关键决策
