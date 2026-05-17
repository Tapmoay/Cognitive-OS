# Cognitive OS 安装脚本
# 用法: .\setup.ps1 [-VaultPath "D:\MyVault"]
# 如果不指定 VaultPath，默认在当前目录下初始化

param(
    [string]$VaultPath = ""
)

$ErrorActionPreference = "Stop"

# 确定安装路径
if ($VaultPath -eq "") {
    $VaultPath = $PSScriptRoot
}

Write-Host "=== Cognitive OS 安装向导 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Claude Code 是否已安装
Write-Host "[1/4] 检查 Claude Code..." -ForegroundColor Yellow
$claudeCmd = Get-Command "claude" -ErrorAction SilentlyContinue
if (-not $claudeCmd) {
    Write-Host "  未检测到 Claude Code CLI。请先安装: https://docs.anthropic.com/en/docs/claude-code" -ForegroundColor Red
    Write-Host "  安装后重新运行此脚本。" -ForegroundColor Red
    exit 1
}
Write-Host "  已检测到 Claude Code: $($claudeCmd.Source)" -ForegroundColor Green

# 2. 创建 Vault 目录结构
Write-Host ""
Write-Host "[2/4] 初始化 Vault 目录结构..." -ForegroundColor Yellow

$dirs = @(
    "$VaultPath\memory\short-term",
    "$VaultPath\memory\long-term",
    "$VaultPath\cognitive-db\why-reasons",
    "$VaultPath\cognitive-db\how-methods",
    "$VaultPath\cognitive-db\cognitive-models",
    "$VaultPath\cognitive-db\decision-frameworks",
    "$VaultPath\cognitive-db\events",
    "$VaultPath\sessions",
    "$VaultPath\actions",
    "$VaultPath\.claude\commands"
)

foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "  创建: $dir" -ForegroundColor Gray
    } else {
        Write-Host "  已存在: $dir" -ForegroundColor DarkGray
    }
}

# 3. 初始化数据文件（仅当文件不存在时）
Write-Host ""
Write-Host "[3/4] 初始化数据文件..." -ForegroundColor Yellow

# user-profile.md
$userProfilePath = "$VaultPath\memory\user-profile.md"
if (-not (Test-Path $userProfilePath)) {
    @"
---
type: user-profile
last_updated: $(Get-Date -Format "yyyy-MM-dd")
version: 2
evolution_stage: 记录者
tags: []
---

## 基本信息
- 姓名: （对话中获取）
- 年龄: （对话中获取）

## 爱好
- （对话中获取）

## 擅长点
- [[擅长点1]] #strength/[类别]
- （对话中获取，用 [[双链]] 链接，添加 #strength/ 标签）

## 恐惧
- [[恐惧1]] #fear/[类别]
- （对话中获取，用 [[双链]] 链接，添加 #fear/ 标签）
- 克服后标记：~~[[旧恐惧]]~~ ← [日期] 已克服 #growth/里程碑

## 性格倾向
- （对话中获取）

## 核心价值观
- （对话中获取）

## 核心信念
- [[信念1]] #belief/[类别]
- （从 TEBAR 分析中提取，用 [[双链]] 链接，添加 #belief/ 标签，可用 [[session-name]] 引用来源会话）
- 信念被推翻时标记：~~[[旧信念]]~~ ← [日期] 已推翻 #growth/里程碑

## 决策偏好
- （对话中获取，从历史决策模式中提炼）

## 个人规律
- [[个人规律1]] #model/[类别]
- （从对话中组装的个人规律，双链引用）

## 反模式（反复踩的坑）
- [[反模式1]] #antipattern/[类别]
- （从 why-reasons 高频条目中提炼，可用 [[session-name]] 引用来源会话）

## 人生使命与长期愿景
- （深度反思中浮现，不在首次引导时收集）
"@ | Out-File -FilePath $userProfilePath -Encoding utf8
    Write-Host "  创建: memory\user-profile.md" -ForegroundColor Gray
} else {
    Write-Host "  已存在: memory\user-profile.md (跳过)" -ForegroundColor DarkGray
}

# growth-log.md
$growthLogPath = "$VaultPath\memory\growth-log.md"
if (-not (Test-Path $growthLogPath)) {
    @"
---
type: growth-log
last_updated: $(Get-Date -Format "yyyy-MM-dd")
total_assessments: 0
---

# 认知成长轨迹

## 阶段评估

（尚无评估。Reflection Agent 在 ``/cognitive-review`` 时自动检查是否需要生成阶段评估。）

### 阶段判定规则

| 阶段 | 判定条件 |
|------|---------|
| 记录者 | 短期记忆 < 10 条，cognitive-db 为空 |
| 思考者 | 短期记忆 ≥ 10 条，或 why-reasons ≥ 3 条 |
| 构建者 | cognitive-models ≥ 1 条，或 decision-frameworks ≥ 1 条（即拥有至少1条个人规律或个人策略） |
| 主导者 | 行为实验成功 ≥ 3 次，且个人策略 ≥ 1 条 |

判定时从高到低检查，取满足的最高阶段。

## 成长里程碑

（尚无里程碑。当用户克服恐惧、发现新模式、完成行为实验时自动记录。）

## 规律与策略演化

| 日期 | 变化 |
|------|------|
"@ | Out-File -FilePath $growthLogPath -Encoding utf8
    Write-Host "  创建: memory\growth-log.md" -ForegroundColor Gray
} else {
    Write-Host "  已存在: memory\growth-log.md (跳过)" -ForegroundColor DarkGray
}

# actions files
$actionFiles = @{
    "micro-actions.md" = @"
---
type: action-index
category: micro-actions
last_updated: $(Get-Date -Format "yyyy-MM-dd")
entry_count: 0
---

# 微行动

5 分钟内可完成的最小行动步骤。

## 条目列表

（尚无条目）
"@
    "experiments.md" = @"
---
type: action-index
category: experiments
last_updated: $(Get-Date -Format "yyyy-MM-dd")
entry_count: 0
---

# 行为实验

假设 → 实验 → 预期 → 实际，验证认知假设。

## 条目列表

（尚无条目）
"@
    "resistance-analysis.md" = @"
---
type: action-index
category: resistance-analysis
last_updated: $(Get-Date -Format "yyyy-MM-dd")
entry_count: 0
---

# 阻力分析

四维阻力拆解：情绪 / 认知 / 环境 / 隐藏收益。

## 条目列表

（尚无条目）
"@
    "feedback.md" = @"
---
type: action-index
category: feedback
last_updated: $(Get-Date -Format "yyyy-MM-dd")
entry_count: 0
---

# 结果反馈

行动执行后的结果追踪与反馈。

## 条目列表

（尚无条目）
"@
}

foreach ($file in $actionFiles.Keys) {
    $filePath = "$VaultPath\actions\$file"
    if (-not (Test-Path $filePath)) {
        $actionFiles[$file] | Out-File -FilePath $filePath -Encoding utf8
        Write-Host "  创建: actions\$file" -ForegroundColor Gray
    } else {
        Write-Host "  已存在: actions\$file (跳过)" -ForegroundColor DarkGray
    }
}

# cognitive-db templates
$templates = @{
    "why-reasons\_template.md" = @"
---
type: cognitive-entry
category: why-reasons
date: YYYY-MM-DD
reason_type: [emotion|failure|stuck]
frequency: 1
related_methods: []
tags: [#reason/[类别]]
source_session: []
---

## 原因：[名称]

### 触发场景
当 [条件] 时

### 原因分析
[为什么会产生这种情绪/失败/卡住]

### 涉及的信念
- [[信念1]]

### 关联的解决方法
- [[方法1]]

### 证据记录
- [YYYY-MM-DD]: [场景摘要]
"@
    "how-methods\_template.md" = @"
---
type: cognitive-entry
category: how-methods
date: YYYY-MM-DD
method_type: [thinking|behavior|coping|strategy]
applicable_reasons: []
tags: [#method/[类别]]
source_session: []
---

## 方法：[名称]

### 解决什么问题
[描述这个方法应对的原因/问题]

### 方法步骤
1. [步骤1]
2. [步骤2]

### 适用场景
- [场景1]

### 来源案例
- [YYYY-MM-DD]: [案例摘要]

### 效果记录
- [YYYY-MM-DD]: [效果评价]
"@
    "cognitive-models\_template.md" = @"
---
type: cognitive-model
category: cognitive-models
date: YYYY-MM-DD
model_type: [behavioral|emotional|cognitive]
source_reasons: []
source_methods: []
tags: [#model/[类别]]
source_session: []
---

## 个人规律：[名称]

一句话描述："我发现我总是[规律]"

### 触发条件
当 [条件组合] 时

### 因果链
[从多个 why-reasons 抽象出的通用因果链]

### 应对策略
1. [从 how-methods 提炼的步骤]

### 证据条目
- [[原因1]]
"@
    "decision-frameworks\_template.md" = @"
---
type: decision-framework
category: decision-frameworks
date: YYYY-MM-DD
framework_type: [daily|crisis|planning|relationship]
source_methods: []
tags: [#framework/[类别]]
source_session: []
---

## 个人策略：[名称]

一句话描述："下次遇到[场景]，我按这个步骤来"

### 适用场景
什么时候使用这个策略

### 决策步骤
1. [识别信号] — 从个人规律中匹配触发条件
2. [暂停自动反应]
3. [选择应对方式] — 从关联方法中选择
4. [执行]
5. [复盘记录]

### 关联个人规律
- [[个人规律1]]

### 关联方法
- [[方法1]]
"@
    "events\_template.md" = @"
---
type: cognitive-entry
category: events
date: YYYY-MM-DD
event_type: [turning-point|high-impact|recurring-milestone]
intensity: [1-10]
related_reasons: []
related_methods: []
tags: [#event/[类别]]
source_session: []
---

## 事件：[名称]

### 事件描述
[发生了什么]

### 时间线
- [时间点]: [发生了什么]

### 影响分析
[这件事对认知/情绪/行为产生了什么影响]

### 关联原因
- [[原因1]]

### 关联方法
- [[方法1]]

### 后续行动
- [ ] [待跟进事项]
"@
}

foreach ($file in $templates.Keys) {
    $filePath = "$VaultPath\cognitive-db\$file"
    if (-not (Test-Path $filePath)) {
        $templates[$file] | Out-File -FilePath $filePath -Encoding utf8
        Write-Host "  创建: cognitive-db\$file" -ForegroundColor Gray
    } else {
        Write-Host "  已存在: cognitive-db\$file (跳过)" -ForegroundColor DarkGray
    }
}

# sessions template (separate from cognitive-db)
$sessionTemplatePath = "$VaultPath\sessions\_template.md"
if (-not (Test-Path $sessionTemplatePath)) {
    @"
---
type: session
date: YYYY-MM-DD
session_id: session-YYYYMMDD-NNN
emotion: [主导情绪]
intensity: [1-10]
topics: [[主题1, 主题2]]
state_path: [ENTRY_RECORD → ... → 最终状态]
related_memory: []
related_cognitive: []
tags: [#session, #emotion/[情绪], #topic/[主题]]
---

## 摘要

[1-3 段结构化摘要：本次对话围绕什么展开，情绪如何变化，识别出什么核心问题]

关键洞察：
- [洞察1]
- [洞察2]

行动项：
- [ ] [行动1]
- [ ] [行动2]

---

## 完整对话

> **用户**: [消息]
> **系统**: [回复]

（完整对话原文）
"@ | Out-File -FilePath $sessionTemplatePath -Encoding utf8
    Write-Host "  创建: sessions\_template.md" -ForegroundColor Gray
} else {
    Write-Host "  已存在: sessions\_template.md (跳过)" -ForegroundColor DarkGray
}

# 4. 复制 Skills 和 Agents
Write-Host ""
Write-Host "[4/4] 安装 Skills 和 Agents..." -ForegroundColor Yellow

# 复制 skills 到项目的 .claude/commands/
$sourceCommands = "$PSScriptRoot\.claude\commands"
$targetCommands = "$VaultPath\.claude\commands"

if ($sourceCommands -ne $targetCommands) {
    $commandFiles = Get-ChildItem -Path $sourceCommands -Filter "cognitive*.md" -ErrorAction SilentlyContinue
    if ($commandFiles) {
        foreach ($file in $commandFiles) {
            $dest = Join-Path $targetCommands $file.Name
            Copy-Item -Path $file.FullName -Destination $dest -Force
            Write-Host "  安装 Skill: $($file.Name)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "  Skills 已在当前目录，跳过复制" -ForegroundColor DarkGray
}

# 复制 agents 到全局 ~/.claude/agents/
$homeDir = $env:USERPROFILE
$globalAgentsDir = "$homeDir\.claude\agents"

if (-not (Test-Path $globalAgentsDir)) {
    New-Item -ItemType Directory -Path $globalAgentsDir -Force | Out-Null
}

$agentNames = @(
    "emotion-agent.md",
    "cognitive-agent.md",
    "reflection-agent.md",
    "memory-agent.md",
    "pattern-detector.md",
    "action-agent.md",
    "sentinel-agent.md"
)

$agentsSourceDir = "$PSScriptRoot\agents"
# 也检查项目根目录的 agents 文件夹
if (-not (Test-Path $agentsSourceDir)) {
    $agentsSourceDir = "$PSScriptRoot\..\.claude\agents"
}

# 优先从项目 agents 目录查找，否则尝试全局 agents 目录
$agentInstalled = 0
foreach ($agentName in $agentNames) {
    # 尝试多个来源
    $sourcePath = ""
    $possiblePaths = @(
        "$PSScriptRoot\agents\$agentName",
        "$homeDir\.claude\agents\$agentName"
    )

    foreach ($p in $possiblePaths) {
        if (Test-Path $p) {
            $sourcePath = $p
            break
        }
    }

    if ($sourcePath -ne "" -and (Test-Path $sourcePath)) {
        $destPath = Join-Path $globalAgentsDir $agentName
        Copy-Item -Path $sourcePath -Destination $destPath -Force
        Write-Host "  安装 Agent: $agentName → $globalAgentsDir" -ForegroundColor Gray
        $agentInstalled++
    } else {
        Write-Host "  跳过 Agent: $agentName (未找到源文件)" -ForegroundColor DarkYellow
    }
}

if ($agentInstalled -lt $agentNames.Count) {
    Write-Host ""
    Write-Host "  注意: 部分 Agent 未自动安装。请手动将以下文件复制到 $globalAgentsDir :" -ForegroundColor DarkYellow
    foreach ($name in $agentNames) {
        $found = $false
        foreach ($p in @("$PSScriptRoot\agents\$name", "$homeDir\.claude\agents\$name")) {
            if (Test-Path $p) { $found = $true; break }
        }
        if (-not $found) {
            Write-Host "    - $name" -ForegroundColor DarkYellow
        }
    }
}

# 完成
Write-Host ""
Write-Host "=== 安装完成! ===" -ForegroundColor Green
Write-Host ""
Write-Host "Vault 位置: $VaultPath" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步:" -ForegroundColor White
Write-Host "  1. 在终端 cd 到 $VaultPath" -ForegroundColor White
Write-Host "  2. 运行 `claude` 启动 Claude Code" -ForegroundColor White
Write-Host "  3. 输入 /cognitive 开始使用" -ForegroundColor White
Write-Host ""
Write-Host "推荐: 用 Obsidian 打开 Vault 目录，可视化浏览认知数据。" -ForegroundColor DarkGray
