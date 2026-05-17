# Cognitive OS — Pattern Engine 设计文档

> 日期：2026-05-16
> 状态：已确认
> 前置：MVP + Action Layer 已完成

## 1. 概述

Pattern Engine 是 Cognitive OS 的模式发现系统，从用户记录中自动检测重复出现的认知模式。替代现有轻量版 Pattern Detector，升级为两层架构：规则快速筛选 + LLM 深度确认。

核心目标：从零散的短期记忆中，自动发现并确认重复的 trigger-emotion-belief-action 因果链。

## 2. 架构

### 两层架构

```
第一层：快速筛选（Quick Filter）
  触发：Memory Agent 写入短期记忆时自动运行
  方式：纯规则匹配（标签/关键词/YAML字段），零 LLM 消耗
  输出：标记 suspected_pattern 到短期记忆 frontmatter

第二层：深度确认（Deep Confirm）
  触发：/cognitive 启动时运行
  方式：LLM 读取疑似模式 + 长期记忆 + 已有模式，做语义分析
  输出：确认的模式写入 cognitive-db，通知 Strategy Router
```

### 扫描范围
- 快速筛选：最近 30 天短期记忆
- 深度确认：30 天短期（仅 suspected_pattern 记录）+ 全部长期记忆

### 混合触发时机
- 写入时 → 快速筛选（零成本标记）
- 启动时 → 深度确认（LLM 精确判断）

## 3. 快速筛选层（Quick Filter）

### 触发
Memory Agent 写入短期记忆后，自动 dispatch Pattern Detector 进入 quick-filter 模式。

### 检测规则

**1. Trigger 相似度匹配**
- 提取每条短期记忆的 `trigger` 字段
- 拆分为关键词（按中文分词/标点拆分）
- 同一关键词在多条记录中出现 ≥2 → 标记

**2. Emotion 类别匹配**
- 读取 `emotion` 字段
- 相同 emotion 在多条记录中出现 ≥2 → 标记

**3. Belief 关键词匹配**
- 读取 `tags` 中与信念相关的标签
- 相同标签 ≥2 → 标记

**4. 综合评分**
- 三个维度同时命中 ≥2 → `suspected_pattern: true` + `pattern_confidence: high`
- 仅一个维度命中 ≥2 → `suspected_pattern: true` + `pattern_confidence: low`

### 短期记忆 frontmatter 变化

```yaml
---
type: short-term-memory
date: 2026-05-16
emotion: 焦虑
trigger: "考试临近"
tags: [焦虑, 拖延, 完美主义]
suspected_pattern: true
pattern_confidence: high
pattern_dimensions: [trigger, emotion, belief]
---
```

### 限制
- 不调用 LLM
- 不写 cognitive-db
- 不触发状态切换
- 只做标记，等深度确认层处理

## 4. 深度确认层（Deep Confirm）

### 触发
`/cognitive` 启动时，在读取用户画像和短期记忆之后自动运行。仅在存在 `suspected_pattern: true` 记录时运行，无疑似模式时跳过（零消耗）。

### 输入
1. 所有 `suspected_pattern: true` 的短期记忆文件
2. `memory/long-term/` 全部文件
3. `cognitive-db/cognitive-patterns.md` 已有模式（避免重复）

### LLM 分析任务

**1. 模式确认**
- 读取疑似模式记录，判断是否真正存在重复模式
- 考虑语义相似性（"考试焦虑"和"面试焦虑"可能是同一模式）
- 输出：确认 / 否定

**2. 模式生成**
- 确认的模式，生成完整 TEBAR 因果链：`[Trigger] → [Emotion] → [Belief] → [Action] → [Result]`
- 识别中断点（哪个环节可以打破循环）
- 识别关联信念

**3. 模式去重**
- 对比 `cognitive-db/cognitive-patterns.md` 已有模式
- 已有模式有新证据 → 更新 frequency
- 全新模式 → 新增条目

### 输出

确认的模式：
1. 写入 `cognitive-db/cognitive-patterns.md`（新增或更新 frequency）
2. 通知 Strategy Router → 如果用户当前无状态 → 建议进入 ACTION_BLOCK
3. 相关短期记忆移除 `suspected_pattern` 标记

否定的疑似：
1. 移除 `suspected_pattern` 标记
2. 不写 cognitive-db

### LLM Prompt 结构

```
你是 Pattern Engine 的深度分析模块。

输入：
- 疑似模式记录：[读取的短期记忆]
- 已知长期模式：[读取的长期记忆]
- 已有认知模式：[读取的 cognitive-patterns.md]

任务：
1. 判断每条疑似模式是否为真正的重复模式
2. 对确认的模式，生成 TEBAR 因果链
3. 与已有模式对比，去重或更新

输出格式：
- confirmed: [模式列表，含 TEBAR 链]
- rejected: [否定列表，含原因]
- updated: [已有模式的更新]
```

### Token 消耗控制
- 只在有 `suspected_pattern: true` 记录时才运行
- 无疑似模式时跳过
- 每次最多分析 10 条疑似记录（超出取最近的 10 条）

## 5. 与现有系统集成

### /cognitive skill 启动流程更新

```
1. 读取 user-profile.md
2. 读取 short-term/ 最近 3 个文件
3. 读取 long-term/ 活跃模式
4. 🆕 深度确认：扫描 suspected_pattern 记录 → LLM 分析 → 确认/否定
5. 状态检测 → 策略路由 → 开始对话
```

### Memory Agent 更新

写入短期记忆后，dispatch Pattern Detector 快速筛选：
```
Memory Agent 写入短期记忆
  → dispatch pattern-detector mode=quick-filter
  → 标记 suspected_pattern（如有）
  → 不阻塞主流程
```

### Pattern Detector Agent 更新

现有单阶段 prompt 拆分为两阶段，通过 dispatch 参数指定模式：
```
dispatch pattern-detector mode=quick-filter   # 规则筛选（写入时触发）
dispatch pattern-detector mode=deep-confirm   # LLM 确认（启动时触发）
```

### 与 Action Layer 的连接

- 深度确认发现新模式 → 更新 `cognitive-db/cognitive-patterns.md`
- 模式与行动相关 → Strategy Router 建议进入 ACTION_BLOCK → Action Agent 接管
- Action Agent 的阻力分析和反馈结果 → 可作为 Pattern Engine 的新证据

### 数据流总览

```
用户对话
  → Memory Agent 写入短期记忆
  → Pattern Detector (quick-filter) 标记疑似
  → 下次 /cognitive 启动
  → Pattern Detector (deep-confirm) LLM 确认
  → 确认的模式 → cognitive-db/cognitive-patterns.md
  → 通知 Strategy Router → 可能触发 Action Agent
```

## 6. 实现范围

### 本次实现
- Pattern Detector agent prompt 重写（两阶段：quick-filter + deep-confirm）
- 快速筛选规则实现
- 短期记忆 frontmatter 新增字段（suspected_pattern, pattern_confidence, pattern_dimensions）
- /cognitive skill 启动流程新增深度确认步骤
- Memory Agent 更新（写入后触发 quick-filter）
- 深度确认 LLM prompt

### 不变
- actions/ 文件夹（无变化）
- 其他 Agent（无变化）
- 其他 Skills（无变化）
