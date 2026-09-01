# debugger-workstation

<!-- I18N:START -->
[English](README.md) · **简体中文** · [日本語](README.ja.md) · [한국어](README.ko.md)
<!-- I18N:END -->

便携式逆向 / 安全分析 / 调试 / 解包 / 移动端分析 / 网络抓包 / 系统巡检 / MCP 自动化工作站的 **骨架仓库**。

任何 AI agent(Claude / Codex / Gemini / Cursor / Copilot / Grok)或人类 clone 后,按 [docs/i18n/zh-CN/I18N.md](docs/i18n/zh-CN/I18N.md) 选定界面语言,走 [AGENTS.zh-CN.md](AGENTS.zh-CN.md) 握手,即可在自己机器上还原一个**可被 AI 最高效调用**的工具站。本树是**参考骨架**：主人保留自己的工具和提示词（`OWNER.example.md` → gitignore 的 `OWNER.md`）。主人要求时 agent 可以**改这个 clone**；聊天不能取消红线（[docs/i18n/zh-CN/MAINTAIN.md](docs/i18n/zh-CN/MAINTAIN.md)）。对话用中文；git 提交说明保持英文。

> ⚠️ **本仓库不分发任何第三方工具二进制。** 工具靠 `manifests/` + `scripts/bootstrap.ps1` 从各官方源拉取。详见 [DISCLAIMER.zh-CN.md](DISCLAIMER.zh-CN.md)。

---

## 这个仓库里有什么

| 路径 | 内容 |
| --- | --- |
| `AGENTS.zh-CN.md` | 中文权威入口:初始化握手(先问后做)、克隆主人覆盖层、MCP 策略、红线。见 [docs/i18n/zh-CN/I18N.md](docs/i18n/zh-CN/I18N.md) 与 [docs/i18n/zh-CN/MAINTAIN.md](docs/i18n/zh-CN/MAINTAIN.md)。 |
| `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` / `.cursor/rules/` | 各客户端入口,均指向 `AGENTS.md`。 |
| `templates/INIT_QUESTIONNAIRE.md` | 驱动动态初始化的澄清问题清单。 |
| `docs/` | 给人/AI 的文档。任务结束后的进化：`docs/AGENT_EVOLUTION.md`。 |
| `skills/debugger-review/` | 双轴审查 + 把教训写回笔记/手册。 |
| `notes/` | 可入库短笔记（无样本、无密钥）。 |
| `docs/extensions/INDEX.md` | curated 的 MCP server / AI skill 扩展资源索引。 |
| `manifests/tools.json` | 工具清单:名称、版本、官方下载源、放置路径。 |
| `manifests/mcp-backends.json` | 第三方 MCP backend 上游清单 + 自研核心。 |
| `mcp/debugger-router/server.py` | **自研**轻量 MCP 路由(按需启动后端,默认唯一启用)。 |
| `mcp/bin/*.cmd` | **自研**后端 MCP 包装脚本(相对路径,可移植)。 |
| `mcp/.mcp.json.template` | MCP 配置模板,bootstrap 替换 `{{DEBUGGER_ROOT}}`。 |
| `scripts/download-tools.ps1` | 授权后从官方源拉便携包(`-Apply`)。Npcap 只下安装包,不静默装驱动。 |
| `templates/i18n/zh-CN/INIT_QUESTIONNAIRE.md` | 中文初始化问卷。 |

**不包含**(由 `.gitignore` 硬排除):工具二进制、`.env`/凭据、`.venv`/`node_modules`/运行时、样本/pcap/dump、临时工作区、本机 git 历史。

## 快速开始

```powershell
# 1. dry-run:只看计划,不写盘不下载
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"

# 2. 确认无误后执行:部署自研 MCP + 生成本机配置 + clone 第三方 MCP
pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot "D:\Tool\debugger"

# 3. 按 dry-run 列出的官方源,下载工具二进制到对应分类目录
#    (本仓库不代下载第三方工具二进制)

# 4. 重建第三方 MCP 的 .venv / dotnet / node 依赖,然后 smoke test
```

> Windows PowerShell 5.1 也可运行(脚本为 UTF-8 BOM)。优先用 PowerShell 7 (`pwsh`)。

## AI 接手请先读

任何 AI clone 本仓库后,**先按界面语言读 [AGENTS.zh-CN.md](AGENTS.zh-CN.md)**(英文正文仍是 [AGENTS.md](AGENTS.md))。各客户端入口:Claude→`CLAUDE.md`、Gemini→`GEMINI.md`、Cursor→`.cursor/rules/`、Copilot→`.github/copilot-instructions.md`。

核心理念:当被要求搭建工作站时,AI **不会直接动手**。它先只读探索 → 提澄清问题(安装根目录、范围、哪些 MCP、是否下载二进制、AI 客户端、系统级组件)→ 给出计划 → 经你确认后才执行 `bootstrap.ps1`。

延伸阅读:
1. [AGENTS.zh-CN.md](AGENTS.zh-CN.md) — **中文权威入口**。
2. [templates/i18n/zh-CN/INIT_QUESTIONNAIRE.md](templates/i18n/zh-CN/INIT_QUESTIONNAIRE.md) — 初始化提问清单。
3. [docs/i18n/zh-CN/I18N.md](docs/i18n/zh-CN/I18N.md) — 语言与初始化。
4. [docs/i18n/zh-CN/AI_USAGE_GUIDE.md](docs/i18n/zh-CN/AI_USAGE_GUIDE.md) — 阅读顺序。
5. [docs/WORKSTATION_RULES.md](docs/WORKSTATION_RULES.md) — 部署后中文操作规则。
6. [manifests/](manifests/) — 工具与 MCP 清单。

## MCP 策略

默认只启用 `debugger-router` 一个轻量 MCP,它按需临时启动 19 个后端中需要的那个,用完退出。不要默认一次性加载全部后端。需要直连时用 profile(`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-intel` / `mcp-all`)。

## 安全姿态

工具集含调试器、注入器、Hook、Frida、抓包、内存分析工具,可能触发杀软/EDR。执行高风险操作(安装驱动/服务/Npcap、修改注册表/Defender/启动项、在宿主机运行可疑样本)前,AI 会简要说明后果与回滚方式,用户确认后按意图执行——不会无声操作,也不会拒绝。仅面向**授权的**安全测试、CTF、研究和教育用途。

## 许可

- 本仓库自研部分(`mcp/debugger-router`、`mcp/bin`、`scripts`、文档)的许可见 [LICENSE](LICENSE)(MIT)。
- 第三方工具与第三方 MCP 的版权和许可归各上游所有,本仓库不再分发其代码或二进制。详见 [DISCLAIMER.zh-CN.md](DISCLAIMER.zh-CN.md)。

## 贡献与安全

- 欢迎贡献,见 [CONTRIBUTING.md](CONTRIBUTING.md)。
- 报告安全问题见 [SECURITY.md](SECURITY.md)。
- 请遵守[行为准则](CODE_OF_CONDUCT.md)。
