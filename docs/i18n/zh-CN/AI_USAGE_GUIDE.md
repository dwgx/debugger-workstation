# AI 使用指南

<!-- I18N:START -->
[English](../../AI_USAGE_GUIDE.md) · **简体中文** · [日本語](../ja/AI_USAGE_GUIDE.md) · [한국어](../ko/AI_USAGE_GUIDE.md)
<!-- I18N:END -->

clone 之后，agent **先读** [AGENTS.zh-CN.md](../../../AGENTS.zh-CN.md)（握手 + MCP 策略）。

本文件是 bootstrap 之后的阅读顺序。`Reports\`、`OriginalBase\`、后端 `tests\` 等目录在安装机上创建，不在骨架 git 里。

## 按此顺序读

1. `AGENTS.zh-CN.md` — 握手、懒 MCP、高风险操作。
2. `templates/i18n/zh-CN/INIT_QUESTIONNAIRE.md` — 用户要求安装时。
3. `docs/WORKSTATION_RULES.md` — 更新 / 清理 / 分发（中文操作规则；相对安装根）。
4. `docs/TOOLS_INDEX.md` — 二进制到位后的逐工具命令。
5. `docs/EXPERT_PLAYBOOK.md` — 样本分流手册（中文）。
6. `docs/SMARTCLI.md` — SmartCLI 里的 CLI；GUI 走路由。
7. `docs/AGENT_EVOLUTION.md` — 事后笔记。

MCP 模板：`mcp/.mcp.json.template`。生成本机 JSON 被 gitignore。

## 默认 MCP

只有 `debugger-router`。目录 JSON 给路由用。绝不把 `mcp-all` 写进用户全局客户端配置。

## 命令

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
```

可以拉取 Npcap 安装包；不要静默装驱动。Cheat Engine 是 cheatengine.org 上的 clickwrap。

## AI 可以自行做的

- 读文档、清单、笔记。
- dry-run bootstrap。
- 任务后双轴审查（`skills/debugger-review`）。

## 需要确认的

- `-Apply`、`-CloneMcp`、`download-tools.ps1 -Apply`。
- 驱动、Defender 排除、在宿主机上跑样本。

## 残留风险

capa zip 可能被当成 PUA 拦截。IDA Pro 由用户自备。不要提交 `.env` 或样本。
