# AGENTS.md — debugger-workstation

所有 AI agent（Claude Code、Codex、Cursor、Gemini CLI、Copilot、Grok）的权威入口。初始化或驱动本工作站前先读本文。

本仓库是**骨架**，不分发任何第三方工具二进制。

<!-- I18N:START -->
[English](AGENTS.md) · **简体中文** · [日本語](AGENTS.ja.md) · [한국어](AGENTS.ko.md)
<!-- I18N:END -->

语言与文档布局见 [docs/I18N.md](docs/I18N.md)。请用**用户正在使用的语言**对话；git 提交说明保持英文。

---

## 0. 这是什么

便携式逆向 / 安全分析 / 调试 / 解包 / 移动端 / 抓包 / 取证 / MCP 工作站。

- 工具从官方源获取：`manifests/` + `scripts/bootstrap.ps1` / `scripts/download-tools.ps1`。
- 本仓库自带：MCP 路由（`mcp/debugger-router`）、包装脚本（`mcp/bin`）、模板、清单、文档。
- 见 `README.zh-CN.md` 与 `DISCLAIMER.zh-CN.md`。

---

## 1. 初始化握手（先问后做）

当用户要求初始化 / 安装 / 搭建本站时：

### 第 1 步 — 探索（只读）

读 `README.zh-CN.md`（或 `README.md`）、本文、`manifests/tools.json`、`manifests/mcp-backends.json`、`docs/i18n/zh-CN/AI_USAGE_GUIDE.md`（若无则英文版）。检测 OS、`git`、`python`（≥3.10）、`pwsh`/`powershell`、`dotnet`、`node`、`java`。解析 UI 语言：对话用语 → `local.json` `ui_language` → 系统 UI → `en`。

### 第 2 步 — 提问（必须）

使用 `templates/i18n/zh-CN/INIT_QUESTIONNAIRE.md`。至少覆盖：

0. **界面语言**（en / zh-CN / ja / ko）；对话已是中文则可跳过，仍写入 `local.json` 的 `ui_language`。
1. **安装根目录**（默认 `D:\Tool\debugger`）。
2. **范围**：全部类别或子集。
3. **MCP 后端**：仅路由，或 `-CloneMcp`（`.env` 类服务未经询问不要配）。
4. **二进制**：用户自下，或授权 `download-tools.ps1 -Apply`。
5. **版本**：清单钉选 vs 官方最新。
6. **AI 客户端**：Claude Code / Codex / Cursor / Gemini / Copilot / Grok。
7. **系统级**：Npcap / 驱动（默认否）。

### 第 3 步 — 计划

列出目录、clone、下载、将生成的配置。等确认。

### 第 4 步 — 执行（确认后）

1. `pwsh scripts/bootstrap.ps1 -InstallRoot "<根>"`（dry-run）。
2. `-Apply`（路由 + 本机 MCP JSON）。
3. 可选 `-CloneMcp`。
4. 授权后再 `powershell -File scripts/download-tools.ps1 -Apply`。
5. **不要**在首次 bootstrap 给 19 个后端全部建环境。路由按需拉起。
6. 冒烟：`capa.exe --version`、`7z.exe`、`jadx.bat --version`（有则测）。Defender 拦 capa 就写 `notes/`，不要假装已装。
7. 以 `skills/debugger-review` 收尾。

Windows 上若 `InstallRoot` 就是本 clone，`mcp\` 与 `MCP\` 是同一目录。`bootstrap.ps1` 必须跳过自拷贝。

### 第 5 步 — 报告

装了什么、跳过了什么、剩余风险。用中文写给中文用户。

---

## 2. MCP 策略

- 客户端默认 **只启用** `debugger-router`。按需启动 19 个后端之一，用完退出。
- 不要默认加载全部后端。直连 profile：`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-intel` / `mcp-all`。
- 模板：`mcp/.mcp.json.template`、`mcp/codex-mcp-config.example.toml`（`{{DEBUGGER_ROOT}}`）。
- **禁止**把 19 个后端写进 Claude / Codex / Cursor / Grok **用户全局** MCP。
- 上游清单：`manifests/mcp-backends.json`。
- 主机已有 IDA MCP（idalib）时，不要再加第二个 IDA 服务。

---

## 3. 命令

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
python -c "import json,glob;[json.load(open(f,encoding='utf-8')) for f in glob.glob('manifests/*.json')]"
```

部署后冒烟（路径相对安装根）：

```
Static-Reversing\capa\capa.exe --version
Static-Reversing\YARA-X\yr.exe --version
Unpackers-Game\7-Zip-full\7z.exe
Mobile-Android\jadx\bin\jadx.bat --version
```

可选私有 zip 缓存（公开 clone 不需要）：`scripts/restore-from-cache.ps1`。

---

## 4. 高风险操作

先简述后果与回滚，再按意图执行。不要拒绝，也不要静默装驱动。

- 驱动、服务、Npcap、Defender 例外、注册表、启动项、计划任务。
- 在宿主机跑可疑样本（建议 VM；由用户决定）。
- 下载第三方二进制、clone 大量仓库、写到安装根之外。

仓库约定：

- git 中无第三方二进制。只记官方源（`DISCLAIMER.zh-CN.md`）。
- `.env`、API key、pcap、dump、APK、Cheat Engine 表不入库。
- 仅限授权的安全测试、CTF、研究、教育。

---

## 5. 布局

见英文 [AGENTS.md](AGENTS.md) 第 5 节。语言文件：`README.<locale>.md`、`AGENTS.<locale>.md`、`docs/i18n/<locale>/`。

---

## 6. 每次实质任务之后

读 `docs/AGENT_EVOLUTION.md` 与 `skills/debugger-review/SKILL.md`。笔记进 `notes/`。本机评分可进 `Reports/`（gitignore）。对话与 jsonl 不是记忆。

---

## 7. 语言

- **对话**：与用户相同的语言（本文件对应简体中文）。
- **对话**：与用户相同（本文为简体中文）。把 `ui_language` 写入 gitignore 的 `local.json`。
- **公开 git**：英文为正文；本文件是中文合同译文。
- **路径**：绝对路径，或相对安装根。
