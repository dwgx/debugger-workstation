# GEMINI.md

Gemini CLI 入口。本仓库权威 AI 指令在根目录 `AGENTS.md`。

> 建议:在 `~/.gemini/settings.json` 设 `context.fileName` 为 `["AGENTS.md", "GEMINI.md"]`,即可直接加载权威入口。

## 摘要
- 便携式逆向/安全分析工具站的**骨架仓库**,不含第三方工具二进制,靠 `manifests/` + `scripts/bootstrap.ps1` 从官方源还原。
- 用户要求初始化/搭建时:**先问澄清问题(安装根目录、范围、MCP 范围、是否下载二进制、客户端类型、是否需系统级组件)再动手**,见 `templates/INIT_QUESTIONNAIRE.md`。
- 边界:不分发第三方二进制;不无声装驱动/服务/Npcap/注册表;不提交凭据/样本;不跑未知样本。
- MCP 默认只启 `debugger-router`。

完整规则见 `AGENTS.md`。默认中文。
