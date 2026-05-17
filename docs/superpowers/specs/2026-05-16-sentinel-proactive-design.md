# Cognitive OS — Sentinel 主动推送系统 设计文档

> 日期：2026-05-16
> 状态：已确认
> 前置：MVP + Action Layer + Pattern Engine + 可视化+成长轨迹 已完成

## 1. 概述

Sentinel（守夜人）系统让 Cognitive OS 从被动响应变为主动关怀。通过 4 种触发机制，在合适的时机主动提醒用户关注待跟进事项、预警异常模式、建议周期性回顾、提供每日轻量建议。

核心理念：**不替代用户决定，但在用户忘记时主动出现。**

## 2. 架构

```
触发点                          执行者              输出
───────                        ──────              ────
1. /cognitive 启动         →   Sentinel Agent  →   启动报告（内嵌对话）
2. CronCreate 定时触发     →   /cognitive-check →   推送提醒
3. Memory Agent 写入时     →   内嵌轻量规则      →   即时预警
4. /cognitive-check 按需   →   Sentinel Agent  →   全面检查报告
```

数据流：

```
vault 数据（memory/ + cognitive-db/ + actions/）
        ↓ 读取
Sentinel Agent（检测规则引擎）
        ↓ 输出
Alert 报告（pending / anomaly / review / suggestion）
        ↓ 呈现
用户（对话中自然引入 / 独立推送 / 写入时即时提醒）
```

### 设计原则

- **Sentinel Agent 是只读的** — 只读取 vault 数据，不写入任何文件
- 检测到需要行动时，dispatch 其他 Agent 执行
- 不改变现有状态机和 Agent 调用链
- `/cognitive` 启动流程在现有步骤后追加 sentinel 检查

## 3. Sentinel Agent

### Agent 定义

- 路径：`~/.claude/agents/sentinel-agent.md`
- 角色：守夜人 — 扫描 vault 数据，检测需要关注的事项
- 只读，不写入任何文件

### 输入格式

```
检查类型: [full / startup / quick]
时间范围: [7d / 30d / all]
```

- `full`：运行全部 4 类规则（按需检查 + 定时触发时用）
- `startup`：运行 pending + anomaly（启动时快速检查，不生成 suggestion）
- `quick`：只运行 anomaly（Memory Agent 写入后快速检查）

### 4 类检测规则

#### 3.1 待跟进检测（pending）

扫描 `actions/` 目录：

| 条件 | 阈值 | 提醒内容 |
|------|------|---------|
| micro-actions.md 中 status: pending | 超过 1 天 | "你有一个待执行的微行动：[行动]" |
| experiments.md 中 status: running | 超过 3 天无反馈 | "行为实验 [实验] 已运行 N 天，有结果了吗？" |

#### 3.2 异常/风险预警（anomaly）

扫描短期记忆 + cognitive-db：

| 条件 | 阈值 | 提醒内容 |
|------|------|---------|
| 情绪连续走高 | 近 3 条短期记忆情绪强度 ≥7 | "你的情绪最近一直比较高，需要聊聊吗？" |
| 同一模式密集出现 | 同一 pattern 在近 7 天短期记忆中出现 ≥3 次 | "[模式] 最近频繁出现" |
| 行为实验连续失败 | 近 2 个 status: failed | "最近几次实验都没成功，可能需要重新评估方向" |
| 长期无记录 | 超过 7 天无新的短期记忆 | "好久没记录了，最近怎么样？" |

#### 3.3 周期性回顾提醒（review）

| 条件 | 阈值 | 提醒内容 |
|------|------|---------|
| 复盘提醒 | growth-log.md 的 last_updated 超过 7 天 | "该做阶段性复盘了" |
| 画像更新 | user-profile.md 的 last_updated 超过 30 天 | "用户画像可能需要更新了" |

#### 3.4 每日建议（suggestion）

基于用户画像和当前状态，生成 1-2 条轻量建议：

- 根据活跃模式 → "今天可以试试 [微行动]"
- 根据恐惧列表 → "有没有机会面对 [恐惧]？"
- 根据近期成功 → "上次 [实验] 成功了，试试类似方向？"

仅在 `full` 模式下生成。

### 输出格式

```markdown
## Sentinel 检查报告

**检查时间**: YYYY-MM-DD HH:mm
**检查类型**: full

### 🔴 需要关注
- [anomaly] 情绪连续走高（近3次记录强度≥7）
- [pending] 微行动"今晚学5分钟"已待执行2天

### 🟡 建议行动
- [review] 距上次复盘已9天，建议 `/cognitive-review`
- [suggestion] 今天可以试试：[微行动描述]

### 🟢 一切正常
- 无活跃预警
- 行为实验进行中
```

## 4. 触发机制

### 4.1 启动增强（/cognitive）

在 `/cognitive` 现有启动流程（读 user-profile → 读短期记忆 → 读长期记忆 → 检查待跟进行动 → Pattern Engine 深度确认）之后，追加：

**第 6 步：Sentinel 启动检查**

使用 Agent tool，subagent_type 为 "sentinel-agent"，prompt：
```
检查类型: startup
时间范围: 7d
```

- 如果有 🔴 需要关注项，立即告知用户
- 如果有 🟡 建议行动，自然引入对话
- 如果全部 🟢，不主动提及（避免打扰）

**第 7 步：CronCreate 续期检查**

1. 用 CronList 查看是否有活跃的 sentinel job（过期的 job 不会出现在 CronList 中，因此无需手动清理）
2. 如果没有 → CronCreate 创建每日提醒 job：
   - cron: "3 9 * * *"（每天早上 9:03 本地时间）
   - prompt: "执行 /cognitive-check，检查待跟进行动、异常预警、周期回顾提醒，生成每日建议。如果有待跟进事项，推送提醒。"
   - recurring: true
   - durable: true
3. 如果已有 → 跳过

### 4.2 CronCreate 定时推送

**每日提醒 Job**：
- cron: `3 9 * * *`（每天早上 9:03 本地时间）
- prompt: "执行 /cognitive-check，检查待跟进行动、异常预警、周期回顾提醒，生成每日建议。如果有待跟进事项，推送提醒。"
- recurring: true
- durable: true

**关键约束**：
- CronCreate 的 recurring 任务 7 天后自动过期
- `/cognitive` 启动时自动续期
- 如果 7 天内没有打开 `/cognitive`，定时任务自然过期（用户没在用系统就不打扰）
- 提醒只在 REPL idle 时触发，不会打断正在进行的对话

### 4.3 写入时实时检测

在 Memory Agent 写入短期记忆后，添加轻量级内嵌规则（不 dispatch Sentinel Agent，零额外 Agent 调用）：

```
写入后检查：
1. 如果本条记录 intensity ≥ 7，检查近3条是否都 ≥7 → 标记 anomaly
2. 如果本条记录关联的 pattern 在近7天出现 ≥3次 → 标记 anomaly
3. 如果检测到 anomaly，在存储确认后自然提醒用户
```

这些规则直接写在 Memory Agent prompt 中，作为写入后检查步骤。Memory Agent 执行此检查时需要重新读取 `memory/short-term/` 目录中最近的文件来判断阈值条件。

### 4.4 按需检查（/cognitive-check）

新增 Skill，读取全量数据后 dispatch Sentinel Agent（full 模式），呈现完整报告。

## 5. /cognitive-check Skill

### 定义

- 路径：`.claude/commands/cognitive-check.md`
- 功能：按需全面检查 + CronCreate 定时触发的执行入口

### 参数

- 无参数：运行 full 检查
- `quick`：只运行 anomaly 检测

### 读取范围

- `memory/user-profile.md`
- `memory/short-term/`（最近 7 天）
- `memory/long-term/`
- `memory/growth-log.md`
- `cognitive-db/` 全部 8 个文件
- `actions/` 全部 4 个文件

### 行为

1. 读取全部数据源
2. Dispatch Sentinel Agent（full 模式）
3. 呈现检查报告
4. 如果有需要行动的事项，询问用户是否要立即处理

## 6. 通知呈现格式

根据触发场景不同，呈现方式有区别：

**启动时（/cognitive 内）**：自然嵌入对话开头
```
"对了，你上次说试试 [行动]，试了吗？另外最近 [模式] 出现得比较频繁。"
```

**定时推送（CronCreate）**：简洁推送
```
☀️ 早安检查：
- 待跟进：[微行动] 已待执行2天
- 提醒：距上次复盘已9天
- 今日建议：试试 [小行动]
```

**按需检查（/cognitive-check）**：完整报告（🔴 🟡 🟢 三级）

**写入时预警（Memory Agent 内）**：轻量即时提醒
```
"注意：你的焦虑已经连续3次记录都在7分以上了，要不要聊聊？"
```

## 7. 实现范围

### 新增文件

| 文件 | 说明 |
|------|------|
| `~/.claude/agents/sentinel-agent.md` | 守夜人 Agent — 4 类检测规则 + 输出格式 |
| `.claude/commands/cognitive-check.md` | 按需检查 Skill |

### 修改文件

| 文件 | 变更 |
|------|------|
| `.claude/commands/cognitive.md` | 启动流程追加第 6 步（Sentinel 检查）+ 第 7 步（CronCreate 续期） |
| `~/.claude/agents/memory-agent.md` | 写入短期记忆后追加轻量异常检测规则 |

### 不变

- 状态机（6 种状态不变）
- Pattern Detector / Pattern Engine（不变）
- Cognitive Agent / Emotion Agent / Reflection Agent / Action Agent（不变）
- 认知数据库文件结构（不变）
- 已有的 `/cognitive-record`、`/cognitive-analyze`、`/cognitive-review`、`/cognitive-dashboard`、`/cognitive-db`（不变）

### 不做什么

- 不做手机推送（CronCreate 只在 REPL idle 时触发）
- 不做 Obsidian 通知（跨系统限制）
- 不做自动执行行动（只提醒，不代替用户决定）
- 不做情绪预测（只检测已发生异常，不预测未来）
