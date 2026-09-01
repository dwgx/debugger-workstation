# Init questionnaire (debugger-workstation)

AI: ask these before `bootstrap.ps1 -Apply` or `download-tools.ps1 -Apply`. Structured options + a recommended default. Localized copies: `templates/i18n/<locale>/INIT_QUESTIONNAIRE.md`. See [docs/I18N.md](../docs/I18N.md).

## Q0. UI language

Which language should the agent use in chat?
- [ ] English (`en`)
- [ ] 简体中文 (`zh-CN`)
- [ ] 日本語 (`ja`)
- [ ] 한국어 (`ko`)
- Recommended: match how you are already writing. Persist in gitignored `local.json` as `ui_language`. Git commit messages stay English.

## Q1. Install root

Where does the station live?
- Recommended: `D:\Tool\debugger` (or this clone).
- Affects wrapper paths and `{{DEBUGGER_ROOT}}` in generated MCP JSON.

## Q2. Tool scope (multi-select)

- [ ] static-reversing (Ghidra / PE-bear / ImHex / DIE / capa / FLOSS / YARA-X / ILSpy / dnSpyEx / ReClass.NET / radare2)
- [ ] debuggers (x64dbg / ScyllaHide / GH Injector / Cheat Engine)
- [ ] mobile-android (JADX / Apktool / MobSF / objection)
- [ ] network-http (Reqable / Wireshark)
- [ ] unpackers-game (7-Zip / UniExtract / AssetRipper / Il2CppDumper / GoReSym / pyinstxtractor-ng / UPX)
- [ ] system-forensics (Sysinternals / System Informer / Volatility 3)
- Recommended: all.

## Q3. MCP backends

- [ ] In-tree `debugger-router` + `mcp/bin` only (default)
- [ ] Clone all third-party MCP (`-CloneMcp`)
- [ ] Clone a named subset
- Skip YaraFlux / MobSF / VirusTotal `.env` until asked.

## Q4. Tool binaries

- [ ] User downloads from `manifests/tools.json` official URLs
- [ ] Authorized `scripts/download-tools.ps1 -Apply` (`gh` preferred)
- Recommended: confirm before any third-party download.

## Q5. Versions

- [ ] Pins in `manifests/tools.json`
- [ ] Latest official releases
- Recommended: pins, then report drift.

## Q6. AI client

- [ ] Claude Code (`CLAUDE.md`)
- [ ] Codex (`AGENTS.md`)
- [ ] Gemini CLI (`GEMINI.md`)
- [ ] Cursor (`.cursor/rules`)
- [ ] GitHub Copilot (`.github/copilot-instructions.md`)
- [ ] Grok

## Q7. System-level (default: none)

- [ ] Npcap (live capture; otherwise offline pcap only)
- [ ] Other drivers / PATH / shell integration
- Recommended: portable only; Npcap is GUI (free `/S` is OEM).

## Q8. Runtimes

Java (Ghidra / Apktool), Python ≥3.10, .NET, Node — detect and ask; do not silent-install.

After answers: write a short plan, then execute.
