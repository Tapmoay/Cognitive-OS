# Chat Sessions Design

> Add a `sessions/` directory to save conversation transcripts, with backlink support from all storage layers.

## Decision Summary

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Directory location | `sessions/` top-level | Parallel to `memory/` and `cognitive-db/`, minimal changes |
| Save granularity | One file per conversation | Simple, consistent with short-term naming convention |
| Backlink direction | One-way (storage → session) | Sessions stay clean; Obsidian backlink panel handles reverse |
| Trigger | Memory Agent writes to any storage layer | Only save sessions with cognitive output; no idle chatter |
| Content | Structured summary + full transcript | Summary for quick scanning, transcript for full context |

## Directory Structure

```
sessions/
  _template.md
  YYYY-MM-DD-{topic-summary}.md
```

## Session File Format

```markdown
---
type: session
date: 2026-05-17
session_id: session-20260517-001
emotion: <dominant-emotion>
intensity: <1-10>
topics: [<topic1>, <topic2>]
state_path: ENTRY_RECORD → EMOTION_RELEASE → PROBLEM_EXPLORATION
related_memory: [[<short-term-or-long-term-file>]]
related_cognitive: [[<cognitive-db-entry>]]
tags: #session #emotion/<emotion> #topic/<topic>
---

## 摘要

<1-3 paragraph structured summary>

关键洞察：
- <insight 1>
- <insight 2>

行动项：
- [ ] <action 1>
- [ ] <action 2>

---

## 完整对话

> **用户**: <message>
> **系统**: <response>

（Full transcript）
```

### Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `type` | Yes | Always `session` |
| `date` | Yes | Session date (YYYY-MM-DD) |
| `session_id` | Yes | Unique ID: `session-YYYYMMDD-NNN` |
| `emotion` | No | Dominant emotion |
| `intensity` | No | Emotion intensity 1-10 |
| `topics` | No | Topic tag array |
| `state_path` | No | State transitions during session |
| `related_memory` | No | Linked memory files `[[wikilinks]]` |
| `related_cognitive` | No | Linked cognitive-db entries `[[wikilinks]]` |
| `tags` | Yes | Must include `#session` |

## Trigger Mechanism

Memory Agent saves session file **before** writing to any storage layer, but **only if** the conversation produced cognitive output.

### Trigger Conditions (any one suffices)

1. Writing to short-term memory
2. Writing to long-term memory
3. Writing to cognitive database
4. State transition occurred (e.g., EMOTION_RELEASE → PROBLEM_EXPLORATION)

### Flow

```
Conversation ends
  → Memory Agent checks: did this conversation produce cognitive output?
  → YES: Save session file → Write to target storage layer
  → NO: Skip (pure casual chat not stored)
```

## Backlink Rules

All backlinks are one-way: storage layers reference sessions via `[[session-name]]`. Sessions themselves do not link back.

| Storage Layer | Field | Example |
|---------------|-------|---------|
| Short-term memory | `source_session: [[session-name]]` | `source_session: [[2026-05-17-work-anxiety]]` |
| Long-term memory | `source_sessions: [[[session-1]], [[session-2]], [[session-3]]]` | All sessions that contributed to this pattern |
| Cognitive DB (all 5 dirs) | `source_session: [[session-name]]` | Why-reasons, how-methods, etc. |
| User profile | Body text `[[session-name]]` | At belief/anti-pattern origins |

Obsidian's backlink panel automatically shows "which files reference this session" without manual maintenance.

## Files to Modify

1. **`agents/memory-agent.md`** — Core: add session save logic before storage writes; add `source_session` / `source_sessions` fields
2. **`memory/short-term/`** template / convention — Add `source_session` frontmatter field
3. **`memory/long-term/`** template / convention — Add `source_sessions` array field
4. **`cognitive-db/why-reasons/_template.md`** — Add `source_session` field
5. **`cognitive-db/how-methods/_template.md`** — Add `source_session` field
6. **`cognitive-db/cognitive-models/_template.md`** — Add `source_session` field
7. **`cognitive-db/decision-frameworks/_template.md`** — Add `source_session` field
8. **`cognitive-db/events/_template.md`** — Add `source_session` field
9. **`memory/user-profile.md`** — Hint `[[session-name]]` usage in beliefs/anti-patterns fields
10. **`sessions/_template.md`** — New file
11. **`setup.ps1`** — Add `sessions/` directory creation

## What This Does NOT Include

- No new agents or skills — session logic is embedded in Memory Agent
- No session search/indexing — rely on Obsidian or future dashboard
- No session expiration/cleanup — future consideration
- No real-time session streaming — file is written once at save time
