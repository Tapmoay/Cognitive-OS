---
description: 认知仪表盘 — 生成全量汇总页面，集中展示认知系统全貌
---

# Cognitive Dashboard

你是 Cognitive OS 的 Dashboard 生成器。你的任务是：读取所有认知数据，生成一个汇总页面 `dashboard.md`。

## 读取数据源

按顺序读取以下文件：

1. `memory/user-profile.md` — 用户画像
2. `memory/short-term/` — 最近 7 天的短期记忆（按日期排序）
3. `memory/long-term/` — 全部长期记忆
4. `memory/growth-log.md` — 成长轨迹
5. `cognitive-db/why-reasons/` — 原因库
6. `cognitive-db/how-methods/` — 方法库
7. `actions/micro-actions.md` — 微行动
8. `actions/experiments.md` — 行为实验
9. `actions/resistance-analysis.md` — 阻力分析
10. `actions/feedback.md` — 结果反馈

如果某个文件不存在或为空，跳过该数据源。

## 生成 Dashboard

生成以下内容，覆盖写入 `dashboard.md`：

```markdown
---
type: dashboard
last_updated: YYYY-MM-DD
generated_by: /cognitive-dashboard
---

# Cognitive OS Dashboard

## 用户画像概览
- 姓名：[从 user-profile 提取] | 性格：[性格倾向]
- 当前恐惧：[[恐惧1]] [[恐惧2]]
- 核心优势：[[优势1]] [[优势2]]

## 近期情绪趋势（最近7天）
| 日期 | 情绪 | 强度 | 触发 |
|------|------|------|------|
| [日期] | [情绪] | [强度]/10 | [[触发事件]] |

（如果最近7天无短期记忆，显示"暂无记录"）

## 活跃原因
- [[原因1]]（#reason/[类别]）— 出现 [N] 次，最近 [日期]
- [[原因2]]（#reason/[类别]）— 出现 [N] 次，最近 [日期]

（如果 why-reasons 无条目，显示"尚无识别的原因"）

## 已有方法
- [[方法1]]（#method/[类别]）— 解决 [[原因1]]
- [[方法2]]（#method/[类别]）— 解决 [[原因2]]

（如果 how-methods 无条目，显示"尚无提炼的方法"）

## 待跟进行动
- [ ] [微行动描述]（[日期] 生成，状态：pending）
- [ ] [实验描述]（[日期]，状态：running）

（如果无待跟进行动，显示"所有行动已完成"）

## 认知资产统计
- 原因：[N] 条
- 方法：[N] 条

## 近期成长
- [[日期]] [成长事件，用双链链接]
（从 growth-log.md 里程碑部分提取最近5条）

## 成长阶段
当前阶段：[从 growth-log.md 提取最新阶段评估]
```

## 生成规则

1. **双链**：页面中所有模式名、信念名、行动名都用 `[[双链]]` 包裹，点击可跳转到源文件
2. **标签**：不在 dashboard 中添加标签（dashboard 是汇总页，不是数据源）
3. **统计**：从各 cognitive-db 文件的 frontmatter `entry_count` 提取数量；如果无此字段，手动计算条目列表中的条目数
4. **排序**：情绪趋势按日期倒序，活跃模式按出现次数降序
5. **覆盖写入**：每次生成覆盖之前的 `dashboard.md`
6. **空数据**：如果某个数据源为空，在对应部分显示"暂无数据"

## 完成后

向用户展示 dashboard 摘要：
- 一句话总结用户当前状态
- 列出待跟进行动数量
- 提示用户可在 Obsidian 中查看完整 dashboard.md
