# Cognitive DB Redesign + Conversation Behavior Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor cognitive database from 8 files to 2 (why-reasons + how-methods), and add why/how inquiry guidance to all conversation skills and agents.

**Architecture:** Replace 8 cognitive-db files with 2 purpose-driven files. Update all 7 skills and 6 agents to reference new files and add "追问为什么/怎么解决" conversation guidance. Memory Agent gains 2 new operation types (extract-reason, extract-method) replacing extract-pattern.

**Tech Stack:** Markdown files (Obsidian vault), Claude Code skills/agents

---

### Task 1: Data Layer — Delete Old Files, Create New

**Files:**
- Delete: `cognitive-db/cognitive-patterns.md`
- Delete: `cognitive-db/thinking-patterns.md`
- Delete: `cognitive-db/reusable-rules.md`
- Delete: `cognitive-db/methodology-abstraction.md`
- Delete: `cognitive-db/problem-decomposition.md`
- Delete: `cognitive-db/failure-review.md`
- Delete: `cognitive-db/judgment-logic.md`
- Delete: `cognitive-db/decision-paths.md`
- Create: `cognitive-db/why-reasons.md`
- Create: `cognitive-db/how-methods.md`

- [ ] **Step 1: Delete 8 old cognitive-db files**

Delete all 8 files under `cognitive-db/`. They are empty templates (entry_count: 0) with no data to preserve.

- [ ] **Step 2: Create why-reasons.md**

Write `cognitive-db/why-reasons.md`:

```markdown
---
type: cognitive-db-index
category: why-reasons
last_updated: 2026-05-17
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

- [ ] **Step 3: Create how-methods.md**

Write `cognitive-db/how-methods.md`:

```markdown
---
type: cognitive-db-index
category: how-methods
last_updated: 2026-05-17
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

- [ ] **Step 4: Verify new files exist**

Run: `ls cognitive-db/`
Expected: only `why-reasons.md` and `how-methods.md`

---

### Task 2: Update Memory Agent

**Files:**
- Modify: `C:\Users\Optimistic\.claude\agents\memory-agent.md`

- [ ] **Step 1: Replace extract-pattern with extract-reason and extract-method**

In `memory-agent.md`, replace the `### 4. 认知模式提炼` section (lines 131-162) with:

```markdown
### 4. 原因提炼

从对话内容中提炼原因（为什么难过/失败/卡住），写入原因库。

**追加规则**:
- 读取 `cognitive-db/why-reasons.md`
- 在"条目列表"部分追加新条目
- 更新 frontmatter 中的 entry_count 和 last_updated
- 新条目使用完整 YAML frontmatter + Markdown 正文格式

**条目格式**:
```markdown
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
[当...时]

### 原因分析
[为什么会产生这种情绪/失败/卡住]

### 涉及的信念
- [[信念1]]

### 关联的解决方法
- [[方法1]]（如果已知）

### 证据记录
- [YYYY-MM-DD]: [场景摘要]
```

**双链规则**:
- 原因名称用 `[[双链]]` 包裹
- 涉及的信念用 `[[信念]]` 链接
- 关联的解决方法用 `[[方法名称]]` 链接到方法库

### 5. 方法提炼

从对话内容中提炼可复用的思考方式和方法论，写入方法库。

**追加规则**:
- 读取 `cognitive-db/how-methods.md`
- 在"条目列表"部分追加新条目
- 更新 frontmatter 中的 entry_count 和 last_updated
- 新条目使用完整 YAML frontmatter + Markdown 正文格式

**条目格式**:
```markdown
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
[描述]

### 方法步骤
1. [步骤1]
2. [步骤2]

### 适用场景
- [场景1]

### 来源案例
- [YYYY-MM-DD]: [案例摘要]

### 效果记录
- [YYYY-MM-DD]: [效果评价]（如有）
```

**双链规则**:
- 方法名称用 `[[双链]]` 包裹
- 适用原因用 `[[原因名称]]` 链接到原因库
- tags 字段添加结构化标签：`#method/[thinking|behavior|coping]`
```

- [ ] **Step 2: Update input format section**

In `memory-agent.md`, replace the input format section (around line 165-170):

Old:
```markdown
你将收到一段对话内容和操作指令。指令可能是：
- `store-short-term` — 存入短期记忆
- `promote-long-term` — 升级为长期记忆
- `update-profile` — 更新用户画像
- `extract-pattern` — 提炼认知模式到 cognitive-db
```

New:
```markdown
你将收到一段对话内容和操作指令。指令可能是：
- `store-short-term` — 存入短期记忆
- `promote-long-term` — 升级为长期记忆
- `update-profile` — 更新用户画像
- `extract-reason` — 提炼原因到 why-reasons
- `extract-method` — 提炼方法到 how-methods
```

---

### Task 3: Update Cognitive Agent + Reflection Agent

**Files:**
- Modify: `C:\Users\Optimistic\.claude\agents\cognitive-agent.md`
- Modify: `C:\Users\Optimistic\.claude\agents\reflection-agent.md`

- [ ] **Step 1: Update cognitive-agent.md reading context**

In `cognitive-agent.md`, replace the "读取上下文" section (lines 100-107):

Old:
```markdown
## 读取上下文

分析前，读取以下文件获取上下文：
- `memory/user-profile.md` — 用户画像
- `memory/short-term/` 最近的文件 — 近期状态
- `memory/long-term/` — 历史模式
- `cognitive-db/cognitive-patterns.md` — 已识别的认知模式
- `cognitive-db/thinking-patterns.md` — 已识别的思维模式
```

New:
```markdown
## 读取上下文

分析前，读取以下文件获取上下文：
- `memory/user-profile.md` — 用户画像
- `memory/short-term/` 最近的文件 — 近期状态
- `memory/long-term/` — 历史模式
- `cognitive-db/why-reasons.md` — 已识别的原因
- `cognitive-db/how-methods.md` — 已有的方法
```

- [ ] **Step 2: Update cognitive-agent.md output suggestions**

In `cognitive-agent.md`, replace the "建议存入 cognitive-db 时的双链和标签" section (lines 123-130):

Old:
```markdown
**建议存入 cognitive-db 时的双链和标签**:
- 条目标题用 `[[双链]]` 包裹
- 关联模式用 `[[模式名称]]` 链接
- tags 中添加结构化标签：
  - 问题拆解：`#decomposition/[类别]`
  - 判断逻辑：`#judgment/[类别]`
  - 认知模式：`#pattern/[模式名]`
  - 思维模式：`#thinking/[模式名]`
```

New:
```markdown
**建议存入 cognitive-db 时的双链和标签**:
- 条目标题用 `[[双链]]` 包裹
- 关联原因用 `[[原因名称]]` 链接
- 关联方法用 `[[方法名称]]` 链接
- tags 中添加结构化标签：
  - 原因：`#reason/[emotion|failure|stuck]`
  - 方法：`#method/[thinking|behavior|coping]`
```

- [ ] **Step 3: Update reflection-agent.md reading context**

In `reflection-agent.md`, replace the "读取上下文" section (lines 133-141):

Old:
```markdown
## 读取上下文

分析前，读取：
- `memory/user-profile.md`
- `memory/short-term/` 最近的文件
- `memory/long-term/` — 历史模式
- `cognitive-db/failure-review.md` — 已有的复盘记录
- `cognitive-db/methodology-abstraction.md` — 已有的方法论
- `cognitive-db/reusable-rules.md` — 已有的规律
- `memory/growth-log.md` — 成长轨迹（阶段评估 + 里程碑）
```

New:
```markdown
## 读取上下文

分析前，读取：
- `memory/user-profile.md`
- `memory/short-term/` 最近的文件
- `memory/long-term/` — 历史模式
- `cognitive-db/why-reasons.md` — 已有的原因
- `cognitive-db/how-methods.md` — 已有的方法
- `memory/growth-log.md` — 成长轨迹（阶段评估 + 里程碑）
```

- [ ] **Step 4: Update reflection-agent.md milestone-detection references**

In `reflection-agent.md`, line 117:

Old:
```markdown
在 `methodology-abstraction` 或 `failure-review` 分析过程中，检测以下里程碑：
```

New:
```markdown
在方法提炼或失败复盘分析过程中，检测以下里程碑：
```

---

### Task 4: Update Action Agent + Pattern Detector

**Files:**
- Modify: `C:\Users\Optimistic\.claude\agents\action-agent.md`
- Modify: `C:\Users\Optimistic\.claude\agents\pattern-detector.md`

- [ ] **Step 1: Update action-agent.md success handling**

In `action-agent.md`, lines 114-116:

Old:
```markdown
- 提炼方法论 → dispatch Memory Agent 写入 `cognitive-db/methodology-abstraction.md`
- 提炼验证的规律 → dispatch Memory Agent 写入 `cognitive-db/reusable-rules.md`
```

New:
```markdown
- 提炼方法 → dispatch Memory Agent 写入 `cognitive-db/how-methods.md`（操作: extract-method）
```

- [ ] **Step 2: Update pattern-detector.md deep-confirm reading**

In `pattern-detector.md`, line 101:

Old:
```markdown
   - 读取 `cognitive-db/cognitive-patterns.md` 已有模式
```

New:
```markdown
   - 读取 `cognitive-db/why-reasons.md` 已有原因
```

- [ ] **Step 3: Update pattern-detector.md deep-confirm writing target**

In `pattern-detector.md`, replace the "3. **写入 cognitive-db**" section (lines 123-127):

Old:
```markdown
3. **写入 cognitive-db**

   对确认的模式：
   - 读取 `cognitive-db/cognitive-patterns.md`
   - 新增或更新模式条目（格式见 cognitive-patterns.md 模板）
   - 更新 frontmatter 中的 entry_count 和 last_updated
```

New:
```markdown
3. **写入 cognitive-db**

   对确认的模式，作为"卡住原因"写入原因库：
   - 读取 `cognitive-db/why-reasons.md`
   - 新增或更新原因条目，reason_type: stuck
   - TEBAR 因果链 → 原因分析
   - 中断策略 → 关联的解决方法
   - 关联信念 → 涉及的信念
   - 更新 frontmatter 中的 entry_count 和 last_updated
```

- [ ] **Step 4: Update pattern-detector.md deep-confirm task 3**

In `pattern-detector.md`, line 119:

Old:
```markdown
   - 对比 `cognitive-db/cognitive-patterns.md` 已有模式
```

New:
```markdown
   - 对比 `cognitive-db/why-reasons.md` 已有原因
```

---

### Task 5: Update Sentinel Agent

**Files:**
- Modify: `C:\Users\Optimistic\.claude\agents\sentinel-agent.md`

- [ ] **Step 1: Update sentinel-agent.md reading scope for full mode**

In `sentinel-agent.md`, replace the "full 额外读取" section (lines 41-43):

Old:
```markdown
**full 额外读取**：
- `memory/long-term/`
- `cognitive-db/cognitive-patterns.md`
- `cognitive-db/thinking-patterns.md`
```

New:
```markdown
**full 额外读取**：
- `memory/long-term/`
- `cognitive-db/why-reasons.md`
- `cognitive-db/how-methods.md`
```

- [ ] **Step 2: Update sentinel-agent.md suggestion rule**

In `sentinel-agent.md`, line 83:

Old:
```markdown
- 如果有活跃模式（cognitive-patterns.md 中 frequency 较高的模式）→ "今天可以试试 [基于模式中断策略的微行动]"
```

New:
```markdown
- 如果有活跃原因（why-reasons.md 中 frequency 较高的原因）→ "今天可以试试 [基于原因关联方法的微行动]"
```

---

### Task 6: Update cognitive.md (Main Skill)

**Files:**
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive.md`

- [ ] **Step 1: Add why/how inquiry guidance rules**

After the "## 对话引导原则" section (after line 249), add a new section:

```markdown
## 追问引导规则

对话中主动引导用户追问"为什么"和"怎么解决"：

1. **情绪表达 → 追问原因**：用户说"很难受" → "你觉得是什么让你这么难受？"
2. **失败描述 → 追问原因**：用户说"又搞砸了" → "你觉得这次和上次比，问题出在哪里？"
3. **卡住描述 → 追问原因**：用户说"总是卡在这里" → "你觉得是什么让你一直走不出来？"
4. **找到原因 → 追问解法**：识别出原因后 → "以前有没有类似的情况？当时是怎么走出来的？"
5. **找到解法 → 确认步骤**：用户说出解法 → "能不能把步骤理一下？下次可以直接用。"

### 追问时机

| 状态 | 追问行为 |
|------|---------|
| ENTRY_RECORD | 如果有情绪词 → 追问原因 |
| EMOTION_RELEASE | intensity ≤7 时共情后温和追问原因；intensity ≥8 时只共情 |
| PROBLEM_EXPLORATION | 找到原因后 → 追问解法 |
| COGNITIVE_REFLECTION | 反思出原因后 → 追问解法并确认步骤 |
| ACTION_BLOCK | 阻力分析出原因 → 记录到原因库 |
| FAILURE_REVIEW | 归因后 → 记录到原因库，方法修正记录到方法库 |
```

- [ ] **Step 2: Update emotion container to add gentle inquiry**

In `cognitive.md`, replace the emotion container section (lines 255-269):

Old:
```markdown
## 情绪容器模式

当检测到 EMOTION_RELEASE 时，激活情绪容器：

1. **只共情，不引导**
   - "听起来你现在很难受"
   - "这种感觉确实很痛苦"
   - 不问"为什么"，不给建议

2. **帮助落地**（如果需要）
   - "你现在在哪里？"
   - "周围有什么你能看到的东西？"

3. **等待降温**
   - 不急于进入任何分析模式
   - 等用户情绪缓和后再判断是否调整策略
```

New:
```markdown
## 情绪容器模式

当检测到 EMOTION_RELEASE 时，激活情绪容器：

1. **先共情**
   - "听起来你现在很难受"
   - "这种感觉确实很痛苦"
   - 不问"为什么"，不给建议

2. **帮助落地**（如果需要）
   - "你现在在哪里？"
   - "周围有什么你能看到的东西？"

3. **温和追问**（情绪缓和后，intensity ≤7 时）
   - "你觉得是什么让你这么难受？"
   - 不追问"为什么你会有这种感觉"（太分析性）
   - 只问"是什么让你..."（描述性，压力更小）

4. **等待降温**（intensity ≥8 时）
   - 不急于进入任何分析模式
   - 等用户情绪缓和后再判断是否调整策略
```

- [ ] **Step 3: Update storage targets**

In `cognitive.md`, replace the "## 存储" section (lines 285-298):

Old:
```markdown
## 存储

每次对话结束后（或重要节点），dispatch Memory Agent：
- 存储对话摘要到短期记忆
- 如果发现用户画像信息变化，更新 user-profile.md
- 如果检测到重复模式，考虑升级为长期记忆
- 如果产生了微行动/实验/反馈，dispatch Action Agent 存储到 actions/

### Action Layer 数据连接

- 行为实验成功 → 提炼的方法论写入 `cognitive-db/methodology-abstraction.md`
- 阻力分析发现的信念 → 写入 `cognitive-db/judgment-logic.md`
- 反馈闭环验证的规律 → 写入 `cognitive-db/reusable-rules.md`
- Pattern Detector 检测到的模式 → 写入 `cognitive-db/cognitive-patterns.md`
```

New:
```markdown
## 存储

每次对话结束后（或重要节点），dispatch Memory Agent：
- 存储对话摘要到短期记忆
- 如果发现用户画像信息变化，更新 user-profile.md
- 如果检测到重复模式，考虑升级为长期记忆
- 如果发现了原因 → dispatch Memory Agent（extract-reason）写入 `cognitive-db/why-reasons.md`
- 如果发现了方法 → dispatch Memory Agent（extract-method）写入 `cognitive-db/how-methods.md`
- 如果产生了微行动/实验/反馈，dispatch Action Agent 存储到 actions/

### 数据连接

- 行为实验成功 → 提炼的方法写入 `cognitive-db/how-methods.md`
- 阻力分析发现的信念 → 关联到 `cognitive-db/why-reasons.md` 的涉及信念
- Pattern Detector 检测到的模式 → 写入 `cognitive-db/why-reasons.md`（reason_type: stuck）
- 反馈闭环验证的方法 → 写入 `cognitive-db/how-methods.md`
```

- [ ] **Step 4: Update Pattern Engine deep-confirm prompt**

In `cognitive.md`, the Pattern Engine deep-confirm prompt section (around lines 29-35):

Old:
```markdown
使用 Agent tool，subagent_type 为 "pattern-detector"，prompt：
```
mode: deep-confirm

扫描 memory/short-term/ 中所有 suspected_pattern: true 的文件。
读取 memory/long-term/ 和 cognitive-db/cognitive-patterns.md 作为已知模式。
确认或否定疑似模式，生成 TEBAR 因果链，更新 cognitive-db。
```
```

New:
```markdown
使用 Agent tool，subagent_type 为 "pattern-detector"，prompt：
```
mode: deep-confirm

扫描 memory/short-term/ 中所有 suspected_pattern: true 的文件。
读取 memory/long-term/ 和 cognitive-db/why-reasons.md 作为已知原因。
确认或否定疑似模式，生成 TEBAR 因果链，将确认的模式作为原因写入 why-reasons.md。
```
```

---

### Task 7: Update cognitive-analyze.md + cognitive-record.md

**Files:**
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive-analyze.md`
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive-record.md`

- [ ] **Step 1: Update cognitive-analyze.md reading context**

In `cognitive-analyze.md`, line 19:

Old:
```markdown
3. 读取 `cognitive-db/cognitive-patterns.md` 和 `cognitive-db/thinking-patterns.md` — 已有模式
```

New:
```markdown
3. 读取 `cognitive-db/why-reasons.md` 和 `cognitive-db/how-methods.md` — 已有原因和方法
```

- [ ] **Step 2: Update cognitive-analyze.md storage step**

In `cognitive-analyze.md`, replace the "### 第五步：存储" section (lines 89-105):

Old:
```markdown
### 第五步：存储

dispatch Memory Agent 将分析结果存入 cognitive-db：

使用 Agent tool，subagent_type 为 "memory-agent"，prompt：

```
操作: extract-pattern

分析结果:
[分析摘要]

存入类别: [problem-decomposition / judgment-logic / decision-paths / cognitive-patterns / thinking-patterns]

条目内容:
[结构化的条目内容，含 YAML frontmatter]
```

同时存储本次对话到短期记忆。
```

New:
```markdown
### 第五步：存储

dispatch Memory Agent 将分析结果存入原因库和方法库：

**如果分析发现了原因**：

使用 Agent tool，subagent_type 为 "memory-agent"，prompt：

```
操作: extract-reason

分析结果:
[原因摘要]

原因类型: [emotion|failure|stuck]

触发场景: [当...时]

涉及的信念: [从分析中提取]

关联的解决方法: [如果已知]
```

**如果分析产生了方法**：

使用 Agent tool，subagent_type 为 "memory-agent"，prompt：

```
操作: extract-method

分析结果:
[方法摘要]

方法类型: [thinking|behavior|coping]

解决什么问题: [描述]

方法步骤: [步骤列表]

适用原因: [关联到原因库中的条目]
```

同时存储本次对话到短期记忆。
```

- [ ] **Step 3: Update cognitive-analyze.md link check step**

In `cognitive-analyze.md`, replace the "### 第六步：关联检查" section (lines 107-112):

Old:
```markdown
### 第六步：关联检查

检查分析结果是否与已有模式相关：
- 读取 `cognitive-db/cognitive-patterns.md`
- 如果与已有模式关联，更新 related_patterns 字段
- 如果是全新的模式，添加到认知模式
```

New:
```markdown
### 第六步：关联检查

检查分析结果是否与已有原因或方法相关：
- 读取 `cognitive-db/why-reasons.md` 和 `cognitive-db/how-methods.md`
- 如果与已有原因关联，更新 related_methods 字段
- 如果与已有方法关联，更新 applicable_reasons 字段
- 如果是全新的原因或方法，添加新条目
```

- [ ] **Step 4: Update cognitive-record.md emotion container**

In `cognitive-record.md`, replace the "## 情绪容器模式" section (lines 71-79):

Old:
```markdown
## 情绪容器模式

当检测到情绪强度 ≥7 时：

1. **只做共情**：确认和接纳情绪
2. **不引导分析**：不问"为什么"
3. **帮助落地**：如果需要，问"现在你在哪里？周围有什么？"
4. **存储但标注**：dispatch Memory Agent 存储，标注 `intensity: N/10`（N≥7）
5. **等待情绪降温**：用户情绪缓和后再考虑是否引导
```

New:
```markdown
## 情绪容器模式

当检测到情绪强度 ≥7 时：

1. **先做共情**：确认和接纳情绪
2. **不引导分析**：不问"为什么"（intensity ≥8 时）
3. **帮助落地**：如果需要，问"现在你在哪里？周围有什么？"
4. **温和追问**：intensity ≤7 且情绪缓和后，可温和追问"你觉得是什么让你这么难受？"
5. **存储但标注**：dispatch Memory Agent 存储，标注 `intensity: N/10`（N≥7）
6. **等待情绪降温**：intensity ≥8 时，用户情绪缓和后再考虑是否引导
```

- [ ] **Step 5: Add why/how inquiry to cognitive-record.md**

In `cognitive-record.md`, after the "### 第二步：简单引导" section (after line 35), add:

```markdown
### 追问引导（情绪强度 <7 时）

如果用户表达了情绪或困难，温和追问原因：
- "你觉得是什么让你这么难受？"（而非"你为什么难受"）
- "这种感觉好像不是第一次了？"
- 如果用户说出原因 → "以前有没有遇到过？当时是怎么过来的？"
- 如果用户说出解法 → "能简单说下步骤吗？下次可以直接用。"

追问后发现的原因或方法 → dispatch Memory Agent（extract-reason / extract-method）存入 cognitive-db。
```

---

### Task 8: Update cognitive-review.md + cognitive-db.md + cognitive-dashboard.md + cognitive-check.md

**Files:**
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive-review.md`
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive-db.md`
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive-dashboard.md`
- Modify: `d:\AProjects\CSystem\os\.claude\commands\cognitive-check.md`

- [ ] **Step 1: Update cognitive-review.md reading context**

In `cognitive-review.md`, replace lines 18-19:

Old:
```markdown
4. 读取 `cognitive-db/failure-review.md` — 已有的复盘
5. 读取 `cognitive-db/methodology-abstraction.md` — 已有的方法论
```

New:
```markdown
4. 读取 `cognitive-db/why-reasons.md` — 已有的原因
5. 读取 `cognitive-db/how-methods.md` — 已有的方法
```

- [ ] **Step 2: Update cognitive-review.md storage step**

In `cognitive-review.md`, replace the "### 第六步：存储" section (lines 89-119):

Old:
```markdown
### 第六步：存储

dispatch Memory Agent 存储复盘结果：

使用 Agent tool，subagent_type 为 "memory-agent"，prompt：

```
操作: extract-pattern

分析结果:
[复盘摘要]

存入类别: failure-review

条目内容:
[结构化的复盘条目，含 YAML frontmatter]
```

如果复盘产生了新的方法论，同时存储：

```
操作: extract-pattern

分析结果:
[方法论摘要]

存入类别: methodology-abstraction

条目内容:
[结构化的方法论条目]
```

同时存储本次对话到短期记忆。
```

New:
```markdown
### 第六步：存储

dispatch Memory Agent 存储复盘结果：

**归因 → 原因库**：

使用 Agent tool，subagent_type 为 "memory-agent"，prompt：

```
操作: extract-reason

分析结果:
[归因摘要]

原因类型: failure

触发场景: [当...时]

涉及的信念: [从归因分析中提取]
```

**方法修正 → 方法库**（如果复盘产生了方法修正）：

使用 Agent tool，subagent_type 为 "memory-agent"，prompt：

```
操作: extract-method

分析结果:
[方法摘要]

方法类型: [thinking|behavior|coping]

解决什么问题: [描述]

方法步骤: [修正后的步骤]

适用原因: [关联到原因库中的条目]
```

同时存储本次对话到短期记忆。
```

- [ ] **Step 3: Update cognitive-review.md stage assessment reference**

In `cognitive-review.md`, line 149:

Old:
```markdown
认知资产统计:
[从 cognitive-db 各文件提取 entry_count]
```

New:
```markdown
认知资产统计:
[从 cognitive-db/why-reasons.md 和 cognitive-db/how-methods.md 提取 entry_count]
```

- [ ] **Step 4: Update cognitive-db.md query targets**

In `cognitive-db.md`, replace lines 29-37:

Old:
```markdown
### 认知数据库（8 个类别）
- 问题拆解: `cognitive-db/problem-decomposition.md`
- 失败复盘: `cognitive-db/failure-review.md`
- 判断逻辑: `cognitive-db/judgment-logic.md`
- 方法论抽象: `cognitive-db/methodology-abstraction.md`
- 决策路径: `cognitive-db/decision-paths.md`
- 认知模式: `cognitive-db/cognitive-patterns.md`
- 思维模式: `cognitive-db/thinking-patterns.md`
- 可复用规律: `cognitive-db/reusable-rules.md`
```

New:
```markdown
### 认知数据库（2 个类别）
- 原因库: `cognitive-db/why-reasons.md` — 为什么难过/失败/卡住
- 方法库: `cognitive-db/how-methods.md` — 怎么解决的思考方式和方法论
```

- [ ] **Step 5: Update cognitive-db.md category shortcuts**

In `cognitive-db.md`, line 60:

Old:
```markdown
- 认知数据库类别：decomposition, review, judgment, methodology, decisions, patterns, thinking, rules
```

New:
```markdown
- 认知数据库类别：reasons, methods
```

- [ ] **Step 6: Update cognitive-dashboard.md data sources**

In `cognitive-dashboard.md`, replace the data source list (lines 10-16):

Old:
```markdown
5. `cognitive-db/cognitive-patterns.md` — 认知模式
6. `cognitive-db/thinking-patterns.md` — 思维模式
7. `cognitive-db/reusable-rules.md` — 可复用规律
8. `cognitive-db/methodology-abstraction.md` — 方法论
9. `cognitive-db/problem-decomposition.md` — 问题拆解
10. `cognitive-db/failure-review.md` — 失败复盘
11. `cognitive-db/judgment-logic.md` — 判断逻辑
12. `cognitive-db/decision-paths.md` — 决策路径
```

New:
```markdown
5. `cognitive-db/why-reasons.md` — 原因库
6. `cognitive-db/how-methods.md` — 方法库
```

- [ ] **Step 7: Update cognitive-dashboard.md dashboard template**

In `cognitive-dashboard.md`, replace the dashboard template sections for cognitive data (lines 57-76):

Old:
```markdown
## 活跃认知模式
- [[模式1]] — 出现 [N] 次，最近 [日期]
- [[模式2]] — 出现 [N] 次，最近 [日期]

（如果 cognitive-patterns 无条目，显示"尚无识别的模式"）

## 待跟进行动
- [ ] [微行动描述]（[日期] 生成，状态：pending）
- [ ] [实验描述]（[日期]，状态：running）

（如果无待跟进行动，显示"所有行动已完成"）

## 认知资产统计
- 问题拆解：[N] 条
- 失败复盘：[N] 条
- 判断逻辑：[N] 条
- 方法论：[N] 条
- 决策路径：[N] 条
- 认知模式：[N] 条
- 思维模式：[N] 条
- 可复用规律：[N] 条
```

New:
```markdown
## 活跃原因
- [[原因1]]（#reason/[类别]）— 出现 [N] 次，最近 [日期]
- [[原因2]]（#reason/[类别]）— 出现 [N] 次，最近 [日期]

（如果 why-reasons 无条目，显示"尚无识别的原因"）

## 已有方法
- [[方法1]]（#method/[类别]）— 解决 [[原因1]]
- [[方法2]]（#method/[类别]）— 解决 [[原因2]]

（如果 how-methods 无条目，显示"尚无提炼的方法"）

## 待跟进行动
- [ ] [微行动描述]（[日期] 生成，状态：pending）
- [ ] [实验描述]（[日期]，状态：running）

（如果无待跟进行动，显示"所有行动已完成"）

## 认知资产统计
- 原因：[N] 条
- 方法：[N] 条
```

- [ ] **Step 8: Update cognitive-check.md data sources**

In `cognitive-check.md`, line 26:

Old:
```markdown
5. `cognitive-db/` 全部 8 个文件
```

New:
```markdown
5. `cognitive-db/why-reasons.md` 和 `cognitive-db/how-methods.md`
```

---

### Task 9: Update Project Memory

**Files:**
- Modify: `C:\Users\Optimistic\.claude\projects\d--AProjects-CSystem-os\memory\project-cognitive-os.md`

- [ ] **Step 1: Update cognitive-db file list**

In `project-cognitive-os.md`, replace line 43:

Old:
```markdown
- `cognitive-db/` — 8 个认知数据库文件
```

New:
```markdown
- `cognitive-db/why-reasons.md` — 原因库（情绪/失败/卡住原因）
- `cognitive-db/how-methods.md` — 方法库（可复用的思考方式和方法论）
```

- [ ] **Step 2: Update Memory Agent operation types**

In `project-cognitive-os.md`, line 64:

Old:
```markdown
- **Memory Agent 操作类型**：store-short-term, promote-long-term, update-profile, extract-pattern
```

New:
```markdown
- **Memory Agent 操作类型**：store-short-term, promote-long-term, update-profile, extract-reason, extract-method
```

- [ ] **Step 3: Add key decision about db redesign**

After the last key decision (line 76), add:

```markdown
- **认知数据库重构**：8 文件精简为 2 文件（why-reasons + how-methods），核心定位从认知科学分类改为实用目的分类（原因+方法）
- **对话行为优化**：5 条追问引导规则（why/how），EMOTION_RELEASE 增加温和追问（intensity ≤7），Memory Agent 操作类型从 extract-pattern 拆分为 extract-reason + extract-method
```

- [ ] **Step 4: Update design doc list**

In `project-cognitive-os.md`, after line 55:

Old:
```markdown
`docs/superpowers/specs/2026-05-16-sentinel-proactive-design.md` — Sentinel 主动推送 设计（已实现）
```

Add after it:

```markdown
`docs/superpowers/specs/2026-05-17-cognitive-db-redesign-design.md` — 认知数据库重构+对话行为优化 设计（已实现）
```
