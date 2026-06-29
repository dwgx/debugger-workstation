# 初始化问卷模板 (INIT_QUESTIONNAIRE)

> AI 用此清单驱动"先问后做"的动态初始化。读取后向用户提问(做成结构化选项 + 推荐默认),收齐回答再生成计划。用户回答前不写盘、不下载、不 clone。

## Q1. 安装根目录
工作站装到哪个目录?
- 推荐默认:`D:\Tool\debugger`
- 影响:所有 bin 脚本相对路径、生成的 `.mcp.json` 中的 `{{DEBUGGER_ROOT}}` 替换值。

## Q2. 工具范围
要哪些类别?(可多选)
- [ ] static-reversing(Ghidra / PE-bear / ImHex / DiE / capa / FLOSS / YARA-X / ILSpy / dnSpyEx / ReClass.NET)
- [ ] debuggers(x64dbg / ScyllaHide / GH Injector / Cheat Engine)
- [ ] mobile-android(JADX / Apktool / MobSF / objection)
- [ ] network-http(Reqable / Wireshark)
- [ ] unpackers-game(7-Zip / UniExtract / AssetRipper / Il2CppDumper / GoReSym / pyinstxtractor-ng)
- [ ] system-forensics(Sysinternals / System Informer)
- 推荐默认:全部。

## Q3. MCP 后端范围
- [ ] 只部署自研 `debugger-router` + bin(最小,默认)
- [ ] clone 全部 13 个第三方 MCP（`-CloneMcp`）
- [ ] 只 clone 选定类别对应的 MCP
- 需 `.env`/API key 的(YaraFlux、MobSF):是否现在配置?(默认跳过,用占位)

## Q4. 工具二进制获取方式
- [ ] 用户手工按 `manifests/tools.json` 官方源下载(默认,最稳妥)
- [ ] 授权 AI 联网核验官方 release 后下载(属需确认动作,逐项报告)
- 注意:下载第三方二进制涉及版权与体积,默认不自动做。

## Q5. 版本策略
- [ ] 用 manifest 记录版本
- [ ] 拉各官方最新(标了 `update_available` 的如 YARA-X 1.19.0、7-Zip 26.02 会更新)
- 推荐默认:记录版本 + 提示可更新项。

## Q6. AI 客户端
你主要用哪个?(据此确认生成的入口与 MCP 配置)
- [ ] Claude Code（`CLAUDE.md` + `.mcp.json`)
- [ ] Codex（`AGENTS.md` + `codex-mcp-config.toml`）
- [ ] Gemini CLI（`GEMINI.md`）
- [ ] Cursor（`.cursor/rules`）
- [ ] GitHub Copilot（`.github/copilot-instructions.md`）

## Q7. 系统级组件(高风险,默认全否)
是否需要以下需要管理员/驱动的组件?(需明确同意)
- [ ] Npcap(Wireshark 实时抓包;不装则只能离线分析 pcap)
- [ ] 其他驱动/服务/右键菜单/PATH 注册
- 推荐默认:全部不装,保持便携、可整体删除。

## Q8. 运行时依赖
缺失时是否允许 AI 协助安装?(Java for Ghidra/Apktool、Python≥3.10、.NET、Node)
- 推荐默认:检测并提示,由用户决定安装方式。

---

## 收齐后:生成计划
把回答汇总成一份执行计划(目标目录、clone 列表、下载列表、生成的配置文件、冒烟项),给用户审阅,确认后再执行 `scripts/bootstrap.ps1`。
