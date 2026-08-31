# Tool index (post-bootstrap)

English contract: [`AGENTS.md`](../AGENTS.md). This cheat-sheet is Chinese. After `bootstrap.ps1 -Apply`, paths are relative to **your** install root (questionnaire default `D:\Tool\debugger`).

# D:\Tool\debugger 工具索引(实战版)

生成日期:2026-06-14  
重写:2026-07-04(从清单式改为专家用法参考)

> **说明(GitHub 读者)**:本文档描述的是 **bootstrap 部署后** 的完整工作站布局。`OriginalBase\`、`Launchers\`、`Reports\`、`MCP\tests\` 等目录由你在本机执行 `bootstrap.ps1` 并下载工具后生成,骨架仓库中刻意不含。
>
> **本文档定位**:不是"有什么",而是"怎么用"。每个工具给出 路径 / 核心用途(动词开头,一句话)/ 关键命令(2–3 条最常用命令+示例)。想要场景驱动的分析工作流(组合拳),看 `EXPERT_PLAYBOOK.md`。

所有路径均相对安装根(默认 `D:\Tool\debugger`)。

---

## 顶层结构

| 路径 | 用途 |
| --- | --- |
| `Static-Reversing\` | 静态逆向、反编译、二进制结构分析、规则扫描 |
| `Debuggers\` | 用户态调试器、反反调试、注入、内存工具 |
| `Mobile-Android\` | APK/DEX/smali/Frida 移动端分析 |
| `Network-HTTP\` | HTTP/HTTPS 抓包、pcap 离线解析 |
| `Unpackers-Game\` | 解包、安装器提取、Unity/IL2CPP、Go/PyInstaller 恢复 |
| `System-Forensics\` | 进程/启动项/网络/句柄巡检、内存取证 |
| `MCP\` | debugger-router(自研)+ 19 个后端包装脚本 + 运行时 |

---

## 静态逆向

### Ghidra 12.1.3
- **路径**:`Static-Reversing\Ghidra\ghidra_12.1.3_PUBLIC\ghidraRun.bat`(需 Java)
- **核心用途**:全平台反汇编+反编译,做深度静态分析和交叉引用追踪。
- **关键命令**:
  - GUI:`ghidraRun.bat`,新建项目 → 导入样本 → 双击 → Analyze(默认全开)。
  - Headless 批量:`support\analyzeHeadless.bat <项目目录> <项目名> -import <样本> -postScript <脚本.py>`
  - 反编译窗口 `Ctrl+E` 切 C 伪代码;`G` 跳地址;`Ctrl+Shift+F` 查函数被调用点。

### IDA Pro(用户自备,商业)
- **路径**:`Static-Reversing\IDA`(需用户购买安装 IDA Pro 8.3+;IDA Free 不支持 ida-pro-mcp)
- **核心用途**:行业标准反汇编器,配合 ida-pro-mcp 让 AI 经端口 13337 驱动分析。
- **关键命令**:
  - 装 MCP 插件:IDA 内运行 `ida-pro-mcp --install`,重启后插件监听 13337。
  - 快捷键:`F5` 反编译,`X` 交叉引用,`N` 重命名,`Y` 改类型,`;` 加注释。

### PE-bear 0.7.2
- **路径**:`Static-Reversing\PE-bear\PE-bear.exe`
- **核心用途**:可视化查看/编辑 PE 头、节区、导入导出表、资源。
- **关键命令**:拖入 exe → 看 Sections(注意高熵节=可能加壳)、Imports(判断行为)、Resources(找嵌入 payload)。改字节后 `Ctrl+S` 保存。

### ImHex 1.38.1
- **路径**:`Static-Reversing\ImHex\imhex-gui.exe`
- **核心用途**:十六进制编辑 + Pattern Language 解析任意二进制格式。
- **关键命令**:
  - 加载文件后写 `.hexpat` 模式脚本自动着色结构。
  - Data Inspector 实时看选中字节的多类型解释;Data Processor 做异或/base64 解码链。

### Detect It Easy 3.21
- **路径**:`Static-Reversing\die_win64_portable_3.21_x64\die\die.exe`
- **核心用途**:识别文件类型、壳、编译器、熵——分析第一步的分诊工具。
- **关键命令**:
  - CLI:`diec.exe <文件>`(位于同目录),`diec.exe -e <文件>` 输出熵,高熵段提示加壳/加密。
  - GUI 拖入即出签名;右上 Entropy 按钮看分段熵图。

### capa 9.4.0
- **路径**:`Static-Reversing\capa\capa.exe`
- **核心用途**:识别样本能力并映射到 ATT&CK/MBC,回答"这东西会干什么"。
- **关键命令**:
  - `capa.exe <样本>` 出能力清单;`capa.exe -v <样本>` 看命中规则的具体地址。
  - `capa.exe -j <样本> > caps.json` 输出 JSON 供后续管道;加壳样本先脱壳再跑。

### FLOSS 3.1.1
- **路径**:`Static-Reversing\FLOSS\floss.exe`
- **核心用途**:提取普通字符串 + 栈字符串 + 运行时解码字符串(strings 看不到的)。
- **关键命令**:
  - `floss.exe <样本>` 全类型提取;`floss.exe --only static <样本>` 仅静态加速。
  - `floss.exe -q <样本>` 精简输出;解码字符串常暴露 C2 域名/密钥。

### YARA-X 1.18.0(上游已到 1.19.0,建议更新)
- **路径**:`Static-Reversing\YARA-X\yr.exe`
- **核心用途**:用 YARA 规则扫描/分类样本,新一代 Rust 引擎,比旧 yara 快。
- **关键命令**:
  - 扫描:`yr.exe scan <规则.yar> <目标>`;目录递归加 `-r`。
  - 校验/编译:`yr.exe check <规则.yar>`、`yr.exe compile <规则.yar> -o rules.yarc`。
  - 格式化:`yr.exe fmt <规则.yar>`。

### ILSpy 10.1
- **路径**:`Static-Reversing\ILSpy\ILSpy.exe`
- **核心用途**:反编译 .NET 程序集回 C#,只读浏览+导出源码。
- **关键命令**:拖入 dll/exe → 树状浏览命名空间;右键程序集 `Save Code` 导出整个反编译工程。命令行版 `ilspycmd.exe <dll> -o <输出目录>`。

### dnSpyEx 6.6.0
- **路径**:`Static-Reversing\dnSpyEx\dnSpy.exe`
- **核心用途**:反编译 + **调试** + 编辑 .NET,可下断点动态跟踪并直接改 IL/C#。
- **关键命令**:拖入 → 设断点 `F9` → `F5` 附加/启动调试;右键方法 `Edit Method` 改代码后 `Compile`;`Edit Class`+保存生成打过补丁的程序集。

### ReClass.NET 1.2
- **路径**:`Static-Reversing\ReClass.NET\x64\ReClass.NET.exe`
- **核心用途**:在活进程内存里重建 C++ 类/结构体布局。
- **关键命令**:附加进程 → 输入基址 → 逐字段标注类型(pointer/int/float/vtable),配合指针链定位对象。装 MCP 插件可让 AI 读结构。

### radare2(latest)
- **路径**:`Static-Reversing\radare2\bin\radare2.exe`
- **核心用途**:脚本化命令行逆向框架,也是官方 r2mcp 后端的前置。
- **关键命令**:
  - 打开分析:`r2 -A <样本>`;`aaa` 深度分析;`afl` 列函数;`pdf @ main` 反汇编函数。
  - `s <地址>` 跳转;`iz` 列字符串;`ii` 导入表;`V` 进可视模式,`VV` 图模式。
  - 装 MCP:`r2pm -Uci r2mcp`(不要直接在 shell 跑 r2mcp)。

---

## 调试与动态分析

### x64dbg / x32dbg
- **路径**:`Debuggers\x64dbg\release\x64\x64dbg.exe`(64 位)/ `release\x32\x32dbg.exe`(32 位)
- **核心用途**:用户态汇编级调试,动态脱壳、跟踪算法、内存断点抓 API 调用。
- **关键命令**:
  - `F2` 下断点,`F7` 步入,`F8` 步过,`F9` 运行;`Ctrl+G` 跳表达式。
  - 命令栏:`bp <API名>`(如 `bp VirtualAlloc`);`bpm <地址>` 内存断点抓写入。
  - 脱壳:运行到 OEP → 右键 → Follow in Dump → 用 Scylla 插件 dump + 修复 IAT。

### ScyllaHide(latest)
- **路径**:`Debuggers\ScyllaHide\`
- **核心用途**:反反调试,隐藏调试器绕过 IsDebuggerPresent/PEB/时间差等检测。
- **关键命令**:x64dbg 里 Plugins → ScyllaHide → 选 profile(x64dbg-stealth64),勾全部隐藏项后再启动被调样本。也提供 `InjectorCLIx64.exe` 独立注入。

### GH Injector 4.8
- **路径**:`Debuggers\GH-Injector\GH Injector SM - x64.exe`
- **核心用途**:DLL 注入(手动映射/LoadLibrary 多种方式)到目标进程。
- **关键命令**:GUI 选目标进程 → 加 DLL → 选注入方式(Manual Map 最隐蔽)→ Inject。

### Cheat Engine 7.7(用户锁定版,默认不更新)
- **路径**:`Debuggers\Cheat Engine\cheatengine-x86_64.exe`
- **核心用途**:内存扫描/锁定数值、Auto Assembler 打补丁、Lua 脚本自动化。
- **关键命令**:
  - 附加进程 → First Scan(值)→ 变化后 Next Scan 缩小 → 双击加入列表锁定。
  - `Ctrl+Alt+A` 打开 Auto Assembler 写 AOB 注入;指针扫描找稳定基址链。
  - MCP bridge:`autorun\ce_mcp_bridge.lua` 开机自动加载;需 CE 进程在跑。默认 `CE_MCP_ALLOW_SHELL=0`。

---

## Android / 移动端

### JADX 1.5.5(CLI + GUI)
- **路径**:CLI `Mobile-Android\jadx\bin\jadx.bat`;GUI `Mobile-Android\jadx-gui-1.5.5-with-jre-win\jadx-gui-1.5.5.exe`(带 JRE)
- **核心用途**:APK/DEX 一键反编译回 Java,读逻辑、找入口、搜敏感字符串。
- **关键命令**:
  - CLI:`jadx.bat -d <输出目录> <目标.apk>`;`--no-res` 跳资源加速。
  - `jadx.bat -e ...` 导出为 Gradle 工程;GUI 里 `Ctrl+Shift+F` 全局搜字符串/API。

### Apktool 3.0.2
- **路径**:`Mobile-Android\Apktool\apktool.jar`(需 Java)
- **核心用途**:解包/回编 APK 资源+smali+manifest,做重打包和补丁。
- **关键命令**:
  - 解包:`java -jar apktool.jar d <目标.apk> -o <输出>`。
  - 回编:`java -jar apktool.jar b <目录> -o <新.apk>`,之后需重签名才能装。

### MobSF(latest)
- **路径**:`Mobile-Android\MobSF\Mobile-Security-Framework-MobSF`
- **核心用途**:APK/IPA 自动化静态+动态安全评估,一键出权限/隐患/证书报告。
- **关键命令**:启动 `run.bat`(Windows)→ 浏览器传样本 → 看静态报告;API key 在设置里,mobsf-mcp 需要 URL+key。

### objection 1.12.5
- **路径**:`Mobile-Android\objection\.venv\Scripts\objection.exe`(基于 Frida)
- **核心用途**:免 root 运行时探索 App,一行命令绕 SSL pinning / root 检测。
- **关键命令**:
  - `objection -g <包名> explore` 进交互;
  - `android sslpinning disable`、`android root disable`、`android hooking list classes`。

---

## 网络 / HTTP

### Reqable 3.2.23
- **路径**:`Network-HTTP\reqable-app-windows-x86_64\Reqable.exe`
- **核心用途**:HTTP/HTTPS 抓包、改写、重放、断点——比 Fiddler 轻的现代抓包器。
- **关键命令**:开启系统代理/装 CA → 抓请求 → 右键 Replay 或设 Breakpoint 改包;可向 `127.0.0.1:18765/report` 上报 HAR 给 MCP。

### Wireshark / tshark 4.6.8
- **路径**:`Network-HTTP\Wireshark\portable\App\Wireshark\tshark.exe`(便携解出)
- **核心用途**:pcap 离线深度解析,按协议过滤/统计/追踪流。
- **关键命令**:
  - `tshark.exe -r <文件.pcap> -Y "http.request"` 显示过滤。
  - `tshark.exe -r <文件.pcap> -q -z io,phs` 协议分层统计;`-z follow,tcp,ascii,0` 追流。
  - 实时抓包需 Npcap(系统级驱动;本机已装 1.88 时服务名为 `npcap`)。

---

## 解包 / 游戏 / 格式恢复

### 7-Zip full 26.02 / extra
- **路径**:full `Unpackers-Game\7-Zip-full\7z.exe`;轻量 `Unpackers-Game\7-Zip\7za.exe`
- **核心用途**:万能第一步解包引擎——APK/JAR/MSI/CAB/ISO/NSIS/嵌套包先列后取。
- **关键命令**:
  - 列表:`7z.exe l <包>`;测试:`7z.exe t <包>`。
  - 提取保留结构:`7z.exe x <包> -o<输出目录>`;NSIS 安装器也能直接 `x`。

### Universal Extractor RC3
- **路径**:`Unpackers-Game\UniExtract\UniExtract\UniExtract.exe`
- **核心用途**:啃 7-Zip 搞不定的特殊安装器/自解压/多媒体封装。
- **关键命令**:GUI 拖入文件 → 选输出 → Extract;适合未知封装先试它。

### AssetRipper 1.3.14
- **路径**:`Unpackers-Game\AssetRipper\AssetRipper.GUI.Free.exe`
- **核心用途**:提取 Unity 资源并还原成可导入的 Unity 工程。
- **关键命令**:GUI → File → Open Folder 选游戏 `*_Data` 目录 → Export → 选 Unity 工程格式导出。

### Il2CppDumper 6.7.46
- **路径**:`Unpackers-Game\Il2CppDumper-net6-win-v6.7.46\Il2CppDumper.exe`
- **核心用途**:恢复 Unity IL2CPP 的类/方法元数据,拿到函数名和结构。
- **关键命令**:`Il2CppDumper.exe <GameAssembly.dll> <global-metadata.dat> <输出目录>`,生成 `dump.cs` + IDA/Ghidra 脚本用于符号导入。

### GoReSym(latest)
- **路径**:`Unpackers-Game\GoReSym\GoReSym.exe`
- **核心用途**:从剥离符号的 Go 二进制恢复函数名、类型、源码路径。
- **关键命令**:`GoReSym.exe <go_binary>` 输出 JSON 符号;喂给 Ghidra 脚本回填函数名。

### pyinstxtractor-ng(latest)
- **路径**:`Unpackers-Game\pyinstxtractor-ng\pyinstxtractor-ng.exe`
- **核心用途**:拆 PyInstaller 打包的 exe,取出 .pyc 再反编译。
- **关键命令**:`pyinstxtractor-ng.exe <目标.exe>` → 得到 `_extracted` 目录 → 主 pyc 用 decompyle3/pycdc 反编译。

---

## 系统巡检 / 取证

### Sysinternals Suite(latest)
- **路径**:`System-Forensics\SysinternalsSuite\`
- **核心用途**:微软官方系统内窥套件,查启动项/进程/句柄/网络/签名。
- **关键命令**(常用 exe):
  - `Autoruns64.exe` — 全启动点(注册表/服务/计划任务),红色=无签名可疑。
  - `procexp64.exe` — 进程树+句柄+DLL;`Procmon64.exe` — 实时文件/注册表/网络事件(先设过滤)。
  - `tcpview64.exe` — 实时连接;`sigcheck64.exe -a -h <文件>` — 签名+哈希核验。

### System Informer(latest)
- **路径**:`System-Forensics\systeminformer\SystemInformer.exe`
- **核心用途**:开源增强版任务管理器,深挖进程/服务/驱动/句柄/网络。
- **关键命令**:双击进程看 Threads/Modules/Handles;右键 → Miscellaneous → Terminator 强杀顽固进程。

### Volatility 3(latest)
- **路径**:`System-Forensics\volatility3`(需 Python)
- **核心用途**:内存镜像取证,从 dump 里挖进程/网络/注入/命令历史。
- **关键命令**:
  - `vol -f <镜像.raw> windows.pslist`(进程)、`windows.netscan`(网络)、`windows.malfind`(注入代码)。
  - `windows.cmdline`、`windows.dlllist`、`windows.handles`;volatility3-mcp 把这些插件暴露给 AI。

---

## MCP / AI 辅助分析

**策略**:默认只启用 `debugger-router` 一个轻量 MCP,它按需临时启动 19 个后端里需要的那个,用完退出。不要一次性全加载。需要直连用 profile。

启动脚本目录:`MCP\bin\`;配置:`MCP\.mcp.json`(bootstrap 生成)。

### 直连 profile(Codex)

| Profile | 直连后端 |
| --- | --- |
| `mcp-mobile` | JADX、Apktool、Frida、MobSF、Reqable |
| `mcp-re` | Ghidra、IDA Pro、radare2、x64dbg、ImHex、ILSpy、dnSpy、ReClass、7-Zip、YaraFlux |
| `mcp-net` | Wireshark、Reqable |
| `mcp-ce` | Cheat Engine、x64dbg、ReClass |
| `mcp-intel` | Volatility3、VirusTotal、YaraFlux |
| `mcp-all` | 全部 19 个后端 |

示例:`codex --profile mcp-mobile`。

### 后端一览

| MCP | 启动器 | 用法要点 |
| --- | --- | --- |
| **Debugger Router**(自研,默认启用) | `debugger-router-mcp.cmd` | 工具:`list_backends` / `list_backend_tools` / `call_backend_tool` / `smoke_backend` / `workflow_help`。AI 分析入口。 |
| GhidraMCP | `ghidra-mcp.cmd` | 需 Ghidra 开项目+装插件才能真实分析。 |
| IDA Pro MCP | `ida-pro-mcp.cmd` | 需 IDA Pro 8.3+ 打开并 `--install` 插件,端口 13337。 |
| radare2 MCP | `radare2-mcp.cmd` | 纯 C 官方 r2mcp,先 `r2pm -Uci r2mcp`。 |
| x64dbg automate MCP | `x64dbg-mcp.cmd` | 需 automate 插件 + 活调试会话。 |
| JADX MCP | `jadx-mcp.cmd` | 已强制 UTF-8;真实分析需 JADX GUI plugin listener。 |
| Apktool MCP | `apktool-mcp.cmd` | 工作区 `MCP\workspaces\apktool`。 |
| Frida MCP | `frida-mcp.cmd` | 取决于 Frida 设备/进程;其 .venv 被 router 复用为 python 解释器。 |
| YaraFlux MCP / HTTP | `yaraflux-mcp.cmd` / `yaraflux-http.cmd` | 规则+样本+扫描管理;HTTP 默认健康端口 8000。 |
| MobSF MCP | `mobsf-mcp.cmd` | 需 MobSF URL + API key。 |
| ImHex MCP | `imhex-mcp.cmd` | 需 ImHex 网络接口 `localhost:31337`。 |
| ILSpy MCP | `ilspy-mcp.cmd` | 用 `MCP\Runtime\dotnet`;clone 后须 `dotnet publish`。 |
| dnSpy MCP | `dnspy-mcp.cmd` | 独立 stdio MCP。 |
| Wireshark MCP | `wireshark-mcp.cmd` | 已绑便携 tshark/dumpcap;离线 pcap 可用。 |
| Reqable MCP | `reqable-mcp-local.cmd` | Reqable 上报 HAR 到 `127.0.0.1:18765/report`。 |
| ReClass.NET MCP | `reclass-mcp.cmd` | 需 ReClass.NET 开启并加载插件(TCP 27015)。 |
| 7-Zip MCP | `7zip-mcp.cmd` | 已绑本地 `7z.exe`。 |
| Cheat Engine MCP | `cheatengine-mcp.cmd` | 需 CE 加载 Lua bridge;默认 `CE_MCP_ALLOW_SHELL=0`(安全关闭),确需任意 shell 才手动改 1。 |
| Volatility3 MCP | `volatility3-mcp.cmd` | 内存取证,需 Python + dump/raw 镜像。 |
| VirusTotal MCP | `virustotal-mcp.cmd` | 需 `VIRUSTOTAL_API_KEY`;IOC 发往公网 API,仅授权调查。 |

> 冒烟测试:核心 CLI `--version`,router `smoke_backend <名>`。
