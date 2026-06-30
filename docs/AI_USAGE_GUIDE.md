# AI 使用指南

本文件给 Codex、Claude、Gemini、Cursor 或其他本地 AI agent 使用，目标是让 AI 在安全边界内最大程度使用这个工具箱。

> **说明(GitHub 读者)**:本文档描述 **bootstrap 部署后** 的工作站。`Reports\`、`OriginalBase\`、`MCP\tests\` 等路径由你在本机生成,骨架仓库中不含。

## 先读什么

AI 进入本目录后先读：

1. `AGENTS.md`（权威入口，初始化握手）
2. `TOOLS_INDEX.md`
3. `WORKSTATION_RULES.md`
4. `DISTRIBUTION_NOTES.md`

如果任务涉及 MCP：

1. `MCP\.mcp.json`
2. `MCP\codex-mcp-config.example.toml`
3. `Reports\MCP-History\MCP_SMOKE_20260614_123412.md`

如果任务涉及 `OriginalBase`：

1. `OriginalBase\AGENTS.md`

## 默认 MCP 策略

默认只启用：

```text
debugger-router
```

router 会按需启动后端 MCP，用完退出。这样上下文更轻、启动更快，也避免一次性加载所有后端。

router 启动脚本：

```text
MCP\bin\debugger-router-mcp.cmd
```

后端 MCP：

| 后端 | 用途 |
| --- | --- |
| `ghidra` | Ghidra 项目、反编译、静态逆向。 |
| `ida` | IDA Pro 插件桥接(端口 13337)。需用户自备 IDA Pro 8.3+ 并装插件。 |
| `radare2` | radare2/r2mcp 二进制分析。需装 radare2 + `r2pm -Uci r2mcp`。 |
| `x64dbg` | x64dbg 自动化和调试会话。 |
| `jadx` | JADX GUI/plugin 辅助 APK/DEX 查看。 |
| `apktool` | APK 解包、资源、smali、manifest、回编。 |
| `frida` | Frida 设备/进程/脚本自动化。 |
| `imhex` | ImHex 二进制/结构/Pattern 辅助。 |
| `yaraflux` | YARA 规则、样本、扫描结果管理。 |
| `mobsf` | MobSF API 扫描桥接。 |
| `ilspy` | .NET 程序集查看和反编译。 |
| `dnspy` | .NET 类型、IL、字符串和补丁辅助。 |
| `wireshark` | tshark/pcap 离线分析。 |
| `reqable` | HAR、HTTP、WebSocket 数据分析。 |
| `reclass` | ReClass.NET 内存结构桥接。 |
| `sevenzip` | 压缩包列举、测试、提取、更新。 |
| `cheatengine` | Cheat Engine Lua bridge。真实连接需要 CE 本体。 |
| `volatility3` | Volatility3 内存镜像取证;离线分析 dump/raw。 |
| `virustotal` | VirusTotal 威胁情报(URL/文件/IP/域名)。需 `VIRUSTOTAL_API_KEY`,会向公网 API 发送 IOC。 |

## Codex 配置

配置示例在：

```text
MCP\codex-mcp-config.example.toml
```

将里面的 `{{DEBUGGER_ROOT}}` 替换成实际解压路径，例如：

```text
D:\Tool\debugger
```

推荐配置方式：

- 默认会话：只启用 `debugger-router`。
- 移动端任务：启用 `mcp-mobile` profile。
- 逆向任务：启用 `mcp-re` profile。
- 网络任务：启用 `mcp-net` profile。
- 内存/CE 任务：启用 `mcp-ce` profile。
- 全量验证：启用 `mcp-all` profile。

## 常用命令

列出 Codex MCP：

```powershell
& 'C:\Users\<USER>\AppData\Roaming\npm\codex.cmd' mcp list
```

全量 MCP smoke test：

```powershell
& '.\MCP\frida-mcp\.venv\Scripts\python.exe' '.\MCP\tests\mcp_smoke_test.py' --timeout 60
```

核心 CLI smoke：

```powershell
.\Static-Reversing\capa\capa.exe --version
.\Static-Reversing\FLOSS\floss.exe --version
.\Static-Reversing\YARA-X\yr.exe --version
.\Unpackers-Game\7-Zip-full\7z.exe
.\Network-HTTP\Wireshark\tshark.exe -v
.\Mobile-Android\jadx\bin\jadx.bat --version
java -jar .\Mobile-Android\Apktool\apktool.jar --version
```

## AI 可以主动做什么

可以主动执行：

- 读取 `TOOLS_INDEX.md`、`AGENTS.md`、`Reports\` 和相关目录。
- 使用 router 调 MCP 后端做只读分析。
- 用 7-Zip/tshark/capa/FLOSS/YARA-X/JADX/Apktool 进行只读检测。
- 建 staging 分发目录。
- 写报告、handoff、next-agent prompt。
- 更新索引和文档。
- 在明确更新任务中，下载官方 release、部署、smoke test、更新报告。

需要谨慎或先确认：

- 删除/移动原始包、用户样本、dump、pcap、Cheat Engine 表。
- 修改 Windows 服务、驱动、注册表、启动项、Defender、防火墙、Npcap。
- 在宿主机运行未知样本或恶意样本。
- 关闭不确定来源的进程。
- 提交或分发包含 `.env`、API key、token、证书、私有路径的内容。

## 给下一位 AI 的建议提示词

```text
你正在接手一个便携式逆向/安全分析工具箱。先读 TOOLS_INDEX.md、AGENTS.md、DISTRIBUTION_NOTES.md、AI_USAGE_GUIDE.md 和 Reports\INDEX.md。

目标：在不破坏现有工具和用户数据的前提下，使用本地 CLI、MCP router、报告和启动器完成任务。默认优先只读审计；需要更新工具时，先核验官方 release，把原始包放 OriginalBase，把运行目录放外层分类目录，smoke test，清理临时残留，更新 TOOLS_INDEX.md 和 Reports。

MCP 默认只启用 debugger-router；需要直连后端时再使用对应 profile。不要默认加载全部后端。不要提交或分发 .env、API key、token、证书、样本、dump、pcap 或临时工作区。不要无声修改驱动、服务、注册表、Defender、Npcap、启动项或防火墙。
```

## 已知限制

- Codex 当前会话不能热插入新的 MCP 工具列表；要改变 MCP 工具集合，使用新的会话/profile。
- ImHex 真实操作需要 ImHex 暴露 `localhost:31337`。
- ReClass.NET 真实内存分析需要 GUI 和 MCP 插件。
- Cheat Engine 真实连接需要 CE 本体和 Lua bridge。
- Wireshark 实时抓包需要 Npcap/权限；离线 pcap 分析可便携使用。
- MobSF 真实扫描需要服务 URL/API key。
