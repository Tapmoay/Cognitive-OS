---
description: 组装个人规律与策略 — 把散落的原因和方法整理成下次能用的东西
---

# 组装个人规律与策略

你帮助用户把散落的原因和方法，整理成下次能直接调用的**个人规律**和**个人策略**。

## 什么时候用这个命令

用户主动调用，或者对话中积累到阈值时自动提议（主流程追问规则第6条）。

也可以在对话中直接触发，不必切换命令——当 AI 发现同类原因/方法积累 ≥3 条，自然提议："我发现你总是[模式]，要不要把它整理一下，下次直接用？"

## 核心概念

**个人规律**（存储在 `cognitive-db/cognitive-models/`）：
关于自己的可复用认知规律——"我发现我总是..."

例如："我发现我总是在被评价时先退缩，因为我认为评价=否定我这个人"

**个人策略**（存储在 `cognitive-db/decision-frameworks/`）：
下次遇到类似情况可直接调用的步骤——"下次遇到X，我按这个步骤来"

例如："下次被评价时：1.先暂停3秒 → 2.区分评价和我这个人 → 3.只回应评价内容 → 4.结束后复盘"

## 构建流程

### 1. 数据盘点

读取认知数据库，按类别统计：
- `cognitive-db/why-reasons/` — 同类原因有多少条
- `cognitive-db/how-methods/` — 同类方法有多少条
- `cognitive-db/events/` — 关联事件（如存在）

### 2. 发现规律

找出同类条目的共性：
- 同一 reason_type 的 why-reasons → 共同的触发条件和因果链
- 同一 method_type 的 how-methods → 共同的解决步骤

向用户展示发现，用用户能理解的语言：
"我发现你在 [类别] 方面积累了 [N] 条记录，它们有一个共同点——[用一句话总结]。要不要把它整理成你的个人规律，下次直接用？"

### 3. 组装个人规律

用户同意后，dispatch Reflection Agent：

使用 Agent tool，subagent_type 为 "reflection-agent"，prompt：
```
分析类型: build-cognitive-model

原因条目:
[列出同类 why-reasons 条目的摘要]

方法条目:
[列出关联的 how-methods 条目的摘要]

用户上下文:
[用户画像摘要]

要求: 用用户能理解的语言输出，避免学术术语。规律名称应该是用户会说的话，例如"我总是先退缩"而不是"回避冲突行为模式"。
```

Reflection Agent 输出结构化的个人规律内容。由本命令负责 dispatch Memory Agent 写入文件到 `cognitive-db/cognitive-models/`。

命名规则：`YYYY-MM-DD-{规律名称}.md`

### 4. 组装个人策略（如果有关联方法）

如果个人规律关联了 how-methods 条目，继续组装个人策略：

dispatch Reflection Agent：

使用 Agent tool，subagent_type 为 "reflection-agent"，prompt：
```
分析类型: build-decision-framework

方法条目:
[列出同类 how-methods 条目的摘要]

关联的个人规律:
[列出刚组装的个人规律]

用户上下文:
[用户画像摘要]

要求: 策略步骤应该是用户能直接执行的，每步一个具体动作，不要抽象原则。例如"暂停3秒"而不是"调整心态"。
```

Reflection Agent 输出结构化的个人策略内容。由本命令负责 dispatch Memory Agent 写入文件到 `cognitive-db/decision-frameworks/`。

命名规则：`YYYY-MM-DD-{策略名称}.md`

### 5. 确认与存储

- 向用户展示组装结果，征求确认或修改
- 确认后由本命令 dispatch Memory Agent 写入文件
- 由本命令 dispatch Memory Agent 更新 user-profile.md 的个人规律字段（双链引用）
- 由本命令更新 source_reasons / source_methods 双链

### 6. 阶段评估触发

组装完成后，检查是否触发进化阶段变化：
- 如果用户首次组装个人规律 → 可能从"思考者"晋升为"构建者"
- dispatch Reflection Agent（stage-assessment）确认

## 参数

$ARGUMENTS — 可选，指定要整理的类别（如"情绪"、"冲突"），留空则自动盘点
