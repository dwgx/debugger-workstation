# debugger-workstation

**English** · [简体中文](README.zh-CN.md) · [日本語](README.ja.md) · [Русский](README.ru.md)

A **skeleton repository** for a portable reverse-engineering / security-analysis / debugging / unpacking / mobile-analysis / network-capture / system-inspection / MCP-automation workstation.

Any AI agent (Claude / Codex / Gemini / Cursor / Copilot) or human can clone this repo and reconstruct, on their own machine, a tooling station that is **optimized for AI to drive** — following the docs and manifests here.

> ⚠️ **This repository ships no third-party tool binaries.** Tools are fetched from each official source via `manifests/` + `scripts/bootstrap.ps1`. See [DISCLAIMER.md](DISCLAIMER.md).

---

## What's in this repo

| Path | Contents |
| --- | --- |
| `AGENTS.md` | **Authoritative entry** for all AI agents — initialization handshake (ask-then-act), MCP strategy, boundaries. |
| `CLAUDE.md` / `GEMINI.md` / `.github/copilot-instructions.md` / `.cursor/rules/` | Per-client entry files, all pointing to `AGENTS.md`. |
| `templates/INIT_QUESTIONNAIRE.md` | The clarifying-questions checklist that drives dynamic initialization. |
| `docs/` | Human- and AI-facing docs (desensitized from the original workstation rules). |
| `docs/extensions/INDEX.md` | Curated index of MCP servers / AI skills you can add. |
| `manifests/tools.json` | Tool manifest: name, version, official download source, install path. |
| `manifests/mcp-backends.json` | Third-party MCP backend upstreams + the self-developed core. |
| `mcp/debugger-router/server.py` | **Self-developed** lightweight MCP router (starts backends on demand; the only MCP enabled by default). |
| `mcp/bin/*.cmd` | **Self-developed** backend MCP wrapper scripts (relative paths, portable). |
| `mcp/.mcp.json.template` | MCP config template; bootstrap substitutes `{{DEBUGGER_ROOT}}`. |
| `scripts/bootstrap.ps1` | Reconstructs the workstation from the manifests (dry-run by default). |

**Not included** (hard-excluded by `.gitignore`): tool binaries, `.env`/credentials, `.venv`/`node_modules`/runtimes, samples/pcap/dumps, scratch workspaces, local git history.

## Quick start

```powershell
# 1. dry-run: show the plan only, no writes, no downloads
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"

# 2. once the plan looks right: deploy the self-developed MCP, generate local config, clone third-party MCPs
pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot "D:\Tool\debugger"

# 3. download tool binaries to their category folders from the official sources listed in the dry-run
#    (this repo does not download third-party tool binaries for you)

# 4. rebuild each third-party MCP's .venv / dotnet / node dependencies, then smoke-test
```

> Windows PowerShell 5.1 also works (the script is UTF-8 BOM). Prefer PowerShell 7 (`pwsh`).

## For AI agents: read this first

After cloning, **read [AGENTS.md](AGENTS.md) first** (the authoritative entry, including the initialization handshake protocol). Per-client entries — Claude→`CLAUDE.md`, Gemini→`GEMINI.md`, Cursor→`.cursor/rules/`, Copilot→`.github/copilot-instructions.md` — all point to `AGENTS.md`.

The key idea: when asked to set up the workstation, the AI **does not act immediately**. It explores (read-only), asks clarifying questions (install root, scope, which MCPs, whether to download binaries, AI client, system-level components), presents a plan, and only then — after your confirmation — runs `bootstrap.ps1`.

Further reading:
1. [AGENTS.md](AGENTS.md) — **authoritative entry**: handshake, MCP strategy, boundaries.
2. [templates/INIT_QUESTIONNAIRE.md](templates/INIT_QUESTIONNAIRE.md) — the clarifying-questions checklist.
3. [docs/AI_USAGE_GUIDE.md](docs/AI_USAGE_GUIDE.md) — reading order, what the AI may do on its own.
4. [docs/WORKSTATION_RULES.md](docs/WORKSTATION_RULES.md) — full workstation rules, update/cleanup flow.
5. [manifests/](manifests/) — tool & MCP manifests.
6. [docs/extensions/INDEX.md](docs/extensions/INDEX.md) — extensions you can add.

## MCP strategy

Only `debugger-router` — one lightweight MCP — is enabled by default. It spins up whichever of the 16 backends is needed, on demand, and exits when done. Do not load all backends at once by default. For direct connections, use a profile (`mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-all`).

## Security boundaries

The toolset includes debuggers, injectors, hooks, Frida, packet capture, and memory-analysis tools that may trigger AV/EDR. This workstation does **not** silently install drivers / services / Npcap / Defender exclusions / registry entries / startup items. High-risk samples belong in a VM/sandbox — never run unknown samples directly on the host. Intended for **authorized** security testing, CTFs, research, and education only.

> `bootstrap.ps1 -CloneMcp` clones and builds third-party MCP backends from their upstream repos (a few have no declared license). This is opt-in — review the code you clone before running it.

## License

- The self-developed parts (`mcp/debugger-router`, `mcp/bin`, `scripts`, docs) are licensed under [LICENSE](LICENSE) (MIT).
- Third-party tools and third-party MCPs remain under the copyright and license of their respective upstreams; this repo redistributes none of their code or binaries. See [DISCLAIMER.md](DISCLAIMER.md).

## Contributing & security

- Contributions welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).
- To report a security issue, see [SECURITY.md](SECURITY.md).
- Please follow our [Code of Conduct](CODE_OF_CONDUCT.md).
