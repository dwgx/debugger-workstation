# GitHub Copilot 仓库自定义指令

本仓库的权威 AI 指令在根目录 `AGENTS.md`,Copilot 也原生支持 AGENTS.md;本文件为兼容入口,内容与之一致。

## 核心
- 这是一个便携式逆向/安全分析工具站的**骨架仓库**,不含第三方工具二进制(靠 `manifests/` + `scripts/bootstrap.ps1` 从官方源还原)。
- 用户要求初始化/搭建时,**先问澄清问题再动手**(安装根目录、范围、是否 clone 全部 MCP、是否下载二进制、AI 客户端类型、是否需系统级组件),确认后再执行。完整问卷见 `templates/INIT_QUESTIONNAIRE.md`。

## 边界
- 不分发第三方工具二进制(版权归各官方,见 `DISCLAIMER.md`)。
- 不无声装驱动/服务/Npcap/Defender 例外/注册表/启动项,需要时先说明后果并取得同意。
- 不提交 `.env`/凭据/样本/pcap/dump/APK。
- 不在宿主机跑未知样本。仅用于授权的安全测试、CTF、研究、教育。

## MCP
- 默认只启用 `debugger-router`,按需临时启动后端。配置模板在 `mcp/`,上游清单在 `manifests/mcp-backends.json`。

详见 `AGENTS.md`。默认中文。
