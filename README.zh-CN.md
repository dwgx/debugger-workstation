# debugger-workstation

[English](README.md) · **简体中文** · [日本語](README.ja.md) · [Русский](README.ru.md)

便携式逆向 / 安全分析 / 调试 / 解包 / 移动端分析 / 网络抓包 / 系统巡检 / MCP 自动化工作站的 **骨架仓库**。

任何 AI agent(Claude / Codex / Gemini / Cursor / Copilot)或人类 clone 后,按文档与 manifest 即可在自己机器上还原一个**可被 AI 最高效调用**的工具站。

> ⚠️ **本仓库不分发任何第三方工具二进制。** 工具靠 `manifests/` + `scripts/bootstrap.ps1` 从各官方源拉取。详见 [DISCLAIMER.md](DISCLAIMER.md)。

---

## 这个仓库里有什么

| 路径 | 内容 |
| --- | --- |
| `AGENTS.md` | 面向所有 AI agent 的**权威入口**:初始化握手(先问后做)、MCP 策略、边界。 |
| `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` / `.cursor/rules/` | 各客户端入口,均指向 `AGENTS.md`。 |
| `templates/INIT_QUESTIONNAIRE.md` | 驱动动态初始化的澄清问题清单。 |
| `docs/` | 给人和 AI 的入口文档(脱敏自原工作站规则)。 |
| `docs/extensions/INDEX.md` | curated 的 MCP server / AI skill 扩展资源索引。 |
| `manifests/tools.json` | 工具清单:名称、版本、官方下载源、放置路径。 |
| `manifests/mcp-backends.json` | 第三方 MCP backend 上游清单 + 自研核心。 |
| `mcp/debugger-router/server.py` | **自研**轻量 MCP 路由(按需启动后端,默认唯一启用)。 |
| `mcp/bin/*.cmd` | **自研**后端 MCP 包装脚本(相对路径,可移植)。 |
| `mcp/.mcp.json.template` | MCP 配置模板,bootstrap 替换 `{{DEBUGGER_ROOT}}`。 |
| `scripts/bootstrap.ps1` | 按 manifest 还原工作站(默认 dry-run)。 |

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

任何 AI clone 本仓库后,**先读根目录 [AGENTS.md](AGENTS.md)**(权威入口,含初始化握手协议)。各客户端入口:Claude→`CLAUDE.md`、Gemini→`GEMINI.md`、Cursor→`.cursor/rules/`、Copilot→`.github/copilot-instructions.md`,均指向 AGENTS.md。

核心理念:当被要求搭建工作站时,AI **不会直接动手**。它先只读探索 → 提澄清问题(安装根目录、范围、哪些 MCP、是否下载二进制、AI 客户端、系统级组件)→ 给出计划 → 经你确认后才执行 `bootstrap.ps1`。

延伸阅读:
1. [AGENTS.md](AGENTS.md) — **权威入口**:初始化握手(先问后做)、MCP 策略、边界。
2. [templates/INIT_QUESTIONNAIRE.md](templates/INIT_QUESTIONNAIRE.md) — 初始化提问清单。
3. [docs/AI_USAGE_GUIDE.md](docs/AI_USAGE_GUIDE.md) — 阅读顺序、可主动执行项。
4. [docs/WORKSTATION_RULES.md](docs/WORKSTATION_RULES.md) — 原工作站总规则、更新/清理流程。
5. [manifests/](manifests/) — 工具与 MCP 清单。
6. [docs/extensions/INDEX.md](docs/extensions/INDEX.md) — 可引入的扩展资源。

## MCP 策略

默认只启用 `debugger-router` 一个轻量 MCP,它按需临时启动 16 个后端中需要的那个,用完退出。不要默认一次性加载全部后端。需要直连时用 profile(`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-all`)。

## 安全边界

工具集含调试器、注入器、Hook、Frida、抓包、内存分析工具,可能触发杀软/EDR。本工作站**不**自动安装驱动 / 服务 / Npcap / Defender 例外 / 注册表项 / 启动项。高风险样本应放 VM/沙箱,不在宿主机直接运行未知样本。仅面向**授权的**安全测试、CTF、研究和教育用途。

## 许可

- 本仓库自研部分(`mcp/debugger-router`、`mcp/bin`、`scripts`、文档)的许可见 [LICENSE](LICENSE)(MIT)。
- 第三方工具与第三方 MCP 的版权和许可归各上游所有,本仓库不再分发其代码或二进制。详见 [DISCLAIMER.md](DISCLAIMER.md)。

## 贡献与安全

- 欢迎贡献,见 [CONTRIBUTING.md](CONTRIBUTING.md)。
- 报告安全问题见 [SECURITY.md](SECURITY.md)。
- 请遵守[行为准则](CODE_OF_CONDUCT.md)。
