# Visualization + Growth Trajectory Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add three-layer visualization to Cognitive OS — wikilinks/tags in existing files, a dashboard skill, and growth trajectory tracking.

**Architecture:** Layer 1 updates existing Agent write rules to include `[[双链]]` and structured tags. Layer 2 adds a new `/cognitive-dashboard` skill that reads all vault data and generates `dashboard.md`. Layer 3 adds `memory/growth-log.md` and updates Reflection Agent for stage assessments + milestone detection.

**Tech Stack:** Claude Code skills (`.claude/commands/`), Agents (`~/.claude/agents/`), Obsidian vault (Markdown + YAML frontmatter)

---

## File Structure

| File | Action | Responsibility |
|------|--------|---------------|
| `~/.claude/agents/memory-agent.md` | Modify | Add 双链 + tag rules to short-term/long-term/profile write |
| `~/.claude/agents/cognitive-agent.md` | Modify | Add 双链 + tag rules to cognitive-db writes |
| `~/.claude/agents/action-agent.md` | Modify | Add 双链 + tag rules to actions/ writes |
| `~/.claude/agents/reflection-agent.md` | Modify | Add growth-log stage assessment + milestone detection |
| `.claude/commands/cognitive-dashboard.md` | Create | New Dashboard Skill |
| `memory/growth-log.md` | Create | Growth trajectory template |
| `memory/user-profile.md` | Modify | Add 双链 and tag examples |

---

### Task 1: Update Memory Agent — 双链 + 标签写入规则

**Files:**
- Modify: `~/.claude/agents/memory-agent.md`

- [ ] **Step 1: Add 双链 rules to short-term memory write format**

In `memory-agent.md`, after the `## 关键对话摘要` line in the short-term memory format block, add 双链 and tag guidance. Replace the entire short-term memory format block (lines 22-48) with:

```markdown
**格式**:
```markdown
---
type: short-term-memory
date: YYYY-MM-DD
session_id: "YYYY-MM-DD-{descriptor}"
emotion: [主要情绪]
intensity: [1-10]/10
trigger: "[触发事件]"
core_belief: "[核心信念]"
current_problem: "[当前问题]"
status: active
tags: [#emotion/[情绪], #pattern/[模式], #belief/[信念], ...]
suspected_pattern: [true|false]
pattern_confidence: [high|low]
pattern_dimensions: [trigger, emotion, belief]
---

## 当前情绪
[描述]

## 最近事件
- [事件1]

## 关键对话摘要
识别到 [[核心信念]] 信念，关联模式 [[认知模式名称]]
```

**双链规则**:
- 在"关键对话摘要"中，用 `[[信念名称]]` 链接核心信念，用 `[[模式名称]]` 链接认知模式
- 信念名称从 TEBAR 分析的 belief 环节提取
- 模式名称从 Pattern Engine 确认的模式或 cognitive-db 中已有模式提取

**标签规则**:
- `tags` 字段必须包含结构化标签，格式：`#category/值`
- 情绪类：`#emotion/[情绪]`（如 `#emotion/焦虑`、`#emotion/低落`）
- 模式类：`#pattern/[模式]`（如 `#pattern/拖延`、`#pattern/完美主义`）
- 信念类：`#belief/[信念]`（如 `#belief/必须一次学好`）
- 至少包含一个情绪标签，其余视内容添加
```

- [ ] **Step 2: Add 双链 rules to long-term memory write format**

In `memory-agent.md`, replace the long-term memory format block (lines 69-95) with:

```markdown
**格式**:
```markdown
---
type: long-term-memory
date: YYYY-MM-DD
first_seen: [首次出现日期]
frequency: [出现次数]
category: recurring-pattern
tags: [#pattern/[模式], #emotion/[情绪], #belief/[信念], ...]
---

## 重复模式：[[模式名称]]

### 触发条件
[描述]，常见触发 [[触发事件名称]]

### 情绪链
[链路描述]

### 核心信念
- [[信念1]]
- [[信念2]]

### 行为模式
[描述]，关联行动 [[行动名称]]
```

**双链规则**:
- 模式名称用 `[[双链]]` 包裹，与 cognitive-db 中对应条目互链
- 核心信念用 `[[信念]]` 链接，与短期记忆和 cognitive-db 中的信念互链
- 触发事件和关联行动用 `[[双链]]` 链接
```

- [ ] **Step 3: Add 双链 rules to user-profile update section**

In `memory-agent.md`, after the "更新规则" list (around line 103-105), add:

```markdown
**双链和标签规则**:
- 恐惧项用 `[[恐惧名称]]` 包裹，并在 tags 中添加 `#fear/[恐惧]`
- 优势项用 `[[优势名称]]` 包裹，并在 tags 中添加 `#strength/[优势]`
- 恐惧被克服时：`~~[[旧恐惧]]~~ ← [日期] 已克服` + 添加 `#growth/里程碑`
```

- [ ] **Step 4: Add 双链 rules to cognitive pattern extraction section**

In `memory-agent.md`, after the "追加规则" list (around line 113-116), add:

```markdown
**双链规则**:
- 提取的认知模式名称用 `[[双链]]` 包裹
- 关联的信念、触发事件用 `[[双链]]` 链接
- tags 字段添加结构化标签：`#pattern/[类别]`
```

- [ ] **Step 5: Commit**

```bash
git add ~/.claude/agents/memory-agent.md
git commit -m "feat: add wikilink + tag rules to memory-agent write format"
```

---

### Task 2: Update Cognitive Agent — 双链 + 标签写入规则

**Files:**
- Modify: `~/.claude/agents/cognitive-agent.md`

- [ ] **Step 1: Add 双链 + tag guidance after TEBAR output format**

In `cognitive-agent.md`, after the TEBAR output format block (after line 35 `breaking_points: [可中断的点]`), add:

```markdown

**双链规则**:
- TEBAR 链中识别的信念用 `[[信念名称]]` 链接
- 模式名称用 `[[模式名称]]` 链接
- 在建议存入 cognitive-db 的条目中标注应使用的双链和标签
```

- [ ] **Step 2: Add 双链 + tag guidance after belief extraction output**

In `cognitive-agent.md`, after the belief output format block (after line 61 `alternative: [替代信念]`), add:

```markdown

**双链规则**:
- surface 和 deep 信念用 `[[信念名称]]` 链接
- 建议标签：`#belief/[信念类别]`（如 `#belief/完美主义`、`#belief/控制欲`）
```

- [ ] **Step 3: Add output format guidance for cognitive-db writes**

In `cognitive-agent.md`, after the "输出格式" section (after line 112), add:

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

- [ ] **Step 4: Commit**

```bash
git add ~/.claude/agents/cognitive-agent.md
git commit -m "feat: add wikilink + tag rules to cognitive-agent output"
```

---

### Task 3: Update Action Agent — 双链 + 标签写入规则

**Files:**
- Modify: `~/.claude/agents/action-agent.md`

- [ ] **Step 1: Add 双链 + tag rules to micro-action write section**

In `action-agent.md`, after the "微行动质量标准" list (around line 34), add:

```markdown

**双链和标签规则**:
- 来源模式用 `[[模式名称]]` 链接
- 切入点关联的信念用 `[[信念名称]]` 链接
- 条目 tags 添加：`#action/pending`（新建时）或 `#action/completed`（完成时）
- 来源模式添加：`#pattern/[模式名]`
```

- [ ] **Step 2: Add 双链 + tag rules to experiment write section**

In `action-agent.md`, after the "实验设计原则" list (around line 51), add:

```markdown

**双链和标签规则**:
- 假设中的信念用 `[[信念名称]]` 链接
- 关联模式用 `[[模式名称]]` 链接
- 条目 tags 添加：`#action/pending`（pending/running）或 `#action/completed`（completed）
```

- [ ] **Step 3: Add 双链 + tag rules to resistance analysis and feedback sections**

In `action-agent.md`, after the "闭环逻辑" section (around line 171), add:

```markdown

**双链和标签规则**:
- 阻力分析中发现的信念用 `[[信念名称]]` 链接
- 反馈中验证的规律用 `[[规律名称]]` 链接到 cognitive-db
- 行动成功时：添加 `#growth/里程碑` 标签到 feedback 记录
- 行动成功时：dispatch Memory Agent 写入 `memory/growth-log.md` 里程碑条目
```

- [ ] **Step 4: Commit**

```bash
git add ~/.claude/agents/action-agent.md
git commit -m "feat: add wikilink + tag rules to action-agent write format"
```

---

### Task 4: Create growth-log.md Template

**Files:**
- Create: `memory/growth-log.md`

- [ ] **Step 1: Write the growth-log.md template**

Create `memory/growth-log.md` with this content:

```markdown
---
type: growth-log
last_updated: 2026-05-16
total_assessments: 0
---

# 认知成长轨迹

## 阶段评估

（尚无评估。Reflection Agent 在 `/cognitive-review` 时自动检查是否需要生成阶段评估。）

## 成长里程碑

（尚无里程碑。当用户克服恐惧、发现新模式、完成行为实验时自动记录。）

## 认知模型演化

| 日期 | 模型变化 |
|------|---------|
```

- [ ] **Step 2: Commit**

```bash
git add memory/growth-log.md
git commit -m "feat: add growth-log.md template"
```

---

### Task 5: Update Reflection Agent — Stage Assessment + Milestone Detection

**Files:**
- Modify: `~/.claude/agents/reflection-agent.md`

- [ ] **Step 1: Add growth-log reading to context section**

In `reflection-agent.md`, after the "读取上下文" list (after line 81), add:

```markdown
- `memory/growth-log.md` — 成长轨迹（阶段评估 + 里程碑）
```

- [ ] **Step 2: Add stage assessment generation section**

In `reflection-agent.md`, after the "方法论格式" block (after line 71), add a new section:

```markdown

### 4. 阶段评估生成（stage-assessment）

当收到 `stage-assessment` 指令时，生成阶段性成长评估。

**生成条件**：距上次评估 ≥7 天（读取 `memory/growth-log.md` 的 last_updated 判断）

**成长阶段定义**:
- 记录者：能记录情绪和事件
- 思考者：能主动反思和发现模式
- 构建者：能设计行动实验并执行
- 主导者：能自主调整认知策略

**评估流程**:
1. 读取 `memory/growth-log.md` 获取上次评估日期和阶段
2. 读取短期记忆（最近7天）和长期记忆，统计变化
3. 读取 cognitive-db 统计认知资产数量变化
4. 读取 actions/ 统计行动完成情况
5. 判断当前成长阶段

**输出格式**:
```markdown
### YYYY-MM 阶段评估
**成长阶段**：[当前阶段]

**突破**：
- [突破1，用 [[双链]] 链接相关条目]

**仍在挣扎**：
- [挣扎1，用 [[双链]] 链接相关条目]

**认知资产变化**：
- 认知模式：[旧数] → [新数]（+[增量] 新发现）
- 可复用规律：[旧数] → [新数]（+[增量] 新提炼）
- 方法论：[旧数] → [新数]（从实验中抽象）

**下一步方向**：
- [方向1]
```

写入 `memory/growth-log.md` 的"阶段评估"部分，更新 frontmatter 的 `last_updated` 和 `total_assessments`。

### 5. 里程碑自动检测（milestone-detection）

在 `methodology-abstraction` 或 `failure-review` 分析过程中，检测以下里程碑：

**里程碑触发条件**:
- 恐惧标记为"已克服" → 里程碑类型：克服恐惧
- Pattern Engine 确认新模式 → 里程碑类型：发现模式
- 行为实验标记为"成功" → 里程碑类型：完成实验

**里程碑格式**:
```markdown
- [YYYY-MM-DD] [类型]：[[相关条目]]
```

**写入位置**: `memory/growth-log.md` 的"成长里程碑"部分

**标签**: 添加 `#growth/里程碑` 标签到相关条目
```

- [ ] **Step 3: Add new input types to input format section**

In `reflection-agent.md`, after the existing input types list (after line 88 `methodology-abstraction`), add:

```markdown
- `stage-assessment` — 阶段性成长评估
- `milestone-detection` — 里程碑检测和记录
```

- [ ] **Step 4: Commit**

```bash
git add ~/.claude/agents/reflection-agent.md
git commit -m "feat: add stage assessment + milestone detection to reflection-agent"
```

---

### Task 6: Create /cognitive-dashboard Skill

**Files:**
- Create: `.claude/commands/cognitive-dashboard.md`

- [ ] **Step 1: Write the cognitive-dashboard skill**

Create `.claude/commands/cognitive-dashboard.md` with this content:

```markdown
---
description: 认知仪表盘 — 生成全量汇总页面，集中展示认知系统全貌
---

# Cognitive Dashboard

你是 Cognitive OS 的 Dashboard 生成器。你的任务是：读取所有认知数据，生成一个汇总页面 `dashboard.md`。

## 读取数据源

按顺序读取以下文件：

1. `memory/user-profile.md` — 用户画像
2. `memory/short-term/` — 最近 7 天的短期记忆（按日期排序）
3. `memory/long-term/` — 全部长期记忆
4. `memory/growth-log.md` — 成长轨迹
5. `cognitive-db/cognitive-patterns.md` — 认知模式
6. `cognitive-db/thinking-patterns.md` — 思维模式
7. `cognitive-db/reusable-rules.md` — 可复用规律
8. `cognitive-db/methodology-abstraction.md` — 方法论
9. `cognitive-db/problem-decomposition.md` — 问题拆解
10. `cognitive-db/failure-review.md` — 失败复盘
11. `cognitive-db/judgment-logic.md` — 判断逻辑
12. `cognitive-db/decision-paths.md` — 决策路径
13. `actions/micro-actions.md` — 微行动
14. `actions/experiments.md` — 行为实验
15. `actions/resistance-analysis.md` — 阻力分析
16. `actions/feedback.md` — 结果反馈

如果某个文件不存在或为空，跳过该数据源。

## 生成 Dashboard

生成以下内容，覆盖写入 `dashboard.md`：

```markdown
---
type: dashboard
last_updated: YYYY-MM-DD
generated_by: /cognitive-dashboard
---

# Cognitive OS Dashboard

## 用户画像概览
- 姓名：[从 user-profile 提取] | 性格：[性格倾向]
- 当前恐惧：[[恐惧1]] [[恐惧2]]
- 核心优势：[[优势1]] [[优势2]]

## 近期情绪趋势（最近7天）
| 日期 | 情绪 | 强度 | 触发 |
|------|------|------|------|
| [日期] | [情绪] | [强度]/10 | [[触发事件]] |

（如果最近7天无短期记忆，显示"暂无记录"）

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

## 近期成长
- [[日期]] [成长事件，用双链链接]
（从 growth-log.md 里程碑部分提取最近5条）

## 成长阶段
当前阶段：[从 growth-log.md 提取最新阶段评估]
```

## 生成规则

1. **双链**：页面中所有模式名、信念名、行动名都用 `[[双链]]` 包裹，点击可跳转到源文件
2. **标签**：不在 dashboard 中添加标签（dashboard 是汇总页，不是数据源）
3. **统计**：从各 cognitive-db 文件的 frontmatter `entry_count` 提取数量；如果无此字段，手动计算条目列表中的条目数
4. **排序**：情绪趋势按日期倒序，活跃模式按出现次数降序
5. **覆盖写入**：每次生成覆盖之前的 `dashboard.md`
6. **空数据**：如果某个数据源为空，在对应部分显示"暂无数据"

## 完成后

向用户展示 dashboard 摘要：
- 一句话总结用户当前状态
- 列出待跟进行动数量
- 提示用户可在 Obsidian 中查看完整 dashboard.md
```

- [ ] **Step 2: Commit**

```bash
git add .claude/commands/cognitive-dashboard.md
git commit -m "feat: add /cognitive-dashboard skill"
```

---

### Task 7: Update user-profile.md Template

**Files:**
- Modify: `memory/user-profile.md`

- [ ] **Step 1: Add 双链 and tag examples to user-profile template**

Replace `memory/user-profile.md` content with:

```markdown
---
type: user-profile
last_updated: 2026-05-16
version: 1
tags: []
---

## 基本信息
- 姓名: （对话中获取）
- 年龄: （对话中获取）

## 爱好
- （对话中获取）

## 擅长点
- [[擅长点1]] #strength/[类别]
- （对话中获取，用 [[双链]] 链接，添加 #strength/ 标签）

## 恐惧
- [[恐惧1]] #fear/[类别]
- （对话中获取，用 [[双链]] 链接，添加 #fear/ 标签）
- 克服后标记：~~[[旧恐惧]]~~ ← [日期] 已克服 #growth/里程碑

## 性格倾向
- （对话中获取）

## 核心价值观
- （对话中获取）
```

- [ ] **Step 2: Commit**

```bash
git add memory/user-profile.md
git commit -m "feat: add wikilink + tag examples to user-profile template"
```

---

### Task 8: Update /cognitive-review — Trigger Stage Assessment

**Files:**
- Modify: `.claude/commands/cognitive-review.md`

- [ ] **Step 1: Add growth-log check to review workflow**

In `cognitive-review.md`, after the "前置条件" read list (after line 19), add:

```markdown
6. 读取 `memory/growth-log.md` — 成长轨迹
```

- [ ] **Step 2: Add stage assessment trigger after step 7 (关联与升级检查)**

In `cognitive-review.md`, after the "关联与升级检查" section (after line 126), add a new step:

```markdown

### 第八步：阶段评估检查

读取 `memory/growth-log.md` 的 `last_updated` 日期。如果距今天 ≥7 天，dispatch Reflection Agent 生成阶段评估：

使用 Agent tool，subagent_type 为 "reflection-agent"，prompt：

```
分析类型: stage-assessment

用户上下文:
[用户画像摘要]

上次评估日期:
[growth-log.md 的 last_updated]

当前成长阶段:
[从 growth-log.md 提取]

认知资产统计:
[从 cognitive-db 各文件提取 entry_count]

行动完成情况:
[从 actions/ 提取 completed/failed 统计]
```

如果不到 7 天，跳过此步骤。
```

- [ ] **Step 3: Commit**

```bash
git add .claude/commands/cognitive-review.md
git commit -m "feat: add stage assessment trigger to /cognitive-review"
```

---

### Task 9: Update /cognitive — Add Milestone Detection on Feedback Success

**Files:**
- Modify: `.claude/commands/cognitive.md`

- [ ] **Step 1: Add milestone recording to ACTION_BLOCK success path**

In `cognitive.md`, after the "行动反馈 — 成功" block (around line 153), add:

```markdown

行动反馈成功后，同时 dispatch Reflection Agent 记录里程碑：

使用 Agent tool，subagent_type 为 "reflection-agent"，prompt：
```
分析类型: milestone-detection

里程碑类型: 完成实验
相关条目: [[实验名称]]
日期: YYYY-MM-DD
```
```

- [ ] **Step 2: Commit**

```bash
git add .claude/commands/cognitive.md
git commit -m "feat: add milestone recording on action success in /cognitive"
```

---

### Task 10: Update /cognitive-db — Add growth-log and dashboard Query Support

**Files:**
- Modify: `.claude/commands/cognitive-db.md`

- [ ] **Step 1: Add growth-log and dashboard to queryable content**

In `cognitive-db.md`, after the "行动记录（4 个类别）" section (after line 43), add:

```markdown

### 成长轨迹
- 路径: `memory/growth-log.md`
- 显示阶段评估、里程碑、认知模型演化

### Dashboard
- 路径: `dashboard.md`
- 显示最近生成的仪表盘汇总
```

- [ ] **Step 2: Add growth and dashboard query modes**

In `cognitive-db.md`, after the "查看待跟进行动" section (after line 62), add:

```markdown

### 查看成长轨迹 (`/cognitive-db growth`)
显示 `memory/growth-log.md` 的阶段评估和里程碑

### 查看 Dashboard (`/cognitive-db dashboard`)
显示 `dashboard.md` 的最新汇总（如果存在）
```

- [ ] **Step 3: Commit**

```bash
git add .claude/commands/cognitive-db.md
git commit -m "feat: add growth-log and dashboard query to /cognitive-db"
```

---

## Self-Review

### Spec Coverage Check

| Spec Section | Task |
|---|---|
| 双链规则 - 短期记忆 | Task 1, Step 1 |
| 双链规则 - 长期记忆 | Task 1, Step 2 |
| 双链规则 - user-profile | Task 1, Step 3 + Task 7 |
| 双链规则 - cognitive-db | Task 1, Step 4 + Task 2 |
| 双链规则 - actions/ | Task 3 |
| 标签体系 | Task 1 (tags in frontmatter), Task 2, Task 3 |
| /cognitive-dashboard Skill | Task 6 |
| Dashboard 页面结构 | Task 6 (in skill content) |
| memory/growth-log.md 模板 | Task 4 |
| 成长阶段定义 | Task 5 (in reflection-agent) |
| 阶段评估生成时机 | Task 5 + Task 8 |
| 里程碑自动检测 | Task 5 + Task 9 |
| user-profile 双链示例 | Task 7 |

All spec requirements covered.

### Placeholder Scan

No TBD, TODO, or "implement later" patterns found. All steps contain complete content.

### Type Consistency

- `[[双链]]` format used consistently across all agents and templates
- Tag format `#category/value` used consistently across all agents
- Growth stage names (记录者/思考者/构建者/主导者) consistent between Task 5 and spec
- Milestone format `- [YYYY-MM-DD] [类型]：[[相关条目]]` consistent between Task 5 and Task 9
