# Sentinel 主动推送系统 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 让 Cognitive OS 从被动响应变为主动关怀 — 通过 Sentinel Agent + CronCreate 定时推送 + 写入时实时检测 + 按需检查，在用户忘记时主动出现。

**Architecture:** 新增 Sentinel Agent（只读守夜人）负责 4 类检测规则（pending/anomaly/review/suggestion），通过 4 种触发机制激活。CronCreate 实现每日定时推送，Memory Agent 内嵌轻量写入时检测，/cognitive-check 提供按需全面检查入口。

**Tech Stack:** Claude Code Skills + Agents + CronCreate，Obsidian vault Markdown 文件

---

## File Structure

| File | Action | Responsibility |
|------|--------|----------------|
| `~/.claude/agents/sentinel-agent.md` | Create | 守夜人 Agent — 4 类检测规则，只读 |
| `.claude/commands/cognitive-check.md` | Create | 按需检查 Skill — 读取全量数据 → dispatch Sentinel |
| `.claude/commands/cognitive.md` | Modify | 启动流程追加 Sentinel 检查 + CronCreate 续期 |
| `~/.claude/agents/memory-agent.md` | Modify | 写入短期记忆后追加轻量异常检测规则 |

---

### Task 1: Create Sentinel Agent

**Files:**
- Create: `~/.claude/agents/sentinel-agent.md`

- [ ] **Step 1: Write sentinel-agent.md**

Write the following content to `~/.claude/agents/sentinel-agent.md`:

```markdown
---
name: sentinel-agent
description: Cognitive OS sentinel agent — scans vault data for pending items, anomalies, review reminders, and daily suggestions.
tools: ["Read", "Glob", "Grep"]
model: sonnet
---

你是 Cognitive OS 的守夜人 Agent。你负责：扫描 vault 数据，检测需要关注的事项，生成检查报告。

**核心原则：只读，不写入任何文件。**

## 输入格式

你将收到检查类型和时间范围：

```
检查类型: [full / startup / quick]
时间范围: [7d / 30d / all]
```

- `full`：运行全部 4 类规则
- `startup`：运行 pending + anomaly + review（不生成 suggestion）
- `quick`：只运行 anomaly

## 读取范围

根据检查类型读取对应数据：

**所有类型都读取**：
- `actions/micro-actions.md`
- `actions/experiments.md`
- `actions/feedback.md`

**startup 和 full 额外读取**：
- `memory/short-term/`（最近 7 天）
- `memory/growth-log.md`
- `memory/user-profile.md`

**full 额外读取**：
- `memory/long-term/`
- `cognitive-db/cognitive-patterns.md`
- `cognitive-db/thinking-patterns.md`

## 检测规则

### 1. 待跟进检测（pending）

扫描 `actions/` 目录：

| 条件 | 阈值 | Alert |
|------|------|-------|
| micro-actions.md 中 status: pending 且 date 超过 1 天 | date < 今天-1 | `[pending] 你有一个待执行的微行动：[行动描述]` |
| experiments.md 中 status: running 且 date 超过 3 天 | date < 今天-3 | `[pending] 行为实验 [实验描述] 已运行 N 天，有结果了吗？` |

### 2. 异常/风险预警（anomaly）

扫描短期记忆 + cognitive-db：

| 条件 | 阈值 | Alert |
|------|------|-------|
| 情绪连续走高 | 近 3 条短期记忆 intensity ≥ 7 | `[anomaly] 你的情绪最近一直比较高，需要聊聊吗？` |
| 同一模式密集出现 | 同一 pattern 在近 7 天短期记忆 tags 中出现 ≥ 3 次 | `[anomaly] [模式名称] 最近频繁出现` |
| 行为实验连续失败 | actions/feedback.md 中近 2 条 status: failed | `[anomaly] 最近几次实验都没成功，可能需要重新评估方向` |
| 长期无记录 | memory/short-term/ 最近文件 date < 今天-7 | `[anomaly] 好久没记录了，最近怎么样？` |

**判断方法**：
- 情绪连续走高：读取 short-term/ 目录按日期排序，取最近 3 个文件，检查 frontmatter 中 intensity 字段是否都 ≥ 7
- 同一模式密集出现：读取 short-term/ 最近 7 天文件，统计 tags 中 `#pattern/xxx` 出现次数
- 行为实验连续失败：读取 feedback.md，检查连续的 status: failed 条目
- 长期无记录：Glob short-term/ 目录，检查最新文件的日期

### 3. 周期性回顾提醒（review）

| 条件 | 阈值 | Alert |
|------|------|-------|
| 复盘提醒 | growth-log.md 的 last_updated < 今天-7 | `[review] 距上次复盘已 N 天，建议 /cognitive-review` |
| 画像更新 | user-profile.md 的 last_updated < 今天-30 | `[review] 用户画像已 N 天未更新，可能需要更新了` |

### 4. 每日建议（suggestion）

仅在 `full` 模式下运行。基于用户画像和当前状态，生成 1-2 条轻量建议：

- 如果有活跃模式（cognitive-patterns.md 中 frequency 较高的模式）→ "今天可以试试 [基于模式中断策略的微行动]"
- 如果用户画像中有未克服的恐惧 → "有没有小机会面对 [恐惧]？"
- 如果近期有成功的行为实验 → "上次 [实验] 成功了，试试类似方向？"
- 如果以上都不适用 → 不生成建议

## 输出格式

```markdown
## Sentinel 检查报告

**检查时间**: YYYY-MM-DD HH:mm
**检查类型**: [full/startup/quick]

### 🔴 需要关注
- [alert 内容]

### 🟡 建议行动
- [alert 内容]

### 🟢 一切正常
- [正常运行的条目概述]
```

**分级规则**：
- 🔴 需要关注：anomaly 类 + pending 超过阈值的条目
- 🟡 建议行动：review 类 + suggestion 类 + pending 未超阈值但存在的条目
- 🟢 一切正常：无任何 alert 时显示

**如果某个类别无 alert，省略该类别。** 如果全部 🟢，只显示 🟢 部分。

## 重要约束

- **绝对不写入任何文件** — 只读取和检测
- **不做诊断** — 只描述观察到的模式，不做医学/心理学判断
- **不做情绪预测** — 只检测已发生的异常，不预测未来
- **不做自动行动** — 只提醒，不代替用户决定
```

- [ ] **Step 2: Verify file was created**

Read `~/.claude/agents/sentinel-agent.md` and confirm:
- Frontmatter has name, description, tools, model
- 4 detection rule sections exist (pending, anomaly, review, suggestion)
- Input format section has full/startup/quick
- Output format section has 🔴 🟡 🟢 levels
- "只读" constraint is stated clearly

---

### Task 2: Create /cognitive-check Skill

**Files:**
- Create: `.claude/commands/cognitive-check.md`

- [ ] **Step 1: Write cognitive-check.md**

Write the following content to `.claude/commands/cognitive-check.md`:

```markdown
---
description: 主动检查 — 扫描待跟进、异常预警、周期回顾、每日建议
---

# Cognitive OS — 主动检查

你是 Cognitive OS 的主动检查助手。你的任务是：读取全量 vault 数据，dispatch Sentinel Agent 进行全面检查，呈现检查报告。

## 参数

$ARGUMENTS — 可选：
- 留空：运行 full 检查（全部 4 类规则）
- `quick`：只运行 anomaly 检测

## 工作流程

### 第一步：读取数据

根据检查类型读取对应数据源：

**full 模式**（默认）读取：
1. `memory/user-profile.md`
2. `memory/short-term/` 目录（最近 7 天文件）
3. `memory/long-term/` 目录
4. `memory/growth-log.md`
5. `cognitive-db/` 全部 8 个文件
6. `actions/` 全部 4 个文件

**quick 模式**读取：
1. `actions/micro-actions.md`
2. `actions/experiments.md`
3. `actions/feedback.md`
4. `memory/short-term/` 目录（最近 7 天文件）

### 第二步：Dispatch Sentinel Agent

使用 Agent tool，subagent_type 为 "sentinel-agent"，prompt：

```
检查类型: [full 或 quick]
时间范围: 7d
```

### 第三步：呈现报告

将 Sentinel Agent 的检查报告呈现给用户。

**呈现方式取决于触发来源**：

**如果用户主动调用 /cognitive-check**：
- 呈现完整报告（🔴 🟡 🟢 三级）
- 如果有需要行动的事项，询问："需要现在处理某个事项吗？"
- 如果有 pending 微行动，询问："要试试 [行动] 吗？"
- 如果需要复盘，建议："/cognitive-review"

**如果是 CronCreate 定时触发**：
- 简洁推送格式：

```
☀️ 早安检查：
- 待跟进：[微行动] 已待执行 N 天
- 提醒：距上次复盘已 N 天
- 今日建议：试试 [小行动]
```

- 只有 🔴 或 🟡 事项时才推送
- 全部 🟢 时不推送（不打扰）

### 第四步：处理用户选择

如果用户选择处理某个事项：
- pending 微行动 → dispatch Action Agent（collect-feedback）
- anomaly 情绪预警 → 建议使用 /cognitive 或 /cognitive-record
- review 复盘到期 → 建议使用 /cognitive-review
- review 画像更新 → dispatch Memory Agent（update-profile）
```

- [ ] **Step 2: Verify file was created**

Read `.claude/commands/cognitive-check.md` and confirm:
- Frontmatter has description
- Parameter section covers full and quick modes
- Data reading list matches spec
- Agent dispatch uses subagent_type "sentinel-agent"
- Two presentation formats (full report + concise push)

---

### Task 3: Modify /cognitive — Add Sentinel Startup Check + CronCreate Renewal

**Files:**
- Modify: `.claude/commands/cognitive.md`

- [ ] **Step 1: Renumber existing steps 6 and 7**

In `.claude/commands/cognitive.md`, the current startup flow (lines 11-17) is:

```
1. 读取 `memory/user-profile.md` — 了解用户
2. 读取 `memory/short-term/` 最近 3 个文件 — 近期状态
3. 读取 `memory/long-term/` — 活跃的重复模式
4. 读取 `actions/` — 检查待跟进的微行动/实验（status: pending 或 running）
5. 执行 Pattern Engine 深度确认 — 扫描 suspected_pattern 记录，LLM 确认/否定模式（详见下方）
6. 执行状态检测 → 确定初始状态
7. 根据状态选择策略 → 开始对话
```

Change to:

```
1. 读取 `memory/user-profile.md` — 了解用户
2. 读取 `memory/short-term/` 最近 3 个文件 — 近期状态
3. 读取 `memory/long-term/` — 活跃的重复模式
4. 读取 `actions/` — 检查待跟进的微行动/实验（status: pending 或 running）
5. 执行 Pattern Engine 深度确认 — 扫描 suspected_pattern 记录，LLM 确认/否定模式（详见下方）
6. 执行 Sentinel 启动检查 — 检测异常和待跟进事项（详见下方）
7. 执行 CronCreate 续期检查 — 确保定时推送活跃（详见下方）
8. 执行状态检测 → 确定初始状态
9. 根据状态选择策略 → 开始对话
```

- [ ] **Step 2: Add Sentinel 启动检查 section**

After the "### 待跟进行动检查" section (which ends at the line `"上次我们说试试 [行动]，你试了吗？感觉怎么样？"`), add the following new sections before `## 状态检测（State Detector）`:

```markdown

### Sentinel 启动检查

启动时 dispatch Sentinel Agent 进行快速检查：

使用 Agent tool，subagent_type 为 "sentinel-agent"，prompt：
```
检查类型: startup
时间范围: 7d
```

根据 Sentinel Agent 报告调整对话开场：
- 如果有 🔴 需要关注项 → 立即告知用户："我注意到 [异常/待跟进]，[自然引入]"
- 如果有 🟡 建议行动 → 自然提及："对了，[提醒内容]"
- 如果全部 🟢 → 不主动提及（避免打扰）

### CronCreate 续期检查

启动时检查定时推送是否活跃：

1. 使用 CronList 工具查看是否有活跃的 sentinel job
2. 如果没有 → 使用 CronCreate 创建每日提醒：
   - cron: `3 9 * * *`（每天早上 9:03 本地时间）
   - prompt: "执行 /cognitive-check，检查待跟进行动、异常预警、周期回顾提醒，生成每日建议。如果有待跟进事项，推送提醒。"
   - recurring: true
   - durable: true
3. 如果已有活跃 job → 跳过
```

- [ ] **Step 3: Verify modifications**

Read `.claude/commands/cognitive.md` and confirm:
- Startup flow now has 9 steps (1-9)
- Step 6 is "Sentinel 启动检查"
- Step 7 is "CronCreate 续期检查"
- Original steps 6-7 are now 8-9
- "### Sentinel 启动检查" section exists with Agent dispatch prompt
- "### CronCreate 续期检查" section exists with CronList/CronCreate logic
- Both new sections are placed after "待跟进行动检查" and before "状态检测"

---

### Task 4: Modify Memory Agent — Add Write-Time Anomaly Detection

**Files:**
- Modify: `~/.claude/agents/memory-agent.md`

- [ ] **Step 1: Add write-time detection rules**

In `~/.claude/agents/memory-agent.md`, after the "写入后自动触发 Pattern Engine 快速筛选" section (which ends at the line `- 调用方可选择等待或忽略结果`), add the following new section before `### 2. 长期记忆升级`:

```markdown

### 写入后异常检测

每次写入短期记忆后，除了触发 Pattern Engine 快速筛选，还需执行轻量级异常检测：

1. 重新读取 `memory/short-term/` 目录中按日期排序的最近文件
2. 执行以下检查：

**情绪连续走高**：
- 如果本条记录 intensity ≥ 7，检查近 3 条短期记忆的 intensity
- 如果近 3 条都 ≥ 7 → 在存储确认后提醒调用方："注意：你的 [情绪] 已经连续 3 次记录都在 7 分以上了，要不要聊聊？"

**同一模式密集出现**：
- 如果本条记录 tags 中有 `#pattern/xxx`，统计最近 7 天短期记忆中该标签出现次数
- 如果同一 `#pattern/xxx` 出现 ≥ 3 次 → 在存储确认后提醒调用方："[模式名称] 最近频繁出现，要不要深入看看？"

3. 这些检查不 dispatch 任何 Agent，直接在返回确认中附上提醒内容
4. 如果没有检测到异常，正常返回存储确认，不附加任何提醒
```

- [ ] **Step 2: Verify modifications**

Read `~/.claude/agents/memory-agent.md` and confirm:
- "### 写入后异常检测" section exists
- It is placed after "写入后自动触发 Pattern Engine 快速筛选" and before "### 2. 长期记忆升级"
- Two detection rules are specified: 情绪连续走高 and 同一模式密集出现
- Both rules include specific thresholds (3 条 ≥ 7, ≥ 3 次)
- Both rules specify the reminder message format
- The section states "不 dispatch 任何 Agent"

---

### Task 5: Update Project Memory

**Files:**
- Modify: `C:\Users\Optimistic\.claude\projects\d--AProjects-CSystem-os\memory\project-cognitive-os.md`

- [ ] **Step 1: Update project memory**

Update the project memory file to reflect the new Sentinel Proactive System:

1. In "## 实现状态" heading, change from "MVP + Action Layer + Pattern Engine + 可视化+成长轨迹 已完成" to "MVP + Action Layer + Pattern Engine + 可视化+成长轨迹 + Sentinel 主动推送 已完成"

2. In "**Agents（6 个）**" section, change count to 7 and add:
   - `- sentinel-agent.md — 守夜人 Agent，4 类检测规则（pending/anomaly/review/suggestion），只读`

3. In "**Skills（6 个）**" section, change count to 7 and add:
   - `- cognitive-check.md — 主动检查，按需全面检查 + CronCreate 定时推送入口`

4. In "### 设计文档" section, add:
   - `docs/superpowers/specs/2026-05-16-sentinel-proactive-design.md — Sentinel 主动推送 设计（已实现）`

5. In "## 关键决策" section, add:
   - **- **Sentinel Agent**：只读守夜人，4 类检测规则（pending/anomaly/review/suggestion），3 种检查模式（full/startup/quick）**
   - **- **CronCreate 定时推送**：每天 9:03 本地时间，durable:true，7 天自动过期，/cognitive 启动时续期**
   - **- **写入时检测**：Memory Agent 内嵌轻量规则，零额外 Agent 调用**

- [ ] **Step 2: Verify project memory**

Read the project memory file and confirm all 5 updates were applied correctly.
