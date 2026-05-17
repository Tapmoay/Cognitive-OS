# 缺口 2 改动规范：事件库 + 策略库

> **日期**: 2026-05-17
> **状态**: 待实施
> **关联**: gap-analysis.md 缺口 2

---

## 改动总览

| 目标文件 | 改动类型 | 优先级 |
|---------|---------|--------|
| cognitive.md | 新增启动流程步骤 + 存储目标 + 数据连接 | P1 |
| memory-agent（dispatch 调用规范） | 新增 store-event 操作类型 | P1 |
| cognitive-db.md | 新增 events 类别查询 | P1 |
| cognitive-dashboard.md | 新增事件统计 | P1 |

---

## 1. cognitive.md 改动

### 1a. 启动流程新增步骤

在启动流程 Step 3（读取长期记忆）之后，新增：

```
3.5. 读取 `cognitive-db/events/` — 检查近期重要事件
      - 关注最近 30 天内 intensity ≥ 7 的事件
      - 关注 event_type: turning-point 的事件（无论时间）
      - 相关事件作为对话上下文准备
```

### 1b. 存储目标列新增

在策略路由表的"存储目标"列，为 ENTRY_RECORD 行追加：

| 状态 | 存储目标（更新后） |
|------|------------------|
| ENTRY_RECORD | 短期记忆；**遇到重要事件时同时写入 events/** |

判断"重要事件"的标准：
- 用户描述了人生方向改变的经历 → event_type: turning-point
- 用户表达的事件对认知/情绪产生重大影响 → event_type: high-impact
- 行为实验成功完成 → event_type: recurring-milestone

### 1c. 数据连接部分新增

在现有"数据连接"列表末尾追加：

```
- 重要事件 → 写入 `cognitive-db/events/`
- 事件关联原因时 → 在事件的 related_reasons 字段建立双链，同时在 why-reasons 条目的关联方法中反向引用
- 事件关联方法时 → 在事件的 related_methods 字段建立双链，同时在 how-methods 条目的来源案例中反向引用
```

---

## 2. memory-agent 改动

### 2a. 新增操作类型：store-event

在 Memory Agent 的操作类型中新增 `store-event`：

```
操作: store-event

事件名称:
[事件标题]

事件描述:
[发生了什么，摘要]

event_type: [turning-point|high-impact|recurring-milestone]
intensity: [1-10]

时间线:
- [时间点]: [发生了什么]

影响分析:
[对认知/情绪/行为的影响]

关联原因: [[原因1]], [[原因2]]
关联方法: [[方法1]]

后续行动:
- [ ] [待跟进事项]
```

event_type 判断规则：
- 用户描述"改变方向"、"从此以后"、"那一刻我决定"等转折性表述 → turning-point
- 用户描述的事件明显影响情绪状态或自我认知，且情绪强度 ≥ 7 → high-impact
- 行为实验成功完成、阶段晋升、克服恐惧等成长标记 → recurring-milestone

存储路径：`cognitive-db/events/YYYY-MM-DD-[事件简称].md`

---

## 3. cognitive-db.md 改动

### 3a. 可查询内容新增 events 类别

在"认知数据库"部分，从"2 个类别"更新为"3 个类别"：

```markdown
### 认知数据库（3 个类别）
- 原因库: `cognitive-db/why-reasons/` — 为什么难过/失败/卡住
- 方法库: `cognitive-db/how-methods/` — 怎么解决的思考方式和方法论
- 事件库: `cognitive-db/events/` — 重要事件、转折点、高影响经历
```

### 3b. 查询方式新增

在指定类别查询中，认知数据库类别更新为：

```
- 认知数据库类别：reasons, methods, events
```

### 3c. 无参数概览更新

概览中增加事件库条目数量统计。

---

## 4. cognitive-dashboard.md 改动

### 4a. 读取数据源新增

在读取数据源列表中，Step 6 之后新增：

```
7. `cognitive-db/events/` — 事件库
```

后续步骤编号顺延（原 7→8, 8→9, 9→10, 10→11）。

### 4b. Dashboard 生成模板新增事件统计

在"认知资产统计"部分，新增事件统计行：

```markdown
## 认知资产统计
- 原因：[N] 条
- 方法：[N] 条（含策略 [M] 条）
- 事件：[N] 条（转折点 [A] 条，高影响 [B] 条，里程碑 [C] 条）
```

在"已有方法"和"待跟进行动"之间，新增事件摘要：

```markdown
## 近期重要事件
- [[事件1]]（#event/[类别]）— intensity [N]/10，[日期]
- [[事件2]]（#event/[类别]）— intensity [N]/10，[日期]

（如果 events 无条目，显示"尚无记录的重要事件"）
```

事件按 intensity 降序排列，最多显示 5 条。

---

## event_type 标签规则

| event_type | 标签 | 含义 |
|-----------|------|------|
| turning-point | `#event/turning-point` | 转折点 — 人生方向改变的关键事件 |
| high-impact | `#event/high-impact` | 高影响 — 对认知/情绪产生重大影响的事件 |
| recurring-milestone | `#event/recurring-milestone` | 里程碑 — 反复出现的成长标记点 |
