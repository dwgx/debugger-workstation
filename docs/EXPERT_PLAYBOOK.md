# EXPERT_PLAYBOOK.md — 逆向 / 恶意样本 / 安全分析实战手册

> 场景驱动。每节 = 遇到什么 → 怎么下手 → 具体命令参数 → 组合拳 → 老手才知道的坑。
> 路径相对安装根(`D:\Tool\debugger`)。工具明细见 `TOOLS_INDEX.md`。

---

## 0. 拿到任意样本的第一分钟(分诊 / triage)

**目标**:5 分钟内判断——这是什么、什么语言/编译器、有没有壳、大概会干什么、值不值得深挖。

```
# 1. 是什么 + 有没有壳(最先跑)
Static-Reversing\die_win64_portable_3.21_x64\die\diec.exe -e <样本>
# 2. 会干什么(能力速览)
Static-Reversing\capa\capa.exe <样本>
# 3. 藏了什么字符串(含解码后的)
Static-Reversing\FLOSS\floss.exe -q <样本>
# 4. 导入表判行为
Static-Reversing\PE-bear\PE-bear.exe   # 看 Imports / Sections 熵
```

**读数逻辑(老手判断)**:
- DiE 报 entropy > 7.2 且节区名怪(`.aspack` `.upx` `UPX0` `.themida`)→ **加壳**,先脱壳再分析,直接反编译看到的全是 stub。
- capa 空手而回但文件不小 → 几乎肯定加壳/加密,回去脱。
- 导入表只有 `LoadLibrary`+`GetProcAddress`+`VirtualAlloc` → 动态解析 API,静态看不到真实行为,准备上动态。
- FLOSS 的 **decoded/stack strings** 段最值钱:C2 域名、mutex 名、注册表键常藏在这里,普通 `strings` 抓不到。
- 一眼认语言:Go(节区 `.gopclntab`、字符串一大坨路径)→ 走 §6;.NET(导入 `mscoree.dll`)→ 走 §3;PyInstaller(字符串含 `_MEIPASS`)→ 走 §7;IL2CPP(有 `GameAssembly.dll`+`global-metadata.dat`)→ 走 §7。

**组合拳**:`diec -e` 判壳 → 没壳直接 `capa -v` 定位能力地址 → 拿地址进 Ghidra 精读那几个函数。别一上来就通读全程序反编译,先让 capa 告诉你去哪看。

---

## 1. PE / 原生 Windows 样本静态精读

**场景**:无壳(或已脱壳)的 x86/x64 PE,要搞清核心逻辑。

```
# 主力:Ghidra 深度分析
Static-Reversing\Ghidra\ghidra_12.1.2_PUBLIC\ghidraRun.bat
#   导入 → Analyze 全开 → Symbol Tree 找 entry/main
# 脚本化批处理多个样本:
Static-Reversing\Ghidra\...\support\analyzeHeadless.bat <项目dir> proj -import <样本> -postScript export_strings.py

# 想快/想脚本化:radare2
Static-Reversing\radare2\bin\r2.exe -A <样本>
#   aaa → afl(列函数)→ pdf @ sym.main(反汇编)→ axt @ <addr>(谁调它)
```

**老手技巧**:
- Ghidra 反编译变量全是 `uVar1`,先用 capa/FLOSS 的命中地址当锚点,`G` 跳过去,只重命名你真正关心的那条调用链,别贪全图。
- 追 API 用法反向想:关心网络就在 Symbol Tree 搜 `WSASend`/`InternetOpen`/`HttpSendRequest`,`Ctrl+Shift+F` 看谁调它 → 直接落到 C2 逻辑,比顺着 main 读快十倍。
- Ghidra 的函数签名错了(参数个数不对)导致反编译乱 → 手动 `Edit Function Signature` 修调用约定(常见 `__stdcall`/`__fastcall` 判错)。

**组合拳**:capa `-j` 出 JSON → 提取 ATT&CK 命中的地址 → Ghidra headless postScript 自动跳转+导出这些函数的反编译 C 码 → 只人读这几段。

---

## 2. 加壳样本脱壳(UPX / 商业壳 / 自写壳)

**场景**:DiE 报壳,capa 空,导入表只剩几个函数。

**UPX(最常见,先试自动)**:
```
Static-Reversing\radare2\bin\... 或直接
# UPX 官方壳:很多样本改了魔数骗 upx -d,先看能否直接脱
```

**通用手动脱壳(x64dbg,适用绝大多数壳)**:
```
Debuggers\x64dbg\release\x64\x64dbg.exe   # 打开样本
# 反反调试先挂上,否则壳检测到调试器就跑偏或退出:
#   Plugins → ScyllaHide → profile: x64dbg-stealth64,勾全部
# 找 OEP 常用手法:
#   bp VirtualAlloc / bp VirtualProtect → 壳解压完会分配 RWX 内存
#   或用 "run until user code" / ESP trick(硬件断点下在初始 ESP)
# 到 OEP 后:右键 → 用 Scylla 插件 → Dump → IAT Autosearch → Get Imports → Fix Dump
```

**老手坑**:
- 没挂 ScyllaHide 就调试 Themida/VMProtect,90% 会崩或走假分支。先隐藏再运行。
- Dump 后一定要 **修 IAT**(Scylla 的 Fix),否则 dump 出来导入表全断,静态工具照样读不出。
- 脱壳后的 dump 拿去重新跑 `diec` 确认熵降下来了 + `capa` 这次能出货,才算脱干净。

**组合拳**:x64dbg 脱壳+Scylla dump → 对 dump 跑 DiE 验证 → capa/FLOSS 重新提取(这次才有真东西)→ 进 Ghidra 精读。

---

## 3. .NET 样本(C# / IL)

**场景**:DiE 报 .NET,或导入 `mscoree.dll`。

```
# 只读浏览/导出源码:ILSpy
Static-Reversing\ILSpy\ILSpy.exe            # 拖入,右键 Save Code 导出整工程
Static-Reversing\ILSpy\ilspycmd.exe <dll> -o <out>   # 命令行批量

# 要动态调试 + 改代码:dnSpyEx(主力)
Static-Reversing\dnSpyEx\dnSpy.exe
#   F9 下断 → F5 调试 → 右键方法 Edit Method 改 C#/IL → Compile → File Save Module 打补丁
```

**老手技巧**:
- .NET 样本常有 **混淆**(ConfuserEx/.NET Reactor):dnSpy 里方法名是 `​` 之类不可见字符或乱码。先过 de4dot(若有)或在 dnSpy 里下断点动态看解密后的字符串,别硬读混淆 IL。
- 字符串加密:在 `System.String` 相关解密函数下断,`F5` 跑一圈,Locals 窗口直接看明文。
- 反调试/反 dump:dnSpy 调试时若样本检测 `Debugger.IsAttached`,直接在该属性 getter 下断改返回值。

**组合拳**:ILSpy 快速通读结构定位可疑方法 → dnSpy 在该方法下断动态跑 → 拿到解密后的 C2/配置 → 若需重打包在 dnSpy 里 Edit+Save。

---

## 4. 动态行为分析(跑起来看它干什么)

**场景**:静态卡住(重混淆/动态解析),或想快速拿 IOC。**在 VM/沙箱里做**。

```
# 事前布好监控(Sysinternals):
System-Forensics\SysinternalsSuite\Procmon64.exe   # 先设过滤:Process Name is <样本>
System-Forensics\SysinternalsSuite\procexp64.exe   # 看进程树/子进程/注入
System-Forensics\SysinternalsSuite\tcpview64.exe   # 实时外连
System-Forensics\SysinternalsSuite\Autoruns64.exe  # 跑前跑后对比,看新增持久化
```

**方法论**:
1. Procmon 先只过滤样本进程名,跑样本,停,再看:写了哪些文件(payload 落地)、改了哪些注册表(持久化/配置)、连了哪(C2)。
2. Process Explorer 看有没有 **进程镂空/注入**(子进程路径怪、内存里有额外映像)。
3. 跑前 Autoruns 存一份,跑后再存一份,diff 出新增启动项 = 持久化机制。
4. 想抓网络明文 → 配合 §5 Reqable 代理 + Wireshark。

**老手坑**:
- Procmon 不设过滤直接跑,几秒几十万条淹死你。**先过滤进程名再跑样本**。
- 很多样本检测 VM(查 MAC/注册表/进程名 vmtoolsd),不落地就退。这时回静态,或用反检测加固的沙箱。
- 想抓短命子进程,Procmon 里勾 "Enable boot logging" 或用 Procmon 的进程树导出。

---

## 5. 网络流量 / C2 分析

**场景**:样本有外连,或要分析 API/协议。

```
# HTTPS 明文抓改重放:Reqable
Network-HTTP\reqable-app-windows-x86_64\Reqable.exe
#   开系统代理 + 装 CA 证书 → 抓样本/App 的 HTTPS → 右键 Breakpoint 改包 / Replay 重放

# 离线 pcap 深挖:tshark
Network-HTTP\Wireshark\tshark.exe -r c2.pcap -Y "http.request" -T fields -e http.host -e http.request.uri
Network-HTTP\Wireshark\tshark.exe -r c2.pcap -q -z io,phs         # 协议分层,看有没有异常协议
Network-HTTP\Wireshark\tshark.exe -r c2.pcap -z follow,tcp,ascii,0 -q   # 追第一条 TCP 流的裸数据
```

**老手技巧**:
- C2 常用 HTTP 但 body 是自定义加密/base64 套娃。`tshark` 提取 body → ImHex 的 Data Processor 搭异或+base64 解码链还原。
- 抓移动端 App:Reqable 做代理,配合 objection `android sslpinning disable` 绕过证书绑定(否则 App 拒连你的代理)。
- pcap 里看不到明文但确定有外连 → 样本自带证书校验,回到样本在加密函数前下断抓明文。

**组合拳**:Reqable 抓到加密请求 → 定位到样本里的加密函数(FLOSS 找密钥字符串给线索)→ x64dbg 在加密前下断抓明文 payload → 还原 C2 协议。

---

## 6. Go 二进制

**场景**:DiE/节区显示 Go(`.gopclntab`),函数名被剥离,Ghidra 里全是 `sub_xxx`。

```
Unpackers-Game\GoReSym\GoReSym.exe <go_binary> > syms.json
#   恢复函数名/类型/源码路径 → 用 Ghidra 脚本回填,sub_xxx 变回真实函数名
```

**老手技巧**:
- Go 静态链接体积巨大,别通读。GoReSym 恢复符号后,直接搜业务包路径(如 `main.`、项目 GitHub 路径)定位自写逻辑,标准库/runtime 全跳过。
- Go 字符串没有 null 结尾、是 (ptr,len) 结构,`strings` 会把一大片连成一坨。信 GoReSym + Ghidra 的 Go 字符串识别,别信裸 strings。

**组合拳**:GoReSym 出符号 JSON → Ghidra headless 跑回填脚本 → 只看 `main.*` 包函数。

---

## 7. 打包 / 运行时封装恢复

### PyInstaller(exe 里塞 Python)
```
Unpackers-Game\pyinstxtractor-ng\pyinstxtractor-ng.exe <目标.exe>
#   → <目标>_extracted\ 里找入口 pyc(通常和 exe 同名,无扩展名或 .pyc)
#   → 用 decompyle3 / pycdc 反编译 pyc 回 .py
```
**坑**:提取出的主 pyc 可能缺 magic header,用 pyinstxtractor-ng 会自动补;版本对不上时手动加对应 Python 版本的 magic 前 16 字节。

### Unity IL2CPP
```
Unpackers-Game\Il2CppDumper-net6-win-v6.7.46\Il2CppDumper.exe <GameAssembly.dll> <global-metadata.dat> <out>
#   → dump.cs(全部类/方法)+ ida/ghidra 脚本(script.json/.py 回填符号)
```
**组合拳**:Il2CppDumper 出 `dump.cs` 看逻辑 + 生成的脚本导入 Ghidra 给 `GameAssembly.dll` 的函数命名 → 两边对照精读。

### Unity 资源
```
Unpackers-Game\AssetRipper\AssetRipper.GUI.Free.exe   # Open Folder 选 *_Data → Export 成 Unity 工程
```

### 未知安装器/自解压
```
Unpackers-Game\7-Zip-full\7z.exe l <包>     # 先列,7z 认识就直接 x
Unpackers-Game\UniExtract\UniExtract.exe    # 7z 搞不定的特殊封装
```

---

## 8. Android APK 全流程

**场景**:拿到 APK,要读逻辑 / 找隐患 / 改行为。

```
# 快速读代码:JADX(APK → Java)
Mobile-Android\jadx\bin\jadx.bat -d out <目标.apk>
Mobile-Android\jadx-gui-1.5.5-with-jre-win\jadx-gui-1.5.5.exe   # GUI 全局搜

# 改资源/smali 重打包:Apktool
java -jar Mobile-Android\Apktool\apktool.jar d <apk> -o work
#   改 smali/AndroidManifest.xml 后:
java -jar Mobile-Android\Apktool\apktool.jar b work -o patched.apk
#   重签名才能装(apksigner/自签)

# 运行时 Hook / 绕检测:objection(需设备+Frida)
Mobile-Android\objection\.venv\Scripts\objection.exe -g <包名> explore
#   android sslpinning disable / android root disable / android hooking watch class <cls>

# 自动化静态报告:MobSF
Mobile-Android\MobSF\...\run.bat   # 传 APK 出权限/证书/隐患报告
```

**方法论**:
1. 先 JADX 通读:`AndroidManifest.xml` 找入口 Activity/Service/Receiver + 危险权限;全局搜 `http`/`api`/密钥常量。
2. 逻辑在 native `.so` 里 → JADX 只看到 `native` 声明,拉出 `lib/arm64-v8a/*.so` 进 Ghidra。
3. 要动态验证/绕过 → objection 免 root hook;SSL pinning 挡代理时先 `sslpinning disable` 再上 Reqable 抓包。

**老手坑**:
- 加固 APK(360/腾讯/爱加密):JADX 只能看到壳的加载器,真 dex 运行时才解密。需脱壳(FRIDA-DEXDump 类思路,运行时从内存 dump dex)。
- JADX 反编译报错的方法切到 smali 视图硬读,或换 Apktool 出 smali。

**组合拳**:JADX 读逻辑定位可疑点 → objection 运行时 hook 那个类看真实参数/返回 → Reqable 抓它的网络 → 三管齐下还原完整行为。

---

## 9. 内存取证(拿到内存镜像)

**场景**:有 `.raw`/`.dmp`/`.mem` 镜像,要挖运行时状态(注入、隐藏进程、C2 连接、命令历史)。

```
System-Forensics\volatility3 (需 Python)
vol -f mem.raw windows.pslist        # 进程列表
vol -f mem.raw windows.pstree        # 进程树(看父子关系找可疑起源)
vol -f mem.raw windows.netscan       # 网络连接(C2)
vol -f mem.raw windows.malfind       # 检测代码注入(RWX 私有内存里的 PE)
vol -f mem.raw windows.cmdline       # 各进程命令行(抓 powershell -enc 等)
vol -f mem.raw windows.dlllist --pid <PID>
```

**老手方法**:`pstree` 找异常父子(explorer 生 cmd 生 powershell 很正常,svchost 直接生 cmd 就可疑)→ `malfind` 定位注入 → dump 出注入段(`--dump`)喂给 capa/Ghidra。`netscan` 的外连 IP 直接丢 VirusTotal MCP 查信誉。

---

## 10. 威胁情报 / 规则化(把发现变成可复用产物)

```
# 命中 IOC 查信誉(需 VIRUSTOTAL_API_KEY):
MCP\bin\virustotal-mcp.cmd   # 哈希/域名/IP/URL 查 VT
#   注意:哈希/IOC 会发往 VT 公网,别传敏感样本本体

# 把特征写成 YARA 规则复用:
Static-Reversing\YARA-X\yr.exe check my_rule.yar        # 语法校验
Static-Reversing\YARA-X\yr.exe scan my_rule.yar -r <目录>   # 批量扫本地样本库验规则
Static-Reversing\YARA-X\yr.exe fmt my_rule.yar          # 格式化
```

**老手技巧**:写 YARA 规则挑 **稳定且独特** 的锚:解密后的 C2 字符串、独特的常量数组、特征代码字节序列(带通配 `?? ??`),别用编译器公共 stub 当特征(误报爆炸)。FLOSS 的 decoded strings 是最好的规则素材来源。

---

## 11. MCP 驱动的 AI 自动化(让 router 干活)

默认只开 `debugger-router`。AI 分析时的标准姿势:

```
list_backends                          # 有哪些后端
list_backend_tools <backend>           # 某后端能干什么
smoke_backend <backend>                # 先冒烟确认能起来
call_backend_tool <backend> <tool> {…} # 真正调用
workflow_help                          # 内置工作流提示
```

**要点**:
- router 按需临时起后端、用完退,别手动把 19 个全拉起来。
- 需要持续直连(如整场 Ghidra 分析)才切 profile(`mcp-re` 等)。
- 需 key 的后端(VirusTotal / MobSF / YaraFlux)先配好 `.env`,否则 smoke 就挂。
- 真实分析类后端(Ghidra/IDA/ReClass/CE)必须先在对应 GUI 里开项目+加载插件,MCP 只是通道,不开 GUI 就是空连接。

---

## 12. 决策速查(遇到 X 用什么)

| 你手里的东西 | 第一步 | 主力工具 |
| --- | --- | --- |
| 任意 exe,不知道啥 | `diec -e` + `capa` + `floss` | §0 分诊 |
| 无壳原生 PE | Ghidra(capa 定位后精读) | §1 |
| 高熵/怪节区/capa 空 | x64dbg + ScyllaHide 脱壳 | §2 |
| .NET(mscoree) | ILSpy 读 / dnSpy 调试改 | §3 |
| 静态卡死,要行为 | Procmon+ProcExp+TCPView(VM 内) | §4 |
| 有外连/要抓包 | Reqable(HTTPS)/ tshark(pcap) | §5 |
| Go 二进制 | GoReSym 恢复符号 → Ghidra | §6 |
| PyInstaller exe | pyinstxtractor-ng → pyc 反编译 | §7 |
| Unity/IL2CPP | Il2CppDumper / AssetRipper | §7 |
| APK | JADX 读 → objection hook → Apktool 改 | §8 |
| .so native | 从 APK 拉出进 Ghidra | §8 |
| 内存镜像 | Volatility3(pstree→malfind→netscan) | §9 |
| 要查 IOC 信誉 | VirusTotal MCP | §10 |
| 要沉淀检测规则 | YARA-X(锚定解密字符串) | §10 |
