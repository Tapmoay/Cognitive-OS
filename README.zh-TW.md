# Cognitive OS

**內建於 Claude Code 的認知作業系統** — 幫你建構認知資產、認知系統、可持續調用的思維方式和方法。

[简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [English](README.md)

---

## 它能幫你做什麼？

- **零門檻記錄** — 隨意說話，系統自動理解並儲存
- **自動發現模式** — Pattern Engine 偵測你反覆出現的思維和行為模式
- **組裝可複用規律** — 「我發現我總是...」→ 個人規律
- **建構行動策略** — 「下次遇到 X，我按這個步驟來」→ 個人策略
- **追蹤成長軌跡** — 從記錄者到主導者，4 級進化自動評估

## 核心概念

### 6 階段循環

```
記錄 → 理解 → 提煉 → 建構 → 行動 → 進化
  ↑                                      |
  └──────────────────────────────────────┘
```

| 階段 | 你做什麼 | 系統做什麼 |
|------|---------|-----------|
| **記錄** | 隨意說話，描述感受/事件 | 儲存到短期記憶，輕量共情 |
| **理解** | 回答追問，把模糊變具體 | TEBAR 分析，提取原因和信念 |
| **提煉** | 累積多條同類原因/方法 | 自動提議「要不要整理一下？」 |
| **建構** | 同意整理 | 組裝個人規律/策略，寫入認知資料庫 |
| **行動** | 嘗試微行動或行為實驗 | 產生行動方案，追蹤執行結果 |
| **進化** | 持續使用系統 | 階段評估、里程碑記錄、成長視覺化 |

### 4 級進化階段

| 階段 | 判定條件 | 解鎖能力 |
|------|---------|---------|
| **記錄者** | 剛開始使用 | 基礎記錄 + 情緒容器 |
| **思考者** | 短期記憶 ≥ 10 條，或原因 ≥ 3 條 | 深度分析 + Pattern Engine + Action Agent |
| **建構者** | 個人規律 ≥ 1 條，或個人策略 ≥ 1 條 | 規律建構 + 策略組裝 + Reflection Agent |
| **主導者** | 行為實驗成功 ≥ 3 次，且個人策略 ≥ 1 條 | 全 Agent 可用 + 自主探索 |

### 6 種認知狀態（自動偵測）

| 狀態 | 訊號 | 系統行為 |
|------|------|---------|
| ENTRY_RECORD | 短輸入，無明確問題 | 輕量共情 + 記錄 |
| EMOTION_RELEASE | 強情緒詞，情緒 ≥ 7 | 情緒容器（先接住，不分析） |
| PROBLEM_EXPLORATION | 「我總是...」、「為什麼我...」 | 引導提問，找原因 |
| COGNITIVE_REFLECTION | 「我發現我...」、「好像每次...」 | 深度分析，連結已有規律 |
| ACTION_BLOCK | 「我就是做不到」、「改不掉」 | 停止說理，轉向行動 |
| FAILURE_REVIEW | 「又搞砸了」、「又失敗了」 | 複盤引導，歸因 + 方法修正 |

## 專案結構

```
CognitiveOS/
├── .claude/commands/          ← 8 個 Skill（Claude Code 命令）
│   ├── cognitive.md           ← 主入口 — 狀態偵測 + 策略路由
│   ├── cognitive-record.md    ← 快速記錄模式
│   ├── cognitive-analyze.md   ← 深度分析模式
│   ├── cognitive-review.md    ← 複盤反思模式
│   ├── cognitive-build.md     ← 明確建構觸發
│   ├── cognitive-db.md        ← 認知資料庫查詢（唯讀）
│   ├── cognitive-dashboard.md ← 儀表板產生
│   └── cognitive-check.md     ← 主動檢查 + 定時推送
│
├── agents/                    ← 7 個 Agent（由 Skill 調度）
│   ├── emotion-agent.md       ← 情緒辨識、拆分、強度評估
│   ├── cognitive-agent.md     ← TEBAR 因果鏈分析、信念提取
│   ├── reflection-agent.md    ← 頓悟產生、複盤引導、規律/策略建構
│   ├── memory-agent.md        ← 儲存決策、畫像更新、原因/方法提煉
│   ├── pattern-detector.md    ← 兩層 Pattern Engine（快速篩選 + 深度確認）
│   ├── action-agent.md        ← 微行動、行為實驗、阻力分析
│   └── sentinel-agent.md      ← 守夜人 — 異常偵測 + 定時推送
│
├── cognitive-db/              ← 5 個認知資料庫（Obsidian 雙鏈互關）
│   ├── why-reasons/           ← 為什麼難過/失敗/卡住
│   ├── how-methods/           ← 怎麼解決的思考方式和方法
│   ├── cognitive-models/      ← 個人規律 — 「我發現我總是...」
│   ├── decision-frameworks/   ← 個人策略 — 「下次遇到 X，我按這個步驟來」
│   └── events/                ← 轉折點、高影響、里程碑事件
│
├── memory/                    ← 記憶層
│   ├── short-term/            ← 短期記憶（近期對話）
│   ├── long-term/             ← 長期記憶（反覆出現的模式）
│   ├── user-profile.md        ← 使用者畫像（信念、偏好、規律）
│   └── growth-log.md          ← 成長軌跡（階段評估 + 里程碑）
│
├── actions/                   ← 行動追蹤
│   ├── micro-actions.md       ← 5 分鐘可完成的微行動
│   ├── experiments.md         ← 行為實驗
│   ├── resistance-analysis.md ← 四維阻力拆解
│   └── feedback.md            ← 行動結果回饋
│
├── docs/                      ← 設計文件
│   └── superpowers/specs/     ← 功能設計規範
│
├── setup.ps1                  ← 一鍵安裝腳本
├── GUIDE.md                   ← 詳細使用指南（簡體中文）
└── README.md                  ← 專案說明（English）
```

## 架構

```
Agent 層（分析 + 反思 + 行動）
    ↓
Skill 層（對話引導 + 狀態路由）
    ↓
儲存層（Markdown + Obsidian 雙鏈）
```

## 命令

| 命令 | 用途 | 最低階段 |
|------|------|---------|
| `/cognitive` | 主入口 — 自動偵測狀態 | 記錄者 |
| `/cognitive-record` | 快速記錄 | 記錄者 |
| `/cognitive-check` | 主動檢查待跟進事項 | 記錄者 |
| `/cognitive-analyze` | 深度分析 | 思考者 |
| `/cognitive-review` | 複盤反思 | 思考者 |
| `/cognitive-build` | 明確建構（通常自動觸發） | 建構者 |
| `/cognitive-db` | 查詢認知資料庫 | 記錄者 |
| `/cognitive-dashboard` | 產生儀表板 | 思考者 |

## 快速開始

```bash
# 1. 複製儲存庫
git clone https://github.com/Tapmoay/Cognitive-OS.git
cd Cognitive-OS

# 2. 執行安裝
.\setup.ps1

# 3. 啟動 Claude Code
claude

# 4. 開始使用
/cognitive
```

**前置需求：**
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) 已安裝並登入
- （推薦）[Obsidian](https://obsidian.md) 用於視覺化瀏覽認知資料

## 資料安全

所有資料儲存在本地檔案系統，不上傳任何外部伺服器。

## 文件

- [詳細使用指南（簡體中文）](GUIDE.md)
- [Detailed Usage Guide (English)](docs/en/GUIDE.md)
- [詳細使用指南（繁體中文）](docs/zh-tw/GUIDE.md)
- 設計文件：`docs/superpowers/specs/`

## 授權

MIT
