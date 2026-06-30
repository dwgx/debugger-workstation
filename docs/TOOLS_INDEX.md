# D:\Tool\debugger 工具索引

生成日期：2026-06-14  
最近更新：2026-06-22

> **说明(GitHub 读者)**:本文档描述的是 **bootstrap 部署后** 的完整工作站布局。其中 `OriginalBase\`、`Launchers\`、`Reports\`、`MCP\tests\` 等目录是你在本机执行 `bootstrap.ps1` 并下载工具后生成的,**骨架仓库中刻意不含**这些目录及其内容。

这个目录是一个便携式逆向、调试、解包、移动端分析、MCP 自动化和系统巡检工具箱。当前已经从旧的扁平目录整理成真实物理分类目录；没有新增系统 PATH、开机启动项或 Windows 服务。

## AI 操作说明入口

给 Codex、Claude、Gemini、Cursor 等 AI agent 的长期操作规则：

| 文件 | 用途 |
| --- | --- |
| `AGENTS.md` | **权威入口**：初始化握手（先问后做）、MCP 策略、操作边界，各 AI 客户端共用。 |
| `WORKSTATION_RULES.md` | 工作站总规则：目录定位、更新流程、MCP、清理边界、高风险动作和报告要求。 |
| `CLAUDE.md` | Claude 入口，通过 `@AGENTS.md` 导入权威入口。 |
| `AI_USAGE_GUIDE.md` | AI agent 使用指南：阅读顺序、MCP 策略、可主动执行事项、下一位 AI prompt。 |
| `DISTRIBUTION_NOTES.md` | 给人和 AI 的分发说明：解压位置、入口、MCP、排除项、安全边界。 |
| `OriginalBase\AGENTS.md` | `OriginalBase` 严格规则：只放干净原始包，不放运行缓存、测试输出、样本或报告。 |
| `OriginalBase\CLAUDE.md` | Claude 进入 `OriginalBase` 时的简短入口提示。 |

AI 处理本目录前应先读 `AGENTS.md` 和本索引；进入 `OriginalBase` 前必须再读 `OriginalBase\AGENTS.md`。

## 顶层结构

| 路径 | 用途 |
| --- | --- |
| `Static-Reversing\` | 静态逆向、反编译、二进制结构分析、规则扫描。 |
| `Debuggers\` | 调试器、反反调试、注入、内存工具。 |
| `Mobile-Android\` | Android/APK/DEX/Frida 相关移动端分析工具。 |
| `Network-HTTP\` | HTTP/HTTPS 抓包、API 调试工具。 |
| `Unpackers-Game\` | 解包、安装包提取、Unity/游戏资源、语言专项恢复。 |
| `System-Forensics\` | 系统巡检、进程/启动项/网络连接/取证工具。 |
| `MCP\` | 面向 AI/MCP 的工具服务器、包装脚本、运行时和工作区。 |
| `OriginalBase\` | 原始安装包、源码包、压缩包，按分类保存，便于离线重装。 |
| `Launchers\` | 按分类整理的 `.cmd` 启动器。 |
| `Reports\` | 整理、更新、缓存、MCP 冒烟测试报告。 |

## 启动入口

| 分类 | 路径 |
| --- | --- |
| 静态逆向 | `Launchers\01_Static-Reversing\` |
| 调试/动态分析 | `Launchers\02_Debuggers\` |
| Android 移动端 | `Launchers\03_Mobile-Android\` |
| HTTP/网络调试 | `Launchers\04_Network-HTTP\` |
| 解包/游戏/格式恢复 | `Launchers\05_Unpackers-Game\` |
| 系统巡检/取证 | `Launchers\06_System-Forensics\` |
| MCP 配置 | `MCP\.mcp.json` |
| MCP 启动脚本 | `MCP\bin\` |

## 静态逆向工具

| 工具 | 当前入口 | 用途 |
| --- | --- | --- |
| Ghidra 12.1.2 | `Static-Reversing\Ghidra\ghidra_12.1.2_PUBLIC\ghidraRun.bat` | 反汇编、反编译、静态逆向分析。需要 Java。 |
| PE-bear 0.7.2 | `Static-Reversing\PE-bear\PE-bear.exe` | PE 头、节区、导入导出、资源查看与编辑。 |
| ImHex 1.38.1 | `Static-Reversing\ImHex\imhex-gui.exe` | 十六进制编辑、Pattern Language、二进制结构分析。 |
| Detect It Easy 3.21 | `Static-Reversing\die_win64_portable_3.21_x64\die\die.exe` | 文件类型、壳、编译器、签名、熵检测。 |
| capa 9.4.0 | `Static-Reversing\capa\capa.exe` | 样本能力识别、ATT&CK/MBC 线索分析。 |
| FLOSS 3.1.1 | `Static-Reversing\FLOSS\floss.exe` | 静态字符串、栈字符串、解码字符串提取。 |
| YARA-X 1.18.0 | `Static-Reversing\YARA-X\yr.exe` | YARA 规则扫描、编译、验证、格式化。 |
| ILSpy 10.1 | `Static-Reversing\ILSpy\ILSpy.exe` | .NET 反编译。 |
| dnSpyEx 6.6.0 | `Static-Reversing\dnSpyEx\dnSpy.exe` | .NET 反编译、调试、编辑。 |
| ReClass.NET 1.2 | `Static-Reversing\ReClass.NET\x64\ReClass.NET.exe` | 运行时内存结构、类结构重建。 |

## 调试和动态分析

| 工具 | 当前入口 | 用途 |
| --- | --- | --- |
| x64dbg | `Debuggers\x64dbg\release\x64\x64dbg.exe` | x64 用户态调试器。 |
| x32dbg | `Debuggers\x64dbg\release\x32\x32dbg.exe` | x86 用户态调试器。 |
| ScyllaHide | `Debuggers\ScyllaHide\` | x64dbg/IDA 等反反调试插件和注入器。 |
| GH Injector 4.8 | `Debuggers\GH-Injector\GH Injector.exe` | DLL 注入工具。 |
| Cheat Engine | `Debuggers\Cheat Engine\` | 内存扫描、调试、Auto Assembler、Lua 表。按要求未更新。 |

## Android 和移动端分析

| 工具 | 当前入口 | 用途 |
| --- | --- | --- |
| JADX CLI 1.5.5 | `Mobile-Android\jadx\bin\jadx.bat` | APK/DEX 命令行反编译。 |
| JADX GUI 1.5.5 | `Mobile-Android\jadx-gui-1.5.5-with-jre-win\jadx-gui-1.5.5.exe` | APK/DEX 图形界面反编译，带 JRE。 |
| Apktool 3.0.2 | `Mobile-Android\Apktool\apktool.jar` | APK 资源、smali、manifest 解包与回编。 |
| MobSF | `Mobile-Android\MobSF\Mobile-Security-Framework-MobSF` | Android/iOS 静态和动态安全分析框架源码。 |
| objection 1.12.5 | `Mobile-Android\objection\.venv\Scripts\objection.exe` | 基于 Frida 的移动端运行时探索、Hook、SSL pinning 检查。 |

说明：JADX 不是 .NET 工具。它属于 Android 移动端，因为它主要处理 APK、DEX、smali/Java 反编译工作流。

## 网络和 HTTP 调试

| 工具 | 当前入口 | 用途 |
| --- | --- | --- |
| Reqable 3.1.3 | `Network-HTTP\reqable-app-windows-x86_64\Reqable.exe` | HTTP/HTTPS 抓包、API 调试、重放、断点、改写。 |
| Wireshark/tshark 4.7.1 | `Network-HTTP\Wireshark\tshark.exe` | pcap 离线解析、显示过滤、协议统计；已从官方安装包便携解出，未安装 Npcap 驱动。 |

## 解包、游戏和格式恢复

| 工具 | 当前入口 | 用途 |
| --- | --- | --- |
| 7-Zip full 26.01 | `Unpackers-Game\7-Zip-full\7z.exe` | 常规压缩包、安装包、镜像和嵌套包第一轮提取/测试/列表。 |
| 7-Zip extra 26.01 | `Unpackers-Game\7-Zip\7za.exe` | 轻量命令行备用版，支持格式少于 full `7z.exe`。 |
| Universal Extractor RC3 | `Unpackers-Game\UniExtract\UniExtract.exe` | 安装器、特殊压缩包、多媒体/游戏包提取。 |
| AssetRipper 1.3.14 | `Unpackers-Game\AssetRipper\AssetRipper.GUI.Free.exe` | Unity 资源提取、项目恢复。 |
| Il2CppDumper 6.7.46 | `Unpackers-Game\Il2CppDumper-net6-win-v6.7.46\Il2CppDumper.exe` | Unity IL2CPP 元数据、脚本恢复。 |
| Il2CppDumper 备用包 | `Unpackers-Game\Il2CppDumper-win-v6.7.46\Il2CppDumper.exe` | 保留的备用版本。 |
| GoReSym | `Unpackers-Game\GoReSym\GoReSym.exe` | Go 程序符号、函数、类型、文件路径恢复。 |
| pyinstxtractor-ng | `Unpackers-Game\pyinstxtractor-ng\pyinstxtractor-ng.exe` | PyInstaller 打包程序提取。 |

7-Zip 的定位：它不是逆向工具本体，但适合作为第一步解包引擎。很多 APK/JAR/ZIP/MSI/CAB/ISO/WIM/NSIS 或嵌套压缩包，在进入 Ghidra、JADX、DiE、capa 之前都可以先用它列文件、测试完整性、提取内容。

## 系统巡检和取证

| 工具 | 当前入口 | 用途 |
| --- | --- | --- |
| Sysinternals Suite | `System-Forensics\SysinternalsSuite\` | Autoruns、Process Explorer、Procmon、Handle、TCPView、Sigcheck 等。 |
| System Informer | `System-Forensics\systeminformer\SystemInformer.exe` | 进程、服务、驱动、网络连接、句柄、模块观察。 |

常用入口：

| 工具 | 路径 |
| --- | --- |
| Autoruns | `System-Forensics\SysinternalsSuite\Autoruns64.exe` |
| Process Explorer | `System-Forensics\SysinternalsSuite\procexp64.exe` |
| Process Monitor | `System-Forensics\SysinternalsSuite\Procmon64.exe` |
| TCPView | `System-Forensics\SysinternalsSuite\tcpview64.exe` |
| Sigcheck | `System-Forensics\SysinternalsSuite\sigcheck64.exe` |

## MCP / AI 辅助分析

后端清单：`MCP\.mcp.json`  
启动脚本：`MCP\bin\`  
Codex 默认入口：`debugger-router` 一个轻量 MCP。19 个后端 MCP 默认不随 Codex 启动；AI 需要时通过 router 临时启动后端并在调用后退出。

Codex 直连 profile：

| Profile | 用途 |
| --- | --- |
| `mcp-mobile` | 直连 JADX、Apktool、Frida、MobSF、Reqable。 |
| `mcp-re` | 直连 Ghidra、IDA Pro、radare2、x64dbg、ImHex、ILSpy、dnSpy、ReClass、7-Zip、YaraFlux。 |
| `mcp-net` | 直连 Wireshark、Reqable。 |
| `mcp-ce` | 直连 Cheat Engine、x64dbg、ReClass。 |
| `mcp-intel` | 直连 Volatility3、VirusTotal、YaraFlux。 |
| `mcp-all` | 直连全部 19 个后端 MCP。 |

示例：`codex --profile mcp-mobile`

| MCP | 启动器 | 状态 |
| --- | --- | --- |
| Debugger Router | `MCP\bin\debugger-router-mcp.cmd` | 默认启用；提供 `list_backends`、`list_backend_tools`、`call_backend_tool`、`smoke_backend`、`workflow_help`，按需临时启动后端 MCP。 |
| GhidraMCP | `MCP\bin\ghidra-mcp.cmd` | 可启动。Ghidra 项目和插件连接后才能做真实程序分析。 |
| IDA Pro MCP | `MCP\bin\ida-pro-mcp.cmd` | 可启动。需用户自备商业版 IDA Pro 8.3+(IDA Free 不支持),在 IDA 中执行 `ida-pro-mcp --install` 装插件后经端口 13337 对接;真实分析需 IDA 打开并加载插件。 |
| radare2 MCP | `MCP\bin\radare2-mcp.cmd` | 可启动。纯 C 的官方 r2mcp,经 `r2pm -r r2mcp` 启动;需先装 radare2 并 `r2pm -Uci r2mcp`。 |
| x64dbg automate MCP | `MCP\bin\x64dbg-mcp.cmd` | 可启动。需要 x64dbg automate 插件和调试会话配合。 |
| JADX MCP | `MCP\bin\jadx-mcp.cmd` | 可启动。已强制 UTF-8 stdio 并关闭启动 banner，真实分析需要 JADX GUI/plugin listener。 |
| Apktool MCP | `MCP\bin\apktool-mcp.cmd` | 可启动。已强制 UTF-8 stdio 并关闭启动 banner，工作区在 `MCP\workspaces\apktool`。 |
| Frida MCP | `MCP\bin\frida-mcp.cmd` | 可启动，真实使用取决于 Frida 设备/进程。 |
| YaraFlux MCP | `MCP\bin\yaraflux-mcp.cmd` | 可启动，支持规则、样本、扫描结果管理。 |
| YaraFlux HTTP | `MCP\bin\yaraflux-http.cmd` | HTTP 服务模式，默认健康检查端口 `8000`。 |
| MobSF MCP | `MCP\bin\mobsf-mcp.cmd` | 可启动，真实扫描需要 MobSF URL/API key。 |
| ImHex MCP | `MCP\bin\imhex-mcp.cmd` | MCP 协议层可启动；真实 ImHex 操作需要 ImHex 网络接口 `localhost:31337`。 |
| ILSpy MCP | `MCP\bin\ilspy-mcp.cmd` | 可启动，使用 `MCP\Runtime\dotnet`。 |
| dnSpy MCP | `MCP\bin\dnspy-mcp.cmd` | 可启动，独立 stdio MCP。 |
| Wireshark/tshark MCP | `MCP\bin\wireshark-mcp.cmd` | 可启动；脚本已绑定便携 `Network-HTTP\Wireshark\tshark.exe` 和 `dumpcap.exe`。离线 pcap 分析可用；实时抓包仍取决于 Npcap/权限。 |
| Reqable MCP | `MCP\bin\reqable-mcp-local.cmd` | 可启动，Reqable 可向 `127.0.0.1:18765/report` 上报 HAR。 |
| ReClass.NET MCP | `MCP\bin\reclass-mcp.cmd` | 可启动；真实内存分析需要打开 ReClass.NET 并加载 MCP 插件。 |
| 7-Zip MCP | `MCP\bin\7zip-mcp.cmd` | 可启动，已绑定本地 `7z.exe`。 |
| Cheat Engine MCP | `MCP\bin\cheatengine-mcp.cmd` | 可启动；真实连接需要在 Cheat Engine 中加载 Lua bridge。按用户要求不做工具白名单限制，启动脚本启用 `CE_MCP_ALLOW_SHELL=1`。 |
| Volatility3 MCP | `MCP\bin\volatility3-mcp.cmd` | 可启动。内存镜像取证,把 Vol3 插件暴露为 MCP 工具;需 Python 环境和内存 dump/raw 镜像。 |
| VirusTotal MCP | `MCP\bin\virustotal-mcp.cmd` | 可启动(Node)。需环境变量 `VIRUSTOTAL_API_KEY`;会把哈希/URL/IP/域名等 IOC 发往 VirusTotal 公网 API,仅授权调查使用。 |

MCP 相关目录：

| 路径 | 用途 |
| --- | --- |
| `MCP\GhidraMCP\` | Ghidra MCP 源码和 Python 环境。 |
| `MCP\ida-pro-mcp\` | IDA Pro MCP 源码和 Python 环境(连接用户安装的 IDA 插件)。 |
| `MCP\radare2-mcp\` | 官方 radare2 MCP(r2mcp)源码;经 r2pm 编译安装后运行。 |
| `MCP\volatility3-mcp\` | Volatility3 MCP 源码和 Python 环境(内存取证)。 |
| `MCP\mcp-virustotal\` | VirusTotal MCP 源码(Node);需 `VIRUSTOTAL_API_KEY`。 |
| `MCP\x64dbg-automate\` | x64dbg automate 插件源码/包。 |
| `MCP\x64dbg-automate-pyclient\` | Python client 和 MCP server 环境。 |
| `MCP\mcp-wireshark\` | Wireshark/tshark MCP 源码和 Python 环境。 |
| `MCP\reqable-mcp\` | Reqable MCP 源码和 Python 环境。 |
| `MCP\ReClass.NET-MCP\` | ReClass.NET MCP 源码、release 插件和 Python server。 |
| `MCP\mcp7zop\` | 7-Zip MCP 源码和 Python 环境。 |
| `MCP\cheatengine-mcp-bridge\` | Cheat Engine MCP bridge、Lua bridge 和 Python server。 |
| `MCP\Runtime\dotnet\` | 便携 .NET SDK/runtime。 |
| `MCP\workspaces\` | MCP 工作区，运行时按需生成；当前已清空。 |
| `MCP\tests\` | MCP 冒烟测试脚本。 |
| `MCP\codex-mcp-config.example.toml` | Codex MCP 配置示例，复制后把 `{{DEBUGGER_ROOT}}` 替换成实际解压路径。 |

最近 MCP 冒烟测试：

| 报告 | 结果 |
| --- | --- |
| `Reports\MCP-History\MCP_SMOKE_20260614_123412.md` | 全量 15 个 MCP 均 PASS；本次复测覆盖 apktool/jadx 的 Codex stdio 启动修复。 |
| `Reports\MCP-History\MCP_SMOKE_20260614_123412.json` | 同上，机器可读结果。 |

默认 router 验证：`debugger-router` 协议握手 PASS，暴露 5 个 router 工具；`call_backend_tool(backend="apktool", tool_name="health_check")` 可按需启动 Apktool MCP 并返回 Apktool `3.0.2`。

说明：ImHex MCP 现在不再因 `31337` 未启动而拒绝协议握手；只有真实 ImHex 工具调用需要目标接口。

## OriginalBase 原始包

| 分类 | 内容 |
| --- | --- |
| `OriginalBase\Static-Reversing\` | Ghidra、PE-bear、ImHex、DiE、ILSpy、dnSpy、ReClass、capa、FLOSS、YARA-X。 |
| `OriginalBase\Debuggers\` | x64dbg、GH Injector、ScyllaHide 等。 |
| `OriginalBase\Mobile-Android\` | JADX、JADX GUI、Apktool。 |
| `OriginalBase\Network-HTTP\` | Reqable。 |
| `OriginalBase\Unpackers-Game\` | 7-Zip、UniExtract、AssetRipper、Il2CppDumper、pyinstxtractor-ng、GoReSym。 |
| `OriginalBase\System-Forensics\` | Sysinternals Suite、System Informer。 |
| `OriginalBase\MCP-Automation\` | MCP 相关源码包、运行时安装脚本、x64dbg automate 包、ReClassMCP release 包。 |
| `OriginalBase\Installers-Manual\` | Wireshark 官方安装器。已便携解包到 `Network-HTTP\Wireshark\`；Npcap/驱动仍保留为手动安装。 |
| `OriginalBase\Legacy-Existing\` | 按要求保留但没有更新的旧包；当前只保留 Cheat Engine 主包。 |

注意：分发 staging 不应包含聚合快照类的大压缩包，只保留单个官方原始包。

## 便携版和安装版说明

大多数逆向工具、调试器、解包器、反编译器、CLI 扫描器用便携版就够了。  
安装版只有在这些场景更有意义：

- 需要驱动，例如 Wireshark/Npcap。
- 需要系统服务。
- 需要右键菜单、文件关联、shell 集成。
- 需要长期后台组件。
- 需要全局 PATH 或系统级 SDK 注册。

当前这个工具箱优先使用便携版，方便移动、备份和整体删除。

## 安全提醒

- 调试器、注入器、解包器、Frida、objection、反反调试插件容易触发杀软或 EDR 提醒。
- 不要在宿主机直接运行未知样本。
- 后续如果做恶意样本或高风险程序分析，应放到 VM/沙箱。
- 本次整理没有新增常驻服务。
