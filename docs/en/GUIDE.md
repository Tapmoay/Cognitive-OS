# Cognitive OS — Detailed Usage Guide

[简体中文](../../GUIDE.md) | [繁體中文](../zh-tw/GUIDE.md) | English

---

## What Is Cognitive OS?

Cognitive OS is a cognitive operating system that runs inside Claude Code. It helps you:

- **Record** — Low-friction logging of emotions, events, and thoughts
- **Understand** — Automatic analysis of causes and pattern detection
- **Extract** — Condense scattered experiences into reasons and methods
- **Build** — Assemble reusable personal patterns and strategies
- **Act** — Generate micro-actions and design behavioral experiments
- **Evolve** — Track growth trajectory with stage-based progression

The entire system uses **conversation** as its core interaction — just speak, and the AI determines what you need.

---

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and logged in
- (Recommended) [Obsidian](https://obsidian.md) for visualizing your cognitive data with wikilinks

---

## Installation

### Option 1: One-Click Install

```powershell
# After cloning/downloading the project, run in the project directory:
.\setup.ps1

# Or specify a custom Vault path:
.\setup.ps1 -VaultPath "D:\MyCognitiveVault"
```

The installer will automatically:
1. Check that Claude Code is available
2. Create the Vault directory structure
3. Initialize data files
4. Install Skills to `.claude/commands/`
5. Install Agents to `~/.claude/agents/`

### Option 2: Manual Install

1. **Create Vault directories**

```
YourVault/
├── memory/
│   ├── short-term/
│   ├── long-term/
│   ├── user-profile.md
│   └── growth-log.md
├── cognitive-db/
│   ├── why-reasons/
│   ├── how-methods/
│   ├── cognitive-models/
│   ├── decision-frameworks/
│   └── events/
├── actions/
│   ├── micro-actions.md
│   ├── experiments.md
│   ├── resistance-analysis.md
│   └── feedback.md
├── .claude/
│   └── commands/        ← Copy all 8 skill files here
```

2. **Copy Agents**

Copy the 7 Agent files to `~/.claude/agents/`:

| Agent File | Purpose |
|-----------|---------|
| emotion-agent.md | Emotion identification and splitting |
| cognitive-agent.md | TEBAR causal chain analysis |
| reflection-agent.md | Insight generation, review, pattern/strategy building |
| memory-agent.md | Storage decisions and profile updates |
| pattern-detector.md | Two-layer pattern detection engine |
| action-agent.md | Behavioral intervention and experiment design |
| sentinel-agent.md | Watchman — anomaly detection + scheduled push |

---

## Quick Start

```bash
# 1. Navigate to your Vault directory
cd YourVaultPath

# 2. Start Claude Code
claude

# 3. Enter the command to begin
/cognitive
```

On first use, the system will detect you're a new user and enter a guided mode to help establish your basic profile.

---

## Command Reference

| Command | Purpose | Min. Stage |
|---------|---------|-----------|
| `/cognitive` | Main entry — auto-detect state, start conversation | Recorder |
| `/cognitive-record` | Quick record mode | Recorder |
| `/cognitive-check` | Active check for pending items | Recorder |
| `/cognitive-analyze` | Deep analysis mode | Thinker |
| `/cognitive-review` | Review & reflection mode | Thinker |
| `/cognitive-build` | Explicit build trigger (usually auto-triggered) | Builder |
| `/cognitive-db` | Query cognitive database | Recorder |
| `/cognitive-dashboard` | Generate dashboard summary | Thinker |

You don't need to memorize all commands — most of the time, just `/cognitive` is enough. The system auto-selects the right strategy based on your input.

---

## Growth Process: 6-Stage Loop

```
Record → Understand → Extract → Build → Act → Evolve
  ↑                                            |
  └────────────────────────────────────────────┘
```

### What Happens at Each Stage

| Stage | What You Do | What The System Does |
|-------|------------|---------------------|
| **Record** | Speak freely about feelings/events | Store to short-term memory, light empathy |
| **Understand** | Answer follow-up questions | TEBAR analysis, extract reasons and beliefs |
| **Extract** | Accumulate similar reasons/methods | Auto-propose organizing into patterns |
| **Build** | Agree to organize | Assemble personal patterns/strategies into the cognitive database |
| **Act** | Try micro-actions or experiments | Generate action plans, track execution results |
| **Evolve** | Continue using the system | Stage assessment, milestone recording, growth visualization |

---

## Evolution Stages: 4 Levels

As your cognitive assets accumulate, the system automatically evaluates and notifies you of stage promotions:

| Stage | Criteria | Unlocked Capabilities |
|-------|----------|----------------------|
| **Recorder** | Just started | Basic recording + Emotion Container |
| **Thinker** | Short-term memory ≥ 10 entries, or reasons ≥ 3 | Deep analysis + Pattern Engine + Action Agent |
| **Builder** | Personal patterns ≥ 1, or personal strategies ≥ 1 | Pattern building + Strategy assembly + Reflection Agent |
| **Leader** | Successful experiments ≥ 3, and strategies ≥ 1 | All Agents available + Autonomous exploration |

**Stage promotion is automatic** — just keep using the system, and it will tell you when you've leveled up.

### Stage Behavior Matrix

| Dimension | Recorder | Thinker | Builder | Leader |
|-----------|----------|---------|---------|--------|
| Inquiry depth | 1 layer | 2 layers | 3 layers | Unlimited |
| Emotion container | Prioritize, no inquiry | Gentle inquiry after empathy | Direct analysis after empathy | Quick strategy shift after empathy |
| Proactive suggestions | None | Occasional | Proactively suggest building | On-demand |
| Agent access | Emotion only | + Cognitive, Action | + Reflection | All Agents |
| Pattern Engine | Off | On startup | On write + startup | On write + startup + on demand |

---

## Cognitive Database

Your cognitive assets are stored in 5 interconnected databases, all linked via Obsidian wikilinks:

| Database | Path | What It Stores |
|----------|------|---------------|
| Reasons | `cognitive-db/why-reasons/` | Why you feel bad / fail / get stuck |
| Methods | `cognitive-db/how-methods/` | Thinking methods and approaches that help |
| Personal Patterns | `cognitive-db/cognitive-models/` | "I notice I always..." — reusable self-knowledge |
| Personal Strategies | `cognitive-db/decision-frameworks/` | "Next time X, I follow these steps" — action frameworks |
| Events | `cognitive-db/events/` | Turning points, high-impact, milestone events |

### Build Triggering

Building does **not** require manual operation. When similar reasons/methods accumulate ≥ 3 entries, the system will naturally propose in conversation:

> "I notice you always [pattern]. Want to organize this so you can use it next time?"

You can also explicitly trigger with `/cognitive-build`.

### Data Connections

All databases are interconnected via wikilinks (`[[entry-name]]`):

- Successful experiments → Methods extracted into `how-methods/`
- Resistance analysis beliefs → Linked to `why-reasons/` beliefs field
- Pattern detections → Written to `why-reasons/` (reason_type: stuck)
- Personal patterns → `cognitive-models/` (source_reasons / source_methods link back)
- Personal strategies → `decision-frameworks/` (source_methods link back)

---

## Querying Your Data

```
/cognitive-db                    — Overview: profile summary + counts + pending items
/cognitive-db profile            — Full user profile
/cognitive-db reasons            — All reasons
/cognitive-db methods            — All methods
/cognitive-db models             — All personal patterns
/cognitive-db frameworks         — All personal strategies
/cognitive-db actions            — Action records
/cognitive-db pending            — Pending micro-actions and experiments
/cognitive-db growth             — Growth trajectory
/cognitive-db search [keyword]   — Full-database search
/cognitive-db dashboard          — View dashboard
```

---

## 6 Cognitive States

The system auto-detects your current state and selects the most appropriate conversation style:

| State | Signal | System Response |
|-------|--------|----------------|
| **ENTRY_RECORD** | Short input, no clear question | Light empathy + recording |
| **EMOTION_RELEASE** | Strong emotion words, intensity ≥ 7 | Emotion Container (hold first, don't analyze) |
| **PROBLEM_EXPLORATION** | "I always...", "Why do I..." | Guided questioning, find reasons |
| **COGNITIVE_REFLECTION** | "I notice I...", "Seems like every time..." | Deep analysis, connect existing patterns |
| **ACTION_BLOCK** | "I just can't do it", "Can't change" | Stop reasoning, shift to action mode |
| **FAILURE_REVIEW** | "Screwed up again", "Failed again" | Review guidance, attribution + method correction |

You don't need to judge what state you're in — just say what you want to say.

### Emotion Container

When strong emotions are detected, the system activates the Emotion Container:

1. **Empathize first** — "That sounds really hard right now." No "why" questions, no advice.
2. **Grounding** (if needed) — "Where are you right now?"
3. **Gentle inquiry** (after emotions ease, controlled by stage threshold) — "What do you think is making you feel this way?"
4. **Wait for cooldown** (above threshold) — Don't rush into any analysis mode.

---

## Action Layer

When you're in the "I know the problem but can't change" state, the system switches to action mode:

### Micro-Actions
Smallest actionable steps completable in 5 minutes. Lower the barrier to action.

### Behavioral Experiments
Hypothesis → Experiment → Expected → Actual. Verify cognitive assumptions using the scientific method.

### Resistance Analysis
Four-dimensional breakdown: Emotional resistance / Cognitive resistance / Environmental resistance / Hidden benefits.

### Result Feedback
Track action outcomes. Success → extract methods. Failure → analyze resistance and generate new actions.

---

## Scheduled Push

The system checks automatically every morning at 9:03 AM (local time):
- Pending micro-actions and experiments
- Anomaly alerts (e.g., no entries for a long time, persistently low mood)
- Periodic review reminders

You need to keep a Claude Code session active to receive push notifications. If Claude Code isn't running, pending items will be checked on next startup.

---

## Typical Usage Scenarios

### Scenario 1: Feeling bad, want to vent

```
/cognitive
> I'm so annoyed today

System: Detects EMOTION_RELEASE → Emotion Container mode
→ Empathy first, no analysis, gentle inquiry after emotions ease
```

### Scenario 2: Noticing a recurring pattern

```
/cognitive
> I notice I always procrastinate on new tasks and then get anxious

System: Detects COGNITIVE_REFLECTION → Deep analysis
→ TEBAR causal chain → Extract reasons → Check if enough entries to trigger building
```

### Scenario 3: Knowing the problem but can't change

```
/cognitive
> I know I should sleep early but I just can't

System: Detects ACTION_BLOCK → Action mode
→ Check for matching personal strategies → Generate micro-action
```

### Scenario 4: Want to review a failure

```
/cognitive-review
> I bombed the interview yesterday

System: FAILURE_REVIEW → Review guidance
→ Event reconstruction → Attribution analysis → Core lessons → Method correction
```

### Scenario 5: Check growth progress

```
/cognitive-db growth     — View growth trajectory
/cognitive-db dashboard  — View dashboard
/cognitive-check         — Active check for pending items
```

---

## Memory System

### Short-Term Memory
Recent conversation summaries stored in `memory/short-term/`. Each entry includes structured tags and wikilinks.

### Long-Term Memory
Patterns that recur across sessions, promoted from short-term. Stored in `memory/long-term/`.

### User Profile
Your evolving profile at `memory/user-profile.md`, including:
- Basic info and personality tendencies
- Core values and beliefs (extracted from TEBAR analysis)
- Personal patterns (linked from cognitive-models/)
- Anti-patterns (distilled from high-frequency reasons)
- Decision preferences

### Growth Log
Complete growth trajectory at `memory/growth-log.md`:
- Stage assessments (triggered every 7+ days)
- Milestones (fear overcome, pattern discovered, experiment completed)
- Pattern & strategy evolution

---

## Data Safety

All data is stored in your local file system as Markdown files. Nothing is uploaded to any external server. Claude Code conversations are processed through the Anthropic API, but your cognitive data (memories, reasons, methods, etc.) always stays on your own disk.

**Recommendation:** Back up your Vault directory regularly using Obsidian or Git.

---

## Packaging for Distribution

If you want to share this system with others:

1. **Ensure the project directory contains all files**

The repo already includes everything needed:
- `.claude/commands/` — 8 skill files
- `agents/` — 7 agent files (included in repo)
- `cognitive-db/` — Template files
- `memory/` — Initialization templates
- `actions/` — Initialization templates
- `setup.ps1` — Installation script

2. **Distribute**

Clone or download the repo, then run `setup.ps1`.

3. **Recipients need**

- Claude Code CLI installed
- Anthropic API access
- (Recommended) Obsidian

---

## FAQ

### Q: Will my cognitive data be lost?
A: All data is local Markdown files. As long as the files exist, your data is safe. Back up your Vault directory regularly, or use Git.

### Q: Do I have to use Obsidian?
A: No. Obsidian is only for visualizing wikilinks and tags. The system runs entirely in Claude Code. But Obsidian makes it much more intuitive to see connections between cognitive assets.

### Q: Why can't I use some commands at the Recorder stage?
A: The system adjusts capabilities based on your evolution stage. The Recorder stage focuses on recording — wait until data accumulates and you'll auto-upgrade. This isn't a restriction; it's protection from cognitive overload.

### Q: What's the difference between Personal Patterns and Personal Strategies?
A: **Personal Patterns** = "I notice I always..." (descriptive — helps you understand yourself). **Personal Strategies** = "Next time X, I follow these steps" (prescriptive — helps you act). Patterns are understanding; strategies are application.

### Q: Does it push notifications every day?
A: The system tries to push at 9:03 AM daily, but requires an active Claude Code session. If Claude Code isn't running, pending items are checked on next startup.

### Q: Can I delete or modify existing cognitive entries?
A: Yes, all entries are Markdown files you can edit directly. But we recommend viewing them via `/cognitive-db` first to avoid accidental deletion.
