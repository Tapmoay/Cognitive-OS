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
5. `cognitive-db/why-reasons/` 和 `cognitive-db/how-methods/`
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
