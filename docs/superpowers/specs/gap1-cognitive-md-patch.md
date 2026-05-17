# Gap 1: cognitive.md 改动规范

本文档描述构建层实现后，需要对 `cognitive.md`（主入口命令）进行的改动。

## 1. 策略路由表格 — 新增行

在策略路由表格中新增一行：

| 状态 | 对话风格 | Agent 调用 | 存储目标 |
|------|---------|-----------|---------|
| 构建 | 深度整合 | Reflection Agent | cognitive-models/, decision-frameworks/ |

位置：插入在 FAILURE_REVIEW 行之后。

## 2. 数据连接部分 — 新增条目

在存储 → 数据连接部分新增：

- 构建的认知模型 → `cognitive-db/cognitive-models/`
- 构建的决策框架 → `cognitive-db/decision-frameworks/`
- 认知模型的 source_reasons / source_methods 双链 → 回指 why-reasons/ 和 how-methods/ 中的原始条目
- 决策框架的 source_methods 双链 → 回指 how-methods/ 中的原始条目

## 3. 启动流程 — 新增读取步骤

在启动流程第 3 步（读取 long-term）之后、第 4 步（读取 actions/）之前，新增：

4. 读取 `cognitive-db/cognitive-models/` — 已构建的认知模型（如有数据）
5. 读取 `cognitive-db/decision-frameworks/` — 已构建的决策框架（如有数据）

后续步骤编号顺延。

## 4. 追问引导规则 — 新增构建触发

在追问引导规则中，新增从"确认步骤"到"构建"的过渡：

6. **积累触发构建**：当同一 reason_type 积累 ≥3 条或 method_type 积累 ≥3 条 → 建议运行 `/cognitive-build`

## 5. 状态转移约束 — 新增构建出口

新增从构建状态的转移规则：

- 构建完成（认知模型或决策框架已确认）→ 回到 COGNITIVE_REFLECTION 或 ENTRY_RECORD
- 构建过程中发现新原因/方法 → 先存储到 why-reasons/how-methods，再继续构建
- 首次构建认知模型 → 触发 stage-assessment 检查是否晋升为"构建者"

## 实施说明

以上改动应在 cognitive.md 文件中直接编辑，不是创建新文件。改动应保持与现有文档风格一致。
