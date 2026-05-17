# Cognitive OS — 詳細使用指南

[简体中文](../../GUIDE.md) | [繁體中文](../zh-tw/GUIDE.md) | [English](../en/GUIDE.md)

---

## 什麼是 Cognitive OS？

Cognitive OS 是一個運行在 Claude Code 中的認知作業系統。它幫你：

- **記錄** — 低門檻記錄情緒、事件、想法
- **理解** — 自動分析原因、發現重複模式
- **提煉** — 把散落的經驗濃縮成原因和方法
- **建構** — 組裝可複用的個人規律和策略
- **行動** — 產生微行動、設計行為實驗
- **進化** — 追蹤成長軌跡，階段性升級

整個系統以 **對話** 為核心互動方式，你只需要說話，AI 會判斷你當前需要什麼。

---

## 前置需求

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) 已安裝並登入
- （推薦）[Obsidian](https://obsidian.md) 用於視覺化瀏覽認知資料（非必需）

---

## 安裝

### 方式零：AI 指令部署（最快）

直接把下面的指令複製貼上到你的 AI 工具中，它會自動幫你完成所有操作：

**Claude Code 使用者**，開啟 Claude Code 後貼上：

```
複製 https://github.com/Tapmoay/Cognitive-OS 到我指定的目錄，然後將 agents/ 目錄下的所有 .md 檔案複製到 ~/.claude/agents/，再執行 setup.ps1 初始化 vault。完成後告訴我可以用 /cognitive 開始。
```

**Codex 使用者**，開啟 Codex 後貼上：

```
複製 https://github.com/Tapmoay/Cognitive-OS 並部署：將 agents/ 目錄下所有檔案複製到 ~/.claude/agents/，然後執行安裝腳本初始化 vault 目錄結構。完成後確認。
```

### 方式一：一鍵安裝

```powershell
# 複製或下載專案後，在專案目錄下執行
.\setup.ps1

# 或指定自訂 Vault 路徑
.\setup.ps1 -VaultPath "D:\MyCognitiveVault"
```

安裝腳本會自動：
1. 檢查 Claude Code 是否可用
2. 建立 Vault 目錄結構
3. 初始化資料檔案
4. 安裝 Skills 到專案 `.claude/commands/`
5. 安裝 Agents 到全域 `~/.claude/agents/`

### 方式二：手動安裝

1. **建立 Vault 目錄**

```
你的Vault/
├── memory/
│   ├── short-term/
│   ├── long-term/
│   ├── user-profile.md
│   └── growth-log.md
├── cognitive-db/
│   ├── why-reasons/
│   ├── how-methods/
│   ├── cognitive-models/
│   ├── decision-frameworks/
│   └── events/
├── actions/
│   ├── micro-actions.md
│   ├── experiments.md
│   ├── resistance-analysis.md
│   └── feedback.md
├── .claude/
│   └── commands/        ← 將 8 個 skill 檔案複製到此
```

2. **複製 Agents**

將以下 7 個 Agent 檔案複製到 `~/.claude/agents/`：

| Agent 檔案 | 用途 |
|-----------|------|
| emotion-agent.md | 情緒辨識與拆分 |
| cognitive-agent.md | TEBAR 因果鏈分析 |
| reflection-agent.md | 頓悟產生、複盤引導、規律/策略建構 |
| memory-agent.md | 儲存決策與畫像更新 |
| pattern-detector.md | 模式偵測（兩層引擎） |
| action-agent.md | 行為介入與實驗設計 |
| sentinel-agent.md | 守夜人 — 異常偵測 + 定時推送 |

---

## 快速開始

```bash
# 1. 進入 Vault 目錄
cd 你的Vault路徑

# 2. 啟動 Claude Code
claude

# 3. 輸入命令開始
/cognitive
```

首次使用時，系統會自動辨識你是新使用者，進入引導模式，幫你建立基本畫像。

---

## 命令一覽

| 命令 | 用途 | 最低階段 |
|------|------|---------|
| `/cognitive` | 主入口，自動偵測狀態並開始對話 | 記錄者 |
| `/cognitive-record` | 快速記錄模式 | 記錄者 |
| `/cognitive-check` | 主動檢查待跟進事項 | 記錄者 |
| `/cognitive-analyze` | 深度分析模式 | 思考者 |
| `/cognitive-review` | 複盤反思模式 | 思考者 |
| `/cognitive-build` | 明確建構觸發（通常自動觸發） | 建構者 |
| `/cognitive-db` | 查詢認知資料庫 | 記錄者 |
| `/cognitive-dashboard` | 產生儀表板摘要 | 思考者 |

你不需要記住所有命令——大多數時候只需要 `/cognitive`，系統會根據你的輸入自動選擇合適的策略。

---

## 成長過程：6 階段循環

```
記錄 → 理解 → 提煉 → 建構 → 行動 → 進化
  ↑                                      |
  └──────────────────────────────────────┘
```

### 每個階段發生了什麼

| 階段 | 你做什麼 | 系統做什麼 |
|------|---------|-----------|
| **記錄** | 隨意說話，描述感受/事件 | 儲存到短期記憶，輕量共情 |
| **理解** | 回答追問，把模糊變具體 | TEBAR 分析，提取原因和信念 |
| **提煉** | 累積多條同類原因/方法 | 自動提議「要不要整理一下？」 |
| **建構** | 同意整理 | 組裝個人規律/策略，寫入認知資料庫 |
| **行動** | 嘗試微行動或行為實驗 | 產生行動方案，追蹤執行結果 |
| **進化** | 持續使用系統 | 階段評估、里程碑記錄、成長視覺化 |

---

## 成長階段：4 級進化

隨著你的認知資產累積，系統會自動評估並通知你階段晉升：

| 階段 | 判定條件 | 解鎖能力 |
|------|---------|---------|
| **記錄者** | 剛開始使用 | 基礎記錄 + 情緒容器 |
| **思考者** | 短期記憶 ≥ 10 條，或原因 ≥ 3 條 | 深度分析 + Pattern Engine + Action Agent |
| **建構者** | 個人規律 ≥ 1 條，或個人策略 ≥ 1 條 | 規律建構 + 策略組裝 + Reflection Agent |
| **主導者** | 行為實驗成功 ≥ 3 次，且個人策略 ≥ 1 條 | 全 Agent 可用 + 自主探索 |

**階段晉升是自動的**——你只需要持續使用，系統會在合適的時機告訴你升級了。

### 階段行為矩陣

| 維度 | 記錄者 | 思考者 | 建構者 | 主導者 |
|------|--------|--------|--------|--------|
| 追問深度 | 1 層 | 2 層 | 3 層 | 無限 |
| 情緒容器 | 優先，不追問 | 共情後溫和追問 | 共情後直接引入分析 | 共情後快速切入策略 |
| 主動建議 | 不主動 | 偶爾建議 | 主動建議建構 | 按需提供 |
| Agent 存取 | Emotion only | + Cognitive, Action | + Reflection | 全 Agent |
| Pattern Engine | 關閉 | 啟動時執行 | 寫入時 + 啟動時 | 寫入時 + 啟動時 + 主動 |

---

## 認知資料庫

你的認知資產儲存在以下 5 個庫中，全部用 Obsidian 雙鏈互相關聯：

| 庫 | 路徑 | 存什麼 |
|----|------|-------|
| 原因庫 | `cognitive-db/why-reasons/` | 為什麼難過/失敗/卡住 |
| 方法庫 | `cognitive-db/how-methods/` | 怎麼解決的思考方式和方法 |
| 個人規律 | `cognitive-db/cognitive-models/` | 「我發現我總是...」的可複用規律 |
| 個人策略 | `cognitive-db/decision-frameworks/` | 「下次遇到 X，我按這個步驟來」 |
| 事件庫 | `cognitive-db/events/` | 轉折點、高影響、里程碑事件 |

### 建構觸發

建構 **不需要** 手動操作。當同類原因/方法累積 ≥ 3 條時，系統會在對話中自然提議：

> 「我發現你總是 [模式]，要不要把它整理一下，下次直接用？」

你也可以隨時用 `/cognitive-build` 明確觸發。

### 資料連接

所有資料庫透過雙鏈（`[[條目名稱]]`）互相連結：

- 行為實驗成功 → 提煉的方法寫入 `how-methods/`
- 阻力分析發現的信念 → 關聯到 `why-reasons/` 的涉及信念
- Pattern Engine 偵測到的模式 → 寫入 `why-reasons/`（reason_type: stuck）
- 個人規律 → `cognitive-models/`（source_reasons / source_methods 雙鏈回指）
- 個人策略 → `decision-frameworks/`（source_methods 雙鏈回指）

---

## 查詢你的資料

```
/cognitive-db                    — 概覽：畫像摘要 + 各庫數量 + 待跟進
/cognitive-db profile            — 完整使用者畫像
/cognitive-db reasons            — 檢視所有原因
/cognitive-db methods            — 檢視所有方法
/cognitive-db models             — 檢視所有個人規律
/cognitive-db frameworks         — 檢視所有個人策略
/cognitive-db actions            — 檢視行動記錄
/cognitive-db pending            — 檢視待跟進的微行動和實驗
/cognitive-db growth             — 檢視成長軌跡
/cognitive-db search [關鍵詞]    — 全庫搜尋
/cognitive-db dashboard          — 檢視儀表板
```

---

## 6 種認知狀態

系統會自動偵測你當前的狀態，選擇最合適的對話方式：

| 狀態 | 訊號 | 系統行為 |
|------|------|---------|
| **ENTRY_RECORD** | 短輸入，無明確問題 | 輕量共情 + 記錄 |
| **EMOTION_RELEASE** | 強情緒詞，情緒 ≥ 7 | 情緒容器（先接住，不分析） |
| **PROBLEM_EXPLORATION** | 「我總是...」、「為什麼我...」 | 引導提問，找原因 |
| **COGNITIVE_REFLECTION** | 「我發現我...」、「好像每次...」 | 深度分析，連結已有規律 |
| **ACTION_BLOCK** | 「我就是做不到」、「改不掉」 | 停止說理，轉向行動 |
| **FAILURE_REVIEW** | 「又搞砸了」、「又失敗了」 | 複盤引導，歸因 + 方法修正 |

你不需要判斷自己處於什麼狀態——只需要說你想說的。

### 情緒容器

當偵測到強烈情緒時，系統會啟動情緒容器：

1. **先共情** — 「聽起來你現在很難受。」不問「為什麼」，不給建議。
2. **幫助落地**（如需要）— 「你現在在哪裡？」
3. **溫和追問**（情緒緩和後，按階段閾值控制）— 「你覺得是什麼讓你這麼難受？」
4. **等待降溫**（超過閾值時）— 不急於進入任何分析模式。

---

## 行動層

當你處於「知道問題但做不到」的狀態時，系統會切換到行動模式：

### 微行動
5 分鐘內可完成的最小行動步驟。降低行動門檻。

### 行為實驗
假設 → 實驗 → 預期 → 實際。用科學方法驗證認知假設。

### 阻力分析
四維拆解：情緒阻力 / 認知阻力 / 環境阻力 / 隱藏收益。

### 結果回饋
追蹤行動結果，成功則提煉方法，失敗則分析阻力並產生新行動。

---

## 定時推送

系統會在每天早上 9:03 自動檢查：
- 待跟進的微行動和實驗
- 異常預警（如長期未記錄、情緒持續走低）
- 週期回顧提醒

需要保持 Claude Code 工作階段活躍才能收到推送。如果沒開 Claude Code，下次啟動時會自動檢查待跟進事項。

---

## 典型使用情境

### 情境 1：心情不好，想傾訴

```
/cognitive
> 今天特別煩

系統：辨識為 EMOTION_RELEASE → 情緒容器模式
→ 先共情，不分析，等情緒緩和後溫和追問
```

### 情境 2：發現自己總是同一個模式

```
/cognitive
> 我發現我每次面對新任務都先拖延，然後焦慮

系統：辨識為 COGNITIVE_REFLECTION → 深度分析
→ TEBAR 因果鏈分析 → 提取原因 → 檢查是否累積了足夠條目觸發建構
```

### 情境 3：知道問題但做不到

```
/cognitive
> 我知道應該早睡但就是做不到

系統：辨識為 ACTION_BLOCK → 行動模式
→ 檢查是否有匹配的個人策略 → 產生微行動
```

### 情境 4：想複盤一次失敗

```
/cognitive-review
> 昨天的面試又搞砸了

系統：FAILURE_REVIEW → 複盤引導
→ 事件還原 → 歸因分析 → 核心教訓 → 方法修正
```

### 情境 5：檢視成長情況

```
/cognitive-db growth     — 檢視成長軌跡
/cognitive-db dashboard  — 檢視儀表板
/cognitive-check         — 主動檢查待跟進
```

---

## 記憶系統

### 短期記憶
近期對話摘要儲存在 `memory/short-term/`。每個條目包含結構化標籤和雙鏈。

### 長期記憶
跨工作階段反覆出現的模式，從短期記憶晉升。儲存在 `memory/long-term/`。

### 使用者畫像
你持續演進的畫像在 `memory/user-profile.md`，包括：
- 基本資訊和性格傾向
- 核心價值觀和信念（從 TEBAR 分析提取）
- 個人規律（從 cognitive-models/ 雙鏈引用）
- 反模式（從高頻原因提煉）
- 決策偏好

### 成長日誌
完整成長軌跡在 `memory/growth-log.md`：
- 階段評估（每 7+ 天觸發）
- 里程碑（克服恐懼、發現模式、完成實驗）
- 規律與策略演化

---

## 資料安全

所有資料儲存在你的本地檔案系統中，不上傳任何外部伺服器。Claude Code 的對話透過 Anthropic API 處理，但你的認知資料（記憶、原因庫、方法庫等）始終在你自己的硬碟上。

**建議**：定期用 Obsidian 或 Git 備份你的 Vault 目錄。

---

## 打包分享

如果你想把這個系統分享給他人：

1. **確保專案目錄包含所有檔案**

儲存庫已包含所有所需檔案：
- `.claude/commands/` — 8 個 skill 檔案
- `agents/` — 7 個 agent 檔案（已包含在儲存庫中）
- `cognitive-db/` — 模板檔案
- `memory/` — 初始化模板
- `actions/` — 初始化模板
- `setup.ps1` — 安裝腳本

2. **分發**

複製或下載儲存庫，然後執行 `setup.ps1`。

3. **接收者需要**

- 安裝 Claude Code CLI
- 有 Anthropic API 存取權限
- （推薦）安裝 Obsidian

---

## 常見問題

### Q：我的認知資料會不會消失？
A：所有資料都是本地 Markdown 檔案，只要檔案在就不會消失。建議定期備份 Vault 目錄，或用 Git 管理。

### Q：我必須用 Obsidian 嗎？
A：不必須。Obsidian 只是用來視覺化瀏覽雙鏈和標籤，系統本身完全在 Claude Code 中執行。但 Obsidian 能讓你更直觀地看到認知資產之間的關聯。

### Q：為什麼記錄者階段有些命令不能用？
A：系統會根據你的認知階段自動調整能力。記錄者階段專注記錄，等資料累積夠了自動升級。這不是限制你，是保護你免於認知過載。

### Q：個人規律和個人策略有什麼區別？
A：**個人規律** = 「我發現我總是...」（描述性的，幫你認識自己）；**個人策略** = 「下次遇到 X，我按這個步驟來」（指導性的，幫你行動）。規律是認識，策略是應用。

### Q：每天都會推送嗎？
A：系統會嘗試每天早上 9:03 推送檢查結果，但需要 Claude Code 工作階段處於活躍狀態。如果沒開 Claude Code，下次啟動時會自動檢查待跟進事項。

### Q：可以刪除或修改已有的認知條目嗎？
A：可以，所有條目都是 Markdown 檔案，你可以直接編輯或刪除。但建議透過 `/cognitive-db` 檢視後再決定，避免誤刪。
