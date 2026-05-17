# Chat Sessions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `sessions/` directory that saves conversation transcripts when the Memory Agent writes to any storage layer, with one-way backlinks from short-term memory, long-term memory, and cognitive database entries.

**Architecture:** Sessions are saved as individual Markdown files with YAML frontmatter + structured summary + full transcript. The Memory Agent is modified to save a session file before any storage write, and all other storage templates get a `source_session` / `source_sessions` field for backlinking.

**Tech Stack:** Markdown + YAML frontmatter + Obsidian wikilinks (existing stack, no new dependencies)

---

## File Structure

| Action | File | Responsibility |
|--------|------|---------------|
| Create | `sessions/_template.md` | Template for session files |
| Modify | `agents/memory-agent.md` | Add session-save logic before storage writes; add `source_session`/`source_sessions` to formats |
| Modify | `cognitive-db/why-reasons/_template.md` | Add `source_session` field |
| Modify | `cognitive-db/how-methods/_template.md` | Add `source_session` field |
| Modify | `cognitive-db/cognitive-models/_template.md` | Add `source_session` field |
| Modify | `cognitive-db/decision-frameworks/_template.md` | Add `source_session` field |
| Modify | `cognitive-db/events/_template.md` | Add `source_session` field |
| Modify | `memory/user-profile.md` | Add `[[session-name]]` hint in beliefs/anti-patterns sections |
| Modify | `setup.ps1` | Add `sessions/` directory creation + template copy |

---

### Task 1: Create sessions/_template.md

**Files:**
- Create: `sessions/_template.md`

- [ ] **Step 1: Create the session template file**

```markdown
---
type: session
date: YYYY-MM-DD
session_id: session-YYYYMMDD-NNN
emotion: [主导情绪]
intensity: [1-10]
topics: [[主题1, 主题2]]
state_path: [ENTRY_RECORD → ... → 最终状态]
related_memory: []
related_cognitive: []
tags: [#session, #emotion/[情绪], #topic/[主题]]
---

## 摘要

[1-3 段结构化摘要：本次对话围绕什么展开，情绪如何变化，识别出什么核心问题]

关键洞察：
- [洞察1]
- [洞察2]

行动项：
- [ ] [行动1]
- [ ] [行动2]

---

## 完整对话

> **用户**: [消息]
> **系统**: [回复]

（完整对话原文）
```

- [ ] **Step 2: Verify file exists**

Run: `Test-Path "sessions/_template.md"`
Expected: `True`

- [ ] **Step 3: Commit**

```bash
git add sessions/_template.md
git commit -m "feat: add sessions directory and template"
```

---

### Task 2: Add source_session to cognitive-db templates

**Files:**
- Modify: `cognitive-db/why-reasons/_template.md`
- Modify: `cognitive-db/how-methods/_template.md`
- Modify: `cognitive-db/cognitive-models/_template.md`
- Modify: `cognitive-db/decision-frameworks/_template.md`
- Modify: `cognitive-db/events/_template.md`

- [ ] **Step 1: Add `source_session` to why-reasons/_template.md**

Add `source_session:` field after the `tags:` line in the YAML frontmatter:

```yaml
---
type: cognitive-entry
category: why-reasons
date: YYYY-MM-DD
reason_type: [emotion|failure|stuck]
frequency: 1
related_methods: []
source_session: []
tags: [#reason/[类别]]
---
```

- [ ] **Step 2: Add `source_session` to how-methods/_template.md**

Add `source_session:` field after the `tags:` line:

```yaml
---
type: cognitive-entry
category: how-methods
date: YYYY-MM-DD
method_type: [thinking|behavior|coping|strategy]
applicable_reasons: []
source_session: []
tags: [#method/[类别]]
---
```

- [ ] **Step 3: Add `source_session` to cognitive-models/_template.md**

Add `source_session:` field after the `tags:` line:

```yaml
---
type: cognitive-model
category: cognitive-models
date: YYYY-MM-DD
model_type: [behavioral|emotional|cognitive]
source_reasons: []
source_methods: []
source_session: []
tags: [#model/[类别]]
---
```

- [ ] **Step 4: Add `source_session` to decision-frameworks/_template.md**

Add `source_session:` field after the `tags:` line:

```yaml
---
type: decision-framework
category: decision-frameworks
date: YYYY-MM-DD
framework_type: [daily|crisis|planning|relationship]
source_methods: []
source_session: []
tags: [#framework/[类别]]
---
```

- [ ] **Step 5: Add `source_session` to events/_template.md**

Add `source_session:` field after the `tags:` line:

```yaml
---
type: cognitive-entry
category: events
date: YYYY-MM-DD
event_type: [turning-point|high-impact|recurring-milestone]
intensity: [1-10]
related_reasons: []
related_methods: []
source_session: []
tags: [#event/[类别]]
---
```

- [ ] **Step 6: Verify all 5 templates have source_session**

Run: `Select-String -Path "cognitive-db\*\_template.md" -Pattern "source_session"`
Expected: 5 matches (one per template)

- [ ] **Step 7: Commit**

```bash
git add cognitive-db/why-reasons/_template.md cognitive-db/how-methods/_template.md cognitive-db/cognitive-models/_template.md cognitive-db/decision-frameworks/_template.md cognitive-db/events/_template.md
git commit -m "feat: add source_session backlink field to cognitive-db templates"
```

---

### Task 3: Add source_session/source_sessions to Memory Agent formats

**Files:**
- Modify: `agents/memory-agent.md`

- [ ] **Step 1: Add `source_session` to short-term memory format**

In `agents/memory-agent.md`, in the "短期记忆写入" section's format block, add `source_session` after the `pattern_dimensions` line:

```yaml
pattern_dimensions: [trigger, emotion, belief]
source_session: []
```

Also add a backlink rule after the existing "双链规则" block for short-term memory:

```
**会话反链规则**:
- 在 `source_session` 字段中，用 `[[session-name]]` 链接本次对话的会话文件
- 会话文件名格式：`YYYY-MM-DD-{主题摘要}`（不含 .md 后缀）
```

- [ ] **Step 2: Add `source_sessions` to long-term memory format**

In the "长期记忆升级" section's format block, add `source_sessions` after the `tags` line:

```yaml
tags: [#pattern/[模式], #emotion/[情绪], #belief/[信念], ...]
source_sessions: []
```

Also add a backlink rule after the existing "双链规则" block for long-term memory:

```
**会话反链规则**:
- 在 `source_sessions` 字段中，列出促成此模式的所有会话文件，用 `[[session-name]]` 链接
- 数组格式：`source_sessions: [[[session-1]], [[session-2]], [[session-3]]]`
```

- [ ] **Step 3: Add `source_session` to why-reasons format**

In the "原因提炼" section's format block, add `source_session` after the `tags` line:

```yaml
tags: [#reason/[类别]]
source_session: []
```

- [ ] **Step 4: Add `source_session` to how-methods format**

In the "方法提炼" section's format block, add `source_session` after the `tags` line:

```yaml
tags: [#method/[类别]]
source_session: []
```

- [ ] **Step 5: Add `source_session` to events format**

In the "事件存储" section's format block, add `source_session` after the `tags` line:

```yaml
tags: [#event/[类别]]
source_session: []
```

- [ ] **Step 6: Verify all format blocks updated**

Run: `Select-String -Path "agents\memory-agent.md" -Pattern "source_session"`
Expected: 5 matches (short-term, long-term, why-reasons, how-methods, events)

- [ ] **Step 7: Commit**

```bash
git add agents/memory-agent.md
git commit -m "feat: add source_session/source_sessions backlink fields to memory-agent formats"
```

---

### Task 4: Add session save logic to Memory Agent

**Files:**
- Modify: `agents/memory-agent.md`

- [ ] **Step 1: Add session-save section to Memory Agent**

Add the following section to `agents/memory-agent.md`, immediately after the "核心职责" heading and BEFORE the "短期记忆写入" section:

```markdown
### 0. 会话保存

当本次对话产生了认知产出时，**在写入任何存储层之前**，先保存会话文件到 `sessions/` 目录。

**触发条件**（满足任一即保存）：
1. 将要写入短期记忆
2. 将要升级为长期记忆
3. 将要写入认知数据库（why-reasons / how-methods / cognitive-models / decision-frameworks / events）
4. 对话中发生了状态转换（如 EMOTION_RELEASE → PROBLEM_EXPLORATION）

**保存流程**：
1. 确定会话文件名：`sessions/YYYY-MM-DD-{主题摘要}.md`
   - 主题摘要从对话核心话题提取，2-4 个中文词或英文短横线连接
   - 如果同名文件已存在，追加序号：`YYYY-MM-DD-{主题摘要}-2`
2. 生成 session_id：`session-YYYYMMDD-NNN`
   - NNN 为当日序号，从 `001` 开始，扫描 `sessions/` 中当日已有文件数递增
3. 填写 frontmatter：
   - `emotion`: 本次对话主导情绪
   - `intensity`: 主导情绪强度 1-10
   - `topics`: 话题标签数组
   - `state_path`: 本次对话经历的状态转换路径
   - `related_memory`: 将要写入的记忆文件 `[[wikilinks]]`
   - `related_cognitive`: 将要写入的认知数据库条目 `[[wikilinks]]`
   - `tags`: 必须包含 `#session`
4. 生成结构化摘要（1-3 段）：
   - 对话围绕什么展开
   - 情绪如何变化
   - 识别出什么核心问题
   - 提炼的关键洞察（列表）
   - 行动项（checkbox 列表）
5. 附加完整对话原文：
   - 格式：`> **用户**: <消息>` 和 `> **系统**: <回复>`
   - 保留对话的完整上下文
6. 使用 Write 工具写入文件
7. 记录会话文件名，用于后续存储层的 `source_session` 字段

**不保存的情况**：
- 对话纯属闲聊，不产生任何认知产出
- 对话未触发上述任何存储操作

**重要**：会话保存必须在存储写入之前完成，确保 `source_session` 字段可以正确引用会话文件。
```

- [ ] **Step 2: Add `save-session` to input format list**

In the "输入格式" section, add the new operation:

```markdown
- `save-session` — 保存会话文件到 sessions/
```

- [ ] **Step 3: Verify the new section is present and input format updated**

Run: `Select-String -Path "agents\memory-agent.md" -Pattern "会话保存"`
Expected: 1 match

Run: `Select-String -Path "agents\memory-agent.md" -Pattern "save-session"`
Expected: 1 match

- [ ] **Step 4: Commit**

```bash
git add agents/memory-agent.md
git commit -m "feat: add session save logic to memory-agent before storage writes"
```

---

### Task 5: Add session backlink hints to user-profile.md

**Files:**
- Modify: `memory/user-profile.md`

- [ ] **Step 1: Add `[[session-name]]` hint to core beliefs section**

In `memory/user-profile.md`, modify the "核心信念" section to include session reference hint:

Replace:
```markdown
- （从 TEBAR 分析中提取，用 [[双链]] 链接，添加 #belief/ 标签）
```

With:
```markdown
- （从 TEBAR 分析中提取，用 [[双链]] 链接，添加 #belief/ 标签，可用 [[session-name]] 引用来源会话）
```

- [ ] **Step 2: Add `[[session-name]]` hint to anti-patterns section**

Replace:
```markdown
- （从 why-reasons 高频条目中提炼）
```

With:
```markdown
- （从 why-reasons 高频条目中提炼，可用 [[session-name]] 引用来源会话）
```

- [ ] **Step 3: Verify hints are present**

Run: `Select-String -Path "memory\user-profile.md" -Pattern "session-name"`
Expected: 2 matches

- [ ] **Step 4: Commit**

```bash
git add memory/user-profile.md
git commit -m "feat: add session backlink hints to user-profile"
```

---

### Task 6: Update setup.ps1

**Files:**
- Modify: `setup.ps1`

- [ ] **Step 1: Add sessions directory to the dirs array**

In `setup.ps1`, add `"$VaultPath\sessions"` to the `$dirs` array, after the `"$VaultPath\cognitive-db\events"` entry:

```powershell
$dirs = @(
    "$VaultPath\memory\short-term",
    "$VaultPath\memory\long-term",
    "$VaultPath\cognitive-db\why-reasons",
    "$VaultPath\cognitive-db\how-methods",
    "$VaultPath\cognitive-db\cognitive-models",
    "$VaultPath\cognitive-db\decision-frameworks",
    "$VaultPath\cognitive-db\events",
    "$VaultPath\sessions",
    "$VaultPath\actions",
    "$VaultPath\.claude\commands"
)
```

- [ ] **Step 2: Add session template to templates hashtable**

Add the session template entry to the `$templates` hashtable in `setup.ps1`, before the closing `}` of the hashtable. Insert it after the `events\_template.md` entry:

```powershell
    "sessions\_template.md" = @"
---
type: session
date: YYYY-MM-DD
session_id: session-YYYYMMDD-NNN
emotion: [主导情绪]
intensity: [1-10]
topics: [[主题1, 主题2]]
state_path: [ENTRY_RECORD → ... → 最终状态]
related_memory: []
related_cognitive: []
tags: [#session, #emotion/[情绪], #topic/[主题]]
---

## 摘要

[1-3 段结构化摘要：本次对话围绕什么展开，情绪如何变化，识别出什么核心问题]

关键洞察：
- [洞察1]
- [洞察2]

行动项：
- [ ] [行动1]
- [ ] [行动2]

---

## 完整对话

> **用户**: [消息]
> **系统**: [回复]

（完整对话原文）
"@
```

- [ ] **Step 3: Verify setup.ps1 syntax is valid**

Run: `powershell -Command "& { $null = [System.Management.Automation.Language.Parser]::ParseFile('setup.ps1', [ref]$null, [ref]$null); Write-Host 'Syntax OK' }"`
Expected: `Syntax OK`

- [ ] **Step 4: Commit**

```bash
git add setup.ps1
git commit -m "feat: add sessions directory and template to setup script"
```

---

### Task 7: Update setup.ps1 templates with source_session

**Files:**
- Modify: `setup.ps1` (the template content in the hashtable)

- [ ] **Step 1: Add `source_session: []` to why-reasons template in setup.ps1**

Find the why-reasons template string in setup.ps1 and add `source_session: []` after the `tags:` line, matching the template file change from Task 2:

```yaml
tags: [#reason/[类别]]
source_session: []
```

- [ ] **Step 2: Add `source_session: []` to how-methods template in setup.ps1**

Same pattern — add after `tags:` line:

```yaml
tags: [#method/[类别]]
source_session: []
```

- [ ] **Step 3: Add `source_session: []` to cognitive-models template in setup.ps1**

Same pattern — add after `tags:` line:

```yaml
tags: [#model/[类别]]
source_session: []
```

- [ ] **Step 4: Add `source_session: []` to decision-frameworks template in setup.ps1**

Same pattern — add after `tags:` line:

```yaml
tags: [#framework/[类别]]
source_session: []
```

- [ ] **Step 5: Add `source_session: []` to events template in setup.ps1**

Same pattern — add after `tags:` line:

```yaml
tags: [#event/[类别]]
source_session: []
```

- [ ] **Step 6: Verify all templates in setup.ps1 have source_session**

Run: `Select-String -Path "setup.ps1" -Pattern "source_session"`
Expected: 5 matches

- [ ] **Step 7: Commit**

```bash
git add setup.ps1
git commit -m "feat: add source_session field to setup.ps1 cognitive-db templates"
```

---

### Task 8: Update user-profile template in setup.ps1

**Files:**
- Modify: `setup.ps1` (the user-profile template string)

- [ ] **Step 1: Add session backlink hints to user-profile template in setup.ps1**

Find the user-profile template string in setup.ps1 and apply the same hints as Task 5:

Replace:
```
- （从 TEBAR 分析中提取，用 [[双链]] 链接，添加 #belief/ 标签）
```

With:
```
- （从 TEBAR 分析中提取，用 [[双链]] 链接，添加 #belief/ 标签，可用 [[session-name]] 引用来源会话）
```

Replace:
```
- （从 why-reasons 高频条目中提炼）
```

With:
```
- （从 why-reasons 高频条目中提炼，可用 [[session-name]] 引用来源会话）
```

- [ ] **Step 2: Verify**

Run: `Select-String -Path "setup.ps1" -Pattern "session-name"`
Expected: 2 matches

- [ ] **Step 3: Commit**

```bash
git add setup.ps1
git commit -m "feat: add session backlink hints to setup.ps1 user-profile template"
```
