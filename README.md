# Cognitive OS

**A cognitive operating system built into Claude Code** — helping you build cognitive assets, cognitive systems, and sustainably reusable thinking methods.

[简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | English

---

## What Can It Help You Do?

- **Record with zero friction** — Just talk. The system automatically understands and stores your thoughts.
- **Discover patterns automatically** — Pattern Engine detects recurring thinking and behavioral patterns.
- **Build reusable personal patterns** — "I notice I always..." → Personal Pattern
- **Construct action strategies** — "Next time I encounter X, I'll follow these steps" → Personal Strategy
- **Track your growth** — From Recorder to Leader, 4-stage evolution with automatic assessment.

## Core Concepts

### 6-Stage Loop

```
Record → Understand → Extract → Build → Act → Evolve
  ↑                                            |
  └────────────────────────────────────────────┘
```

| Stage | What You Do | What The System Does |
|-------|------------|---------------------|
| **Record** | Speak freely about feelings/events | Store to short-term memory, light empathy |
| **Understand** | Answer follow-up questions | TEBAR analysis, extract reasons and beliefs |
| **Extract** | Accumulate similar reasons/methods | Auto-propose organizing into patterns |
| **Build** | Agree to organize | Assemble personal patterns/strategies |
| **Act** | Try micro-actions or experiments | Generate action plans, track results |
| **Evolve** | Continue using the system | Stage assessment, milestones, growth visualization |

### 4 Evolution Stages

| Stage | Criteria | Unlocked Capabilities |
|-------|----------|----------------------|
| **Recorder** | Just started | Basic recording + Emotion Container |
| **Thinker** | Short-term memory ≥ 10, or reasons ≥ 3 | Deep analysis + Pattern Engine + Action Agent |
| **Builder** | Personal patterns ≥ 1, or strategies ≥ 1 | Pattern building + Strategy assembly + Reflection Agent |
| **Leader** | Successful experiments ≥ 3, and strategies ≥ 1 | All Agents available + Autonomous exploration |

### 6 Cognitive States (Auto-Detected)

| State | Signal | System Response |
|-------|--------|----------------|
| ENTRY_RECORD | Short input, no clear question | Light empathy + recording |
| EMOTION_RELEASE | Strong emotion words, intensity ≥ 7 | Emotion Container (hold first, don't analyze) |
| PROBLEM_EXPLORATION | "I always...", "Why do I..." | Guided questioning, find reasons |
| COGNITIVE_REFLECTION | "I notice I...", "Seems like every time..." | Deep analysis, connect existing patterns |
| ACTION_BLOCK | "I just can't do it", "Can't change" | Stop reasoning, shift to action |
| FAILURE_REVIEW | "Screwed up again", "Failed again" | Review guidance, attribution + method correction |

## Project Structure

```
CognitiveOS/
├── .claude/commands/          ← 8 Skills (Claude Code commands)
│   ├── cognitive.md           ← Main entry — state detection + strategy routing
│   ├── cognitive-record.md    ← Quick record mode
│   ├── cognitive-analyze.md   ← Deep analysis mode
│   ├── cognitive-review.md    ← Review & reflection mode
│   ├── cognitive-build.md     ← Explicit build trigger
│   ├── cognitive-db.md        ← Cognitive database query (read-only)
│   ├── cognitive-dashboard.md ← Dashboard generation
│   └── cognitive-check.md     ← Active check + scheduled push
│
├── agents/                    ← 7 Agents (dispatched by Skills)
│   ├── emotion-agent.md       ← Emotion identification, splitting, intensity assessment
│   ├── cognitive-agent.md     ← TEBAR causal chain analysis, belief extraction
│   ├── reflection-agent.md    ← Insights, failure review, pattern/strategy building
│   ├── memory-agent.md        ← Storage decisions, profile updates, reason/method extraction
│   ├── pattern-detector.md    ← Two-layer Pattern Engine (quick-filter + deep-confirm)
│   ├── action-agent.md        ← Micro-actions, experiments, resistance analysis
│   └── sentinel-agent.md      ← Watchman — anomaly detection + scheduled push
│
├── cognitive-db/              ← 5 Cognitive Databases (Obsidian-linked)
│   ├── why-reasons/           ← Why I feel bad / fail / get stuck
│   ├── how-methods/           ← How I solved it — thinking methods and approaches
│   ├── cognitive-models/      ← Personal Patterns — "I notice I always..."
│   ├── decision-frameworks/   ← Personal Strategies — "Next time X, I follow these steps"
│   └── events/                ← Turning points, high-impact, milestone events
│
├── memory/                    ← Memory Layer
│   ├── short-term/            ← Short-term memory (recent conversations)
│   ├── long-term/             ← Long-term memory (recurring patterns)
│   ├── user-profile.md        ← User profile (beliefs, preferences, patterns)
│   └── growth-log.md          ← Growth trajectory (assessments + milestones)
│
├── actions/                   ← Action Tracking
│   ├── micro-actions.md       ← 5-minute actionable steps
│   ├── experiments.md         ← Behavioral experiments
│   ├── resistance-analysis.md ← 4-dimension resistance breakdown
│   └── feedback.md            ← Action result tracking
│
├── docs/                      ← Design Documents
│   └── superpowers/specs/     ← Feature design specs
│
├── setup.ps1                  ← One-click installation script
├── GUIDE.md                   ← Detailed usage guide (Simplified Chinese)
└── README.md                  ← This file
```

## Architecture

```
Agent Layer (analysis + reflection + action)
    ↓
Skill Layer (conversation guidance + state routing)
    ↓
Storage Layer (Markdown + Obsidian wikilinks)
```

## Commands

| Command | Purpose | Min. Stage |
|---------|---------|-----------|
| `/cognitive` | Main entry — auto-detect state and start conversation | Recorder |
| `/cognitive-record` | Quick record mode | Recorder |
| `/cognitive-check` | Active check for pending items | Recorder |
| `/cognitive-analyze` | Deep analysis mode | Thinker |
| `/cognitive-review` | Review & reflection mode | Thinker |
| `/cognitive-build` | Explicit build trigger (usually auto-triggered) | Builder |
| `/cognitive-db` | Query cognitive database | Recorder |
| `/cognitive-dashboard` | Generate dashboard | Thinker |

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/Tapmoay/Cognitive-OS.git
cd Cognitive-OS

# 2. Run installation
.\setup.ps1

# 3. Start Claude Code
claude

# 4. Begin
/cognitive
```

**Requirements:**
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and logged in
- (Recommended) [Obsidian](https://obsidian.md) for visualizing your cognitive data

## Data Safety

All data is stored in your local file system. No data is uploaded to any external server.

## Documentation

- [Detailed Usage Guide (Simplified Chinese)](GUIDE.md)
- [Detailed Usage Guide (English)](docs/en/GUIDE.md)
- [Detailed Usage Guide (Traditional Chinese)](docs/zh-tw/GUIDE.md)
- Design specs: `docs/superpowers/specs/`

## License

MIT
