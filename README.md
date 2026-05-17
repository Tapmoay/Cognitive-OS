# Cognitive OS

集成在 Claude Code 中的认知操作系统——帮你构建认知资产、认知系统、可持续调用的思维方式和方法。

## 它做什么

- **低门槛记录** — 随意说话，系统自动理解并存储
- **自动发现模式** — Pattern Engine 检测你反复出现的思维和行为模式
- **组装可复用规律** — "我发现我总是..." → 个人规律
- **构建行动策略** — "下次遇到X，我按这个步骤来" → 个人策略
- **追踪成长轨迹** — 从记录者到主导者，4 级进化自动评估

## 快速开始

```bash
# 1. 安装（首次使用）
.\setup.ps1

# 2. 启动 Claude Code
claude

# 3. 开始
/cognitive
```

## 核心概念

| 概念 | 说明 |
|------|------|
| 6 阶段循环 | 记录 → 理解 → 提炼 → 构建 → 行动 → 进化 |
| 4 进化阶段 | 记录者 → 思考者 → 构建者 → 主导者 |
| 6 认知状态 | 自动检测，自动切换策略 |
| 个人规律 | "我发现我总是..." — 可复用的自我认知 |
| 个人策略 | "下次遇到X，我按这个步骤来" — 可执行的行动框架 |

## 命令

| 命令 | 用途 |
|------|------|
| `/cognitive` | 主入口 |
| `/cognitive-record` | 快速记录 |
| `/cognitive-analyze` | 深度分析 |
| `/cognitive-review` | 复盘反思 |
| `/cognitive-build` | 构建规律/策略 |
| `/cognitive-db` | 查询认知数据库 |
| `/cognitive-dashboard` | 生成仪表盘 |
| `/cognitive-check` | 主动检查 |

## 架构

```
Agent 层（分析+反思+行动）
    ↓
Skill 层（对话引导+状态路由）
    ↓
存储层（Markdown + Obsidian 双链）
```

**7 个 Agent**：emotion / cognitive / reflection / memory / pattern-detector / action / sentinel

**8 个 Skill**：cognitive / record / analyze / review / build / db / dashboard / check

**5 个认知库**：why-reasons / how-methods / cognitive-models / decision-frameworks / events

## 数据安全

所有数据存储在本地文件系统，不上传外部服务器。

## 文档

- [使用指南](GUIDE.md) — 完整的使用说明
- `docs/superpowers/specs/` — 设计文档

## 要求

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- 推荐：[Obsidian](https://obsidian.md)（可视化浏览数据）
