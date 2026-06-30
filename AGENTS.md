# AGENTS.md — debugger-workstation

> 本文件是本仓库面向所有 AI agent 的**权威入口**(开放 AGENTS.md 标准,被 Codex / Copilot / Cursor / Gemini CLI 等采纳)。
> Claude Code 通过根目录 `CLAUDE.md` 的 `@AGENTS.md` 导入本文件。
> 任何 AI clone 本仓库后:**先读本文件,再执行第 1 节的初始化握手。**

---

## 0. 这是什么

一个便携式逆向 / 安全分析 / 调试 / 解包 / 移动端分析 / 网络抓包 / 系统巡检 / MCP 自动化工作站的**骨架仓库**。

- 本仓库**不含第三方工具二进制**(版权 + 体积),工具靠 `manifests/` + `scripts/bootstrap.ps1` 从官方源拉取。
- 仓库自带:自研 MCP 路由(`mcp/debugger-router`)、后端包装脚本(`mcp/bin`)、配置模板、清单、文档。
- 详见 `README.md`、`DISCLAIMER.md`。

---

## 1. 初始化握手协议(最重要 — 先问后做)

当用户让你"初始化/安装/搭建/部署这个工作站"时,**不要直接动手**。先按官方 explore→plan→code 工作流,完成一轮澄清:

### 第 1 步:探索(只读)
读取 `README.md`、本文件、`manifests/tools.json`、`manifests/mcp-backends.json`、`docs/AI_USAGE_GUIDE.md`,并检测当前环境:
- 操作系统(本工作站主力为 Windows;路径用反斜杠)。
- 是否已安装 `git`、`python`(≥3.10)、`pwsh`/`powershell`、`dotnet`、`node`、`java`。
- 目标安装根目录是否已存在工具。

### 第 2 步:提问(必须)
向用户提出澄清问题,直到你有 ≥90% 把握能正确完成,**至少覆盖**:
1. **安装根目录**?(默认 `D:\Tool\debugger`)
2. **范围**:全部工具,还是只要某几类?(static-reversing / debuggers / mobile-android / network-http / unpackers-game / system-forensics / mcp)
3. **MCP 后端**:是否 clone 全部 13 个第三方 MCP?是否包含需要 `.env`/API key 的(YaraFlux、MobSF)?
4. **工具二进制**:由用户手工按官方源下载,还是授权你联网核验后下载?(下载第三方二进制属于需确认动作)
5. **是否更新到最新版**:`manifests` 标了 `update_available` 的(如 YARA-X、7-Zip),用记录版本还是拉最新?
6. **AI 客户端**:用户用哪个(Claude Code / Codex / Gemini / Cursor / Copilot)?据此生成对应入口与 MCP 配置。
7. **系统级能力**:是否需要 Npcap(Wireshark 实时抓包)等需要管理员/驱动的组件?(默认**不装**,见第 4 节)

> 把问题做成结构化选项,给出推荐默认值。用户回答前不要写盘、不下载、不 clone。

### 第 3 步:生成计划
基于回答,列出将执行的具体动作(哪些目录、哪些 clone、哪些下载、生成哪些配置),给用户审阅。

### 第 4 步:执行
用户确认后:
1. `pwsh scripts/bootstrap.ps1 -InstallRoot "<根>"`（先 dry-run）。
2. 确认无误 → `-Apply`（部署自研 router/bin + 生成本机 `.mcp.json`/codex toml）。
3. 按范围加 `-CloneMcp`（clone 第三方 MCP）。
4. 按 `manifests/tools.json` 的官方源获取工具二进制到对应分类目录。
5. 重建第三方 MCP 依赖（`.venv` / `dotnet build` / `npm install`），按 `build` 字段。
6. **冒烟测试**：核心 CLI `--version`、router `smoke_backend`。

### 第 5 步:收尾
报告:装了什么、生成了哪些配置、验证结果、未完成项与原因、剩余风险。

---

## 2. MCP 策略

- 默认**只启用 `debugger-router`** 一个轻量 MCP,它按需临时启动 19 个后端中需要的那个,用完退出。
- 不要默认一次性加载全部后端。需要直连时用 profile:`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-all`。
- 配置模板:`mcp/.mcp.json.template`、`mcp/codex-mcp-config.example.toml`(bootstrap 替换 `{{DEBUGGER_ROOT}}`)。
- 后端清单与上游:`manifests/mcp-backends.json`。

## 3. 关键命令

```bash
# 还原工作站(默认 dry-run,加 -Apply 执行,加 -CloneMcp 拉第三方 MCP)
pwsh scripts/bootstrap.ps1 -InstallRoot "D:\Tool\debugger"

# 校验 manifest JSON
python -c "import json,glob;[json.load(open(f,encoding='utf-8')) for f in glob.glob('manifests/*.json')]"
```

部署后核心冒烟(路径相对安装根):
```
Static-Reversing\capa\capa.exe --version
Static-Reversing\YARA-X\yr.exe --version
Unpackers-Game\7-Zip-full\7z.exe
Mobile-Android\jadx\bin\jadx.bat --version
```

## 4. 边界与安全(硬规则)

- **不分发第三方工具二进制**;只记录官方源,由 bootstrap/用户获取。版权归各官方,见 `DISCLAIMER.md`。
- **不无声装系统级组件**:驱动、服务、Npcap、Defender 例外、注册表、启动项、计划任务——需要时先说明后果和回滚,得到用户明确同意再做。
- **不提交凭据/样本**:`.env`、API key、token、证书、pcap、dump、APK、CT 表绝不入库(已由 `.gitignore` 排除)。
- **不在宿主机跑未知/恶意样本**;高风险样本放 VM/沙箱。
- 工具含调试器/注入器/Hook/抓包,可能触发杀软/EDR;仅用于授权的安全测试、CTF、研究、教育用途。
- 下载第三方二进制、clone 大量仓库、写入安装根目录之外的路径,属于需向用户确认的动作。

## 5. 仓库结构

```
AGENTS.md / CLAUDE.md       本入口(后者 import 前者)
README.md / DISCLAIMER.md / LICENSE
docs/                       WORKSTATION_RULES / AI_USAGE_GUIDE / DISTRIBUTION_NOTES / TOOLS_INDEX + extensions/
manifests/                  tools.json(工具+官方源)/ mcp-backends.json(MCP 上游)
mcp/                        debugger-router(自研)/ bin(自研脚本)/ 配置模板
scripts/                    bootstrap.ps1(还原工作站,默认 dry-run)
templates/                  各 AI 客户端入口模板 + 初始化问卷
.cursor/ .github/           Cursor / Copilot 入口
```

## 6. 给 AI 的默认语言

默认用**中文**回答和记录(本工作站作者偏好),除非用户要求英文。路径用绝对路径或从安装根的相对路径。
