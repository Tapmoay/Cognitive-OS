---
type: spec
date: 2026-05-17
gap: 3
title: user-profile 增厚 — cognitive.md 改动规范
status: pending
---

# Gap 3: cognitive.md 改动规范

本文档描述 user-profile 增厚后，对 cognitive.md（认知操作系统主入口）需要的配套改动。

## 改动 1：首次使用引导 — 收敛收集范围

**位置**: `## 首次使用引导` 部分

**改动前**:
> 从第一次对话中提取用户画像信息，dispatch Memory Agent 更新。

**改动后**:
> 从第一次对话中只提取基本信息和核心价值观，dispatch Memory Agent 更新。不要主动询问核心信念、决策偏好、思维模型、反模式等深层字段——这些在后续对话中自然积累。

**理由**: 新增字段（核心信念、决策偏好等）属于深层认知信息，在用户尚未建立信任的首次对话中强行收集会造成压力，且信息质量低。首次引导只收集基本信息+核心价值观即可。

## 改动 2：存储部分 — TEBAR 分析提取信念自动更新 user-profile

**位置**: `## 存储` 部分

**新增规则**:
> TEBAR 分析提取到核心信念时，自动 dispatch Memory Agent（update-profile）更新 user-profile.md 的核心信念字段。

**依赖**: cognitive-agent 在完成 TEBAR 分析后，需要 dispatch Memory Agent 将提取的信念写入 user-profile 的核心信念部分。

## 改动 3：首次使用引导开场白 — 保持不变

**位置**: 首次使用引导的对话文本

**无改动**:
> "你好，我是你的认知助手。为了更好地帮助你，我想先了解一下你。你不用一次说完，我们慢慢来——能告诉我，最近让你最困扰的一件事是什么？"

这段开场白保持不变。后续对话中，通过自然交互逐步填充新增字段（核心信念、决策偏好、思维模型、反模式、进化阶段）。

## 改动 4：状态检测新增 — 进化阶段感知

**位置**: `## 状态检测` 之后

**新增说明**:
> 状态检测时读取 user-profile.md 的 evolution_stage 字段。如果用户处于"记录者"阶段，优先引导表达和记录；如果处于"思考者"阶段，可以更多引导自我觉察；如果处于"构建者"阶段，可以推进行动实验；如果处于"主导者"阶段，可以支持自主探索。
>
> 进化阶段由 reflection-agent 的 stage-assessment 判定后写入 user-profile，不在首次引导时设置。默认从"记录者"开始。

## 实施检查清单

- [ ] cognitive.md 首次使用引导部分：限制收集范围
- [ ] cognitive.md 存储部分：新增 TEBAR → update-profile 自动规则
- [ ] cognitive.md 状态检测部分：新增进化阶段感知说明
- [ ] memory-agent.md：新增字段自动填充规则（已同步更新）
- [ ] user-profile.md：升级到 v2 模板（已完成）
