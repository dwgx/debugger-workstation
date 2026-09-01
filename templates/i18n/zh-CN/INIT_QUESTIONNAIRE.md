# 初始化问卷（debugger-workstation）

AI：在 `bootstrap.ps1 -Apply` 或 `download-tools.ps1 -Apply` 之前问完。结构化选项 + 推荐默认。英文正文：[templates/INIT_QUESTIONNAIRE.md](../../INIT_QUESTIONNAIRE.md)。语言规则：[docs/i18n/zh-CN/I18N.md](../../../docs/i18n/zh-CN/I18N.md)。

## Q0. 界面语言

Agent 对话用哪种语言？
- [ ] English（`en`）
- [ ] 简体中文（`zh-CN`）
- [ ] 日本語（`ja`）
- [ ] 한국어（`ko`）
- 推荐：与用户正在打的字一致。写入 gitignore 的 `local.json` 字段 `ui_language`。git 提交说明保持英文。

## Q1. 安装根目录

工作站放在哪里？
- 推荐：`D:\Tool\debugger`（或本 clone）。
- 影响包装脚本路径，以及生成的 MCP JSON 里的 `{{DEBUGGER_ROOT}}`。

## Q2. 工具范围（可多选）

- [ ] static-reversing（Ghidra / PE-bear / ImHex / DIE / capa / FLOSS / YARA-X / ILSpy / dnSpyEx / ReClass.NET / radare2）
- [ ] debuggers（x64dbg / ScyllaHide / GH Injector / Cheat Engine）
- [ ] mobile-android（JADX / Apktool / MobSF / objection）
- [ ] network-http（Reqable / Wireshark）
- [ ] unpackers-game（7-Zip / UniExtract / AssetRipper / Il2CppDumper / GoReSym / pyinstxtractor-ng / UPX）
- [ ] system-forensics（Sysinternals / System Informer / Volatility 3）
- 推荐：全部。

## Q3. MCP 后端

- [ ] 仅仓库内 `debugger-router` + `mcp/bin`（默认）
- [ ] clone 全部第三方 MCP（`-CloneMcp`）
- [ ] clone 指定子集
- 未经询问不要配 YaraFlux / MobSF / VirusTotal 的 `.env`。

## Q4. 工具二进制

- [ ] 用户按 `manifests/tools.json` 官方 URL 自下
- [ ] 授权 `scripts/download-tools.ps1 -Apply`（优先 `gh`）
- 推荐：任何第三方下载前先确认。

## Q5. 版本

- [ ] `manifests/tools.json` 钉选
- [ ] 官方最新发行
- 推荐：钉选，再报告漂移。

## Q6. AI 客户端

- [ ] Claude Code（`CLAUDE.md`）
- [ ] Codex（`AGENTS.md`）
- [ ] Gemini CLI（`GEMINI.md`）
- [ ] Cursor（`.cursor/rules`）
- [ ] GitHub Copilot（`.github/copilot-instructions.md`）
- [ ] Grok

## Q7. 系统级（默认：无）

- [ ] Npcap（实时抓包；否则只能离线 pcap）
- [ ] 其它驱动 / PATH / 外壳集成
- 推荐：仅便携；Npcap 是 GUI（免费版 `/S` 属 OEM）。

## Q8. 运行时

Java（Ghidra / Apktool）、Python ≥3.10、.NET、Node — 检测后询问，不要静默安装。

答完后先写短计划，再执行。
