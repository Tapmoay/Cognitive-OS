# Cognitive OS — Action Layer 设计文档

> 日期：2026-05-16
> 状态：已确认
> 前置：MVP 已完成（docs/superpowers/specs/2026-05-16-cognitive-os-design.md）

## 1. 概述

Action Layer 是 Cognitive OS 的行为干预系统，帮助用户从"理解"走向"改变"。包含两个新模块：

- **Pattern Detector**：轻量模式检测，扫描短期记忆发现重复模式
- **Action Agent**：行为干预，生成微行动、设计行为实验、分析阻力、收集反馈

新增 `actions/` 存储文件夹，与 `memory/`、`cognitive-db/` 同级。

核心闭环：微行动 → 行为实验 → 结果反馈 → 阻力分析 → 新微行动。

## 2. 架构

### 新增模块在现有架构中的位置

```
Agent 层（大脑）
    原有：Conversation Agent → State Detector → Strategy Router
    原有：Emotion Agent | Cognitive Agent | Reflection Agent | Memory Agent
    🆕 Pattern Detector（轻量模式检测）
    🆕 Action Agent（行为干预）
    ↓
Skills 层（能力模块，不变）
    /cognitive-record | /cognitive-analyze | /cognitive-review | /cognitive-db
    ↓
存储层
    memory/（不变）
    cognitive-db/（不变）
    🆕 actions/（新增：微行动 + 行为实验 + 阻力分析 + 反馈）
```

### 模块职责

**Pattern Detector** — 轻量模式检测
- 每次写入短期记忆时自动运行
- 扫描 `memory/short-term/` 最近 7 天文件
- 提取 trigger + emotion + core_belief
- 同一组合出现 ≥3 次 → 标记为重复模式
- 通知 Strategy Router 切换为 ACTION_BLOCK
- 更新 `cognitive-db/cognitive-patterns.md`

**Action Agent** — 行为干预
- 微行动生成：5 分钟内可完成的最小步骤
- 行为实验设计：假设→实验→预期→实际
- 阻力分析：情绪/认知/环境/隐藏收益四维
- 结果反馈：下次对话自动跟进，成功记入 cognitive-db，失败进入阻力分析

## 3. Pattern Detector 详细设计

### 触发时机
Memory Agent 每次写入短期记忆时自动运行。

### 检测逻辑
1. 读取 `memory/short-term/` 最近 7 天文件
2. 提取每条记录的 trigger + emotion + core_belief
3. 对比重复：同一 trigger-emotion-belief 组合出现 ≥3 次 → 标记为重复模式
4. 生成模式报告：`[trigger] → [emotion] → [belief] → [action]` 完整链路

### 输出
- 模式报告传递给 Action Agent，作为行为干预的输入
- 同时更新 `cognitive-db/cognitive-patterns.md`

### 与状态机的关系
- 检测到重复 → Strategy Router 自动切换为 ACTION_BLOCK
- 提示："我注意到这个模式已经出现好几次了，我们试试做点不同的事情？"

### 限制
- 关键词/标签级别匹配，不做语义相似度分析
- 只扫最近 7 天短期记忆
- 轻量版，未来可升级为完整 Pattern Engine

## 4. Action Agent 详细设计

### 4 种能力

#### 微行动生成
- **原则**：5 分钟内可完成
- **错误**："改变你的思维方式"
- **正确**："今晚只学5分钟"
- **来源**：从 TEBAR 分析中提取切入点
- **存储**：`actions/micro-actions.md`

#### 行为实验
- **结构**：假设 → 实验 → 预期 → 实际
- **假设**："我害怕失败所以拖延"
- **实验**："今天允许自己做不完美版"
- **验证**：下次对话时跟进结果
- **存储**：`actions/experiments.md`

#### 阻力分析
- **触发**：微行动没执行 / 实验失败
- **分析维度**：
  1. 情绪阻力（恐惧/焦虑）
  2. 认知阻力（信念障碍）
  3. 环境阻力（条件限制）
  4. 隐藏收益（逃避的好处）
- **存储**：`actions/resistance-analysis.md`

#### 结果反馈
- **时机**：下次对话自动跟进
- **问题**：做了吗？做了多少？感觉怎么样？和预期有什么不同？
- **成功 →** 记录方法论到 `cognitive-db/methodology-abstraction.md`
- **失败 →** 进入阻力分析
- **存储**：`actions/feedback.md`

### 闭环流程
```
Day 1 — 用户："我总是拖延" → Pattern Detector 检测到重复 ≥3 次
  → Action Agent 生成微行动："今晚只学5分钟"
  → 设计行为实验：假设"害怕不完美导致拖延" → 实验"允许自己做粗糙版"

Day 2 — 结果反馈跟进
  做了 → "感觉没那么难" → 方法论记入 cognitive-db
  没做 → 阻力分析 → "开始前焦虑太强" → 调整：先做1分钟 → 新微行动
```

## 5. actions/ 存储设计

### 目录结构

```
vault/
├── memory/           （不变）
├── cognitive-db/     （不变）
├── actions/          🆕
│   ├── micro-actions.md
│   ├── experiments.md
│   ├── resistance-analysis.md
│   └── feedback.md
```

### micro-actions.md

```markdown
---
type: action-index
category: micro-actions
last_updated: 2026-05-16
---

## 条目格式
---
type: micro-action
date: 2026-05-16
source_pattern: "高压力拖延"
status: pending | completed | failed
tags: []
---

### 行动
今晚只学5分钟

### 来源
TEBAR 分析：信念"必须学好" → 切入点：降低启动门槛

### 反馈
（待下次对话跟进）
```

### experiments.md

```markdown
---
type: action-index
category: experiments
last_updated: 2026-05-16
---

## 条目格式
---
type: experiment
date: 2026-05-16
hypothesis: "害怕不完美导致拖延"
status: pending | running | completed
related_pattern: "高压力拖延"
tags: []
---

### 假设
我拖延是因为害怕做不完美

### 实验
今天允许自己做一个"粗糙版"，不求完美

### 预期结果
开始行动后焦虑会降低

### 实际结果
（待跟进）

### 结论
（待填写）
```

### resistance-analysis.md

```markdown
---
type: action-index
category: resistance-analysis
last_updated: 2026-05-16
---

## 条目格式
---
type: resistance-analysis
date: 2026-05-16
related_action: "2026-05-16 学5分钟"
tags: []
---

### 未执行的行动
学5分钟

### 阻力分析
1. **情绪阻力**: 开始前焦虑强度 8/10
2. **认知阻力**: "5分钟没意义"
3. **环境阻力**: 手机在手边
4. **隐藏收益**: 刷视频暂时缓解焦虑

### 调整方案
- 降低到1分钟
- 把手机放到另一个房间
```

### feedback.md

```markdown
---
type: action-index
category: feedback
last_updated: 2026-05-16
---

## 条目格式
---
type: feedback
date: 2026-05-16
related_action: "2026-05-16 学5分钟"
outcome: success | partial | failed
tags: []
---

### 行动结果
做了5分钟，后来多做了10分钟

### 感受
开始时焦虑，开始后焦虑降低了

### 与预期对比
比预期好，行动本身缓解了焦虑

### 提炼
"启动比完美更重要" → 记入 cognitive-db/methodology-abstraction
```

## 6. 状态机更新

### 现有 6 种状态不变

新增 2 个触发机制：

#### Pattern Detector 触发自动状态切换
Pattern Detector 检测到重复模式（≥3次）→ Strategy Router 自动切换为 ACTION_BLOCK → 提示用户

#### Action Layer 内部状态流转
ACTION_BLOCK 状态进入后：
- Action Agent 生成微行动 / 行为实验
- 用户下次对话时：
  - 做了 → 反馈收集 → 成功记入 cognitive-db
  - 没做 → 阻力分析 → 调整方案 → 新微行动
  - 有新情绪 → 先切到 EMOTION_RELEASE（优先接住情绪）

### 状态优先级
```
EMOTION_RELEASE（最高优先）> ACTION_BLOCK > COGNITIVE_REFLECTION > 其他
```

### Strategy Router 更新

| 状态 | Agent 调用 | 存储目标 |
|------|-----------|---------|
| ACTION_BLOCK | Action Agent（微行动/实验） | actions/ + cognitive-db |
| + Pattern Detector 触发 | Action Agent（自动干预） | actions/ + cognitive-db |
| + 行动反馈（成功） | Reflection Agent（方法论提炼） | cognitive-db |
| + 行动反馈（失败） | Action Agent（阻力分析） | actions/ |

### /cognitive skill 启动流程更新
新增步骤：读取短期记忆 → Pattern Detector 扫描 → 如有重复模式 → 提示用户

## 7. 与现有系统的数据连接

- 行为实验成功 → 提炼的方法论写入 `cognitive-db/methodology-abstraction.md`
- 阻力分析发现的信念 → 写入 `cognitive-db/judgment-logic.md`
- 反馈闭环验证的规律 → 写入 `cognitive-db/reusable-rules.md`
- Pattern Detector 检测到的模式 → 写入 `cognitive-db/cognitive-patterns.md`

## 8. 实现范围

### 本次实现
- Pattern Detector（轻量模式检测 agent）
- Action Agent（4 种能力：微行动/实验/阻力/反馈）
- actions/ 文件夹 + 4 个文件模板
- /cognitive skill 更新（新增 Pattern Detector 扫描步骤）
- State Detector + Strategy Router 更新（ACTION_BLOCK 联动）
- Memory Agent 更新（写入短期记忆时触发 Pattern Detector）

### 后续迭代
- Pattern Engine（完整语义分析 + 跨 vault 扫描）
- 可视化（Obsidian 看板展示行动实验进度）
- 用户认知成长轨迹
