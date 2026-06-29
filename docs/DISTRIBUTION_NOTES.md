# D:\Tool\debugger 分发说明

本目录是一个便携式逆向、安全分析、调试、解包、移动端分析、网络抓包、系统巡检和 MCP 自动化工具箱。

> **说明(GitHub 读者)**:本文档描述 **bootstrap 部署后** 的工作站。`OriginalBase\`、`Launchers\`、`Reports\` 等目录由你在本机生成,骨架仓库中不含。

## 推荐解压位置

推荐解压到：

```text
D:\Tool\debugger
```

大部分启动器已经按相对路径设计或可在分发 staging 中改写为相对路径。如果解压到其他位置，普通 `.cmd` 启动器通常仍可用；Codex/Claude 等 AI 的 MCP 配置需要按实际路径改写。

## 第一时间阅读

给人和 AI agent 的阅读顺序：

1. `TOOLS_INDEX.md`
2. `AI_USAGE_GUIDE.md`
3. `AGENTS.md`
4. `MCP\codex-mcp-config.example.toml`
5. `Reports\INDEX.md`

进入 `OriginalBase` 前还要读：

```text
OriginalBase\AGENTS.md
```

## 工具入口

用户可直接从 `Launchers\` 进入：

| 分类 | 路径 |
| --- | --- |
| 静态逆向 | `Launchers\01_Static-Reversing\` |
| 调试/动态分析 | `Launchers\02_Debuggers\` |
| Android 移动端 | `Launchers\03_Mobile-Android\` |
| HTTP/网络调试 | `Launchers\04_Network-HTTP\` |
| 解包/游戏/格式恢复 | `Launchers\05_Unpackers-Game\` |
| 系统巡检/取证 | `Launchers\06_System-Forensics\` |

## AI/MCP 用法

默认推荐只启用 `debugger-router`，它会按需临时启动后端 MCP。不要默认一次性加载全部 15 个后端，除非你明确要做全量 MCP 调试。

核心入口：

```text
MCP\bin\debugger-router-mcp.cmd
MCP\.mcp.json
MCP\codex-mcp-config.example.toml
```

可用后端包括 Ghidra、x64dbg、JADX、Apktool、Frida、ImHex、YaraFlux、MobSF、ILSpy、dnSpy、Wireshark、Reqable、ReClass、7-Zip、Cheat Engine。

真实使用限制：

- Ghidra/JADX/ImHex/ReClass/Cheat Engine 这类 GUI 或插件型工具，需要对应 GUI、插件、bridge 或本地端口配合。
- Wireshark 离线 pcap 分析可便携使用；实时抓包仍需要 Npcap/权限。
- MobSF 真实扫描需要 MobSF 服务 URL/API key。
- Frida 真实运行时分析需要设备、进程和授权。

## 分发包应排除

分发包不应包含：

- `.git` 历史目录。
- `.env`、API key、token、私有证书、个人凭据。
- `MCP\workspaces` 临时工作区。
- `MCP\YaraFlux\data` 扫描/样本/结果数据。
- `.codex_extracted`、临时解包目录、一次性缓存。
- 用户样本、dump、pcap、APK、Cheat Engine 表。
- 不明来源的运行输出。

详细排除策略见：

```text
Reports\DISTRIBUTION_EXCLUDES_20260621.md
```

## 安全边界

这些工具包含调试器、注入器、Hook、Frida、反反调试插件、抓包工具和内存分析工具，可能被安全软件拦截。不要在宿主机直接运行未知样本或恶意样本。高风险样本应放 VM/沙箱。

本工具箱不应自动安装驱动、服务、Npcap、Defender 例外、计划任务或注册表项。需要这些能力时，先由使用者明确授权并理解影响。

## 更新原则

更新工具时遵守：

1. 先核验官方/GitHub 最新版本。
2. 原始包放 `OriginalBase\<分类>\`。
3. 可运行目录放外层分类目录。
4. smoke test。
5. 清理临时残留。
6. 更新 `TOOLS_INDEX.md` 和 `Reports\`。

Cheat Engine 不默认更新，除非使用者明确要求。
