# D:\Tool\debugger AI 操作指南

本文件给 Codex、Claude、Gemini、Cursor 等 AI agent 使用。进入 `D:\Tool\debugger` 处理工具、MCP、更新、清理或报告前，先读本文件和 `TOOLS_INDEX.md`。

> **说明(GitHub 读者)**:本文档描述 **bootstrap 部署后** 的工作站。`OriginalBase\`、`Launchers\`、`Reports\`、`MCP\tests\` 等目录由你在本机生成,骨架仓库中不含。

## 目录定位

`D:\Tool\debugger` 是 本工作站的便携式逆向、安全分析、调试、解包、移动端分析、网络抓包、系统巡检和 MCP 自动化工具箱。

当前目录是已经整理过的真实物理分类目录，不是临时下载区。不要随意改分类结构、移动工具目录或删除源包。

核心入口：

| 路径 | 作用 |
| --- | --- |
| `TOOLS_INDEX.md` | 当前工具、版本、入口、MCP 状态和报告索引。先读它。 |
| `Static-Reversing\` | 静态逆向、反编译、二进制结构分析。 |
| `Debuggers\` | 调试器、注入、反反调试、内存工具。 |
| `Mobile-Android\` | APK、DEX、Frida、MobSF、objection。 |
| `Network-HTTP\` | Reqable、Wireshark/tshark、网络/HTTP 调试。 |
| `Unpackers-Game\` | 7-Zip、UniExtract、Unity/游戏资源、语言专项恢复。 |
| `System-Forensics\` | Sysinternals、System Informer、系统巡检和取证。 |
| `MCP\` | MCP server、桥接脚本、运行时、工作区。 |
| `OriginalBase\` | 干净原始包仓库。这里有更严格的子目录规则，必须读 `OriginalBase\AGENTS.md`。 |
| `Launchers\` | 用户可点开的分类启动器。 |
| `Reports\` | 更新、整理、验证、MCP 冒烟测试报告。 |

## 工作原则

1. 先查本地事实：读 `TOOLS_INDEX.md`、相关目录、报告和配置，再行动。
2. 需要最新版本时必须联网核验官方来源、GitHub release 或软件官网。
3. 优先便携版。只有驱动、服务、系统集成、Npcap、shell 集成等必须场景才考虑安装版。
4. 更新工具时保留“原始包”和“可运行目录”两层：原始包放 `OriginalBase`，运行目录放外层分类目录。
5. 每次更新或整理后要 smoke test，并清理测试残留。
6. 重要改动要写入 `TOOLS_INDEX.md` 和 `Reports\`。
7. 默认中文记录，路径写绝对路径或从 `D:\Tool\debugger` 开始的相对路径。

## 更新流程

按这个顺序做，不要跳步：

1. 确认用户要更新哪些工具；Cheat Engine 除非用户明确要求，否则不要更新。
2. 联网核验最新版本、下载页、release asset、校验信息和便携版可用性。
3. 下载干净原始包到 `OriginalBase\<分类>\`，文件名应包含工具名和版本。
4. 解压或部署到外层分类目录，例如 `Static-Reversing\Ghidra\`、`Mobile-Android\Apktool\`。
5. 处理启动器、MCP 脚本或路径引用，但不要随意新增系统 PATH。
6. 冒烟测试：GUI 能打开关闭、CLI 能输出版本/help、MCP 能握手、关键工具能做只读调用。
7. 关闭测试启动的进程。
8. 清理运行缓存、临时工作区、`.codex_extracted`、临时解包目录。
9. 更新 `TOOLS_INDEX.md`，并在 `Reports\` 写报告或补充现有报告。

## OriginalBase 规则

`OriginalBase` 是离线重装和版本追溯用的干净原始包仓库，不是运行目录，也不是临时解压目录。

必须遵守：

- 进入 `OriginalBase` 前先读 `OriginalBase\AGENTS.md`。
- 只放官方 release 包、安装包、源码包、便携压缩包、必要安装脚本。
- 不要放运行后的缓存、测试输出、修改后的工具目录、解压中间产物、样本、报告、截图或手工笔记。
- 不要在 `OriginalBase` 里运行工具、生成工作区或做 smoke test。
- 不要删除旧包，除非确认新版已下载、已部署、已测试，并且该旧包不是用户明确要求保留的 Legacy 包。

本目录中的 `OriginalBase\AGENTS.md` 和 `OriginalBase\CLAUDE.md` 是规则文件例外，允许存在。

## MCP 规则

Codex 默认只启用 `debugger-router`。16 个后端 MCP 默认 disabled，由 router 按需临时启动。

常用检查：

```powershell
& 'C:\Users\<user>\AppData\Roaming\npm\codex.cmd' mcp list
```

全量 smoke test：

```powershell
& 'D:\Tool\debugger\MCP\frida-mcp\.venv\Scripts\python.exe' 'D:\Tool\debugger\MCP\tests\mcp_smoke_test.py' --timeout 60
```

直接 profile：

| Profile | 用途 |
| --- | --- |
| `mcp-mobile` | JADX、Apktool、Frida、MobSF、Reqable。 |
| `mcp-re` | Ghidra、x64dbg、ImHex、ILSpy、dnSpy、ReClass、7-Zip、YaraFlux。 |
| `mcp-net` | Wireshark、Reqable。 |
| `mcp-ce` | Cheat Engine、x64dbg、ReClass。 |
| `mcp-all` | 全部后端 MCP。 |

注意：

- ImHex 真实操作需要 ImHex 暴露 `localhost:31337`。
- ReClass.NET 真实内存分析需要 GUI 和 MCP 插件。
- Cheat Engine 真实连接需要 CE 本体和 Lua bridge。
- Wireshark 离线 pcap 可便携使用；实时抓包仍取决于 Npcap/权限。

## 清理规则

通常可以清理，但要确认路径：

- `MCP\workspaces\` 的临时工作区。
- MCP root 下已搬到 `Reports\MCP-History` 的临时 `MCP_SMOKE_*`。
- `.codex_extracted`、临时解包目录、一次性 smoke-test 输出。
- 非依赖目录中的 `__pycache__`、`.pytest_cache`、`.ruff_cache`。

不要随便清理：

- `.venv\Lib\site-packages`。
- MCP server 运行需要的 build output。
- `OriginalBase` 中的干净原始包。
- 用户样本、抓包、dump、报告、Cheat Engine 表、笔记。

清理后检查残留进程：

```powershell
Get-Process | Where-Object { $_.ProcessName -match 'python|dotnet|ReClass|Cheat|tshark|dumpcap|Wireshark|Reqable|7z|java|jadx|apktool|ghidra|imhex|x64dbg|x32dbg' } | Select-Object Id,ProcessName,Path
```

只关闭明确由当前任务启动的进程，不要杀用户正在使用的工具。

## 分发和交接规则

需要把工具箱给别人、发 ZIP、做 staging 或交给下一位 AI 时，默认不要直接压缩 live 目录。先在 `D:\Tool\debugger-staging\` 下生成干净 staging，再从 staging 压 ZIP。

分发 staging 必须排除：

- `.git`、`.codegraph` 和本机开发历史。
- `.env`、API key、token、私有证书、个人凭据。
- `MCP\workspaces`、`MCP\YaraFlux\data`、`.codex_extracted`、临时解包目录和一次性缓存。
- 用户样本、dump、pcap、APK、Cheat Engine 表。
- `OriginalBase\OriginalBase.zip` 这类重复快照，除非已明确记录为要保留的分发物。

分发 staging 应保留：

- 可运行工具目录。
- `OriginalBase` 中的官方原始包。
- MCP server、`.venv`、`node_modules`、`MCP\Runtime` 和 `MCP\bin`，以保证 AI/MCP 尽量开箱可用。
- `TOOLS_INDEX.md`、`AGENTS.md`、`DISTRIBUTION_NOTES.md`、`AI_USAGE_GUIDE.md`、`Reports\INDEX.md`。

分发后至少检查 staging 中没有 `.env`、`.git`、pcap、dump、APK、CT 表和临时工作区，并用 7-Zip 测试 ZIP 完整性。

## 高风险边界

这些动作必须先向用户说明后果和回滚方式，得到明确继续后再做：

- 修改 Windows 服务、驱动、注册表、启动项、计划任务、防火墙、Defender、安全策略。
- 安装 Npcap、内核驱动、常驻服务或注入类常驻组件。
- 批量删除或移动工具源包、用户样本、系统目录或不确定路径。
- 修改虚拟内存、引导、恢复环境、权限继承。
- 在宿主机运行未知样本或恶意样本。

默认不要在宿主机直接运行未知样本。恶意样本、可疑游戏包、未知安装器应放 VM/沙箱。

## 报告要求

完成任务时说明：

- 检查或修改了什么。
- 当前结果是什么。
- 哪些工具已验证可运行。
- 哪些 MCP 只是协议层通过，真实使用还需要 GUI、bridge、token、设备或服务。
- 清理了哪些缓存和进程。
- 哪些没有做，原因是什么。

报告优先写入 `Reports\`，MCP 冒烟测试报告放 `Reports\MCP-History\`。
