# AGENTS.md — debugger-workstation

Authoritative entry for every AI agent (Claude Code, Codex, Cursor, Gemini CLI, Copilot, Grok).
Read this file before initializing or driving the station.

This repository is a **skeleton**. It ships no third-party tool binaries.

<!-- I18N:START -->
**English** · [简体中文](AGENTS.zh-CN.md) · [日本語](AGENTS.ja.md) · [한국어](AGENTS.ko.md)
<!-- I18N:END -->

Read [docs/I18N.md](docs/I18N.md). Chat in the user's language. Git commits stay English.

---

## 0. What this is

A portable reverse-engineering / security-analysis / debugging / unpacking / mobile / capture / forensics / MCP workstation.

- Tools come from official sources via `manifests/` + `scripts/bootstrap.ps1` / `scripts/download-tools.ps1`.
- This repo ships: the in-tree MCP router (`mcp/debugger-router`), wrapper scripts (`mcp/bin`), templates, manifests, and docs.
- See `README.md` and `DISCLAIMER.md`.

---

## 1. Init handshake (ask, then act)

When the user asks to initialize / install / set up this station:

### Step 1 — Explore (read-only)

Read `README.md`, this file, `manifests/tools.json`, `manifests/mcp-backends.json`, `docs/AI_USAGE_GUIDE.md`. Detect OS, `git`, `python` (≥3.10), `pwsh`/`powershell`, `dotnet`, `node`, `java`.

### Step 2 — Ask (required)

Use `templates/INIT_QUESTIONNAIRE.md` (or `templates/i18n/<locale>/INIT_QUESTIONNAIRE.md`). Cover at least:

0. **UI language** (en / zh-CN / ja / ko) if not already obvious from chat.
1. **Install root** (default: `D:\Tool\debugger`).
2. **Scope**: all categories, or a subset.
3. **MCP backends**: router-only, or `-CloneMcp` for third-party servers (skip `.env` services until asked).
4. **Binaries**: user downloads vs authorized `download-tools.ps1 -Apply`.
5. **Versions**: pin in `manifests/tools.json` vs latest official.
6. **AI client**: Claude Code / Codex / Cursor / Gemini / Copilot / Grok.
7. **System-level**: Npcap / drivers (default: no).

### Step 3 — Plan

List directories, clones, downloads, and generated config. Wait for confirmation.

### Step 4 — Execute (after confirmation)

1. `pwsh scripts/bootstrap.ps1 -InstallRoot "<root>"` (dry-run).
2. `-Apply` (router + local MCP JSON).
3. Optional `-CloneMcp`.
4. `powershell -File scripts/download-tools.ps1 -Apply` when authorized.
5. Do **not** build all 19 backend environments on first bootstrap. The router starts a backend on demand.
6. Smoke: `capa.exe --version`, `7z.exe`, `jadx.bat --version` as available. If Defender blocks capa, write `notes/` — do not pretend it is installed.
7. Finish with `skills/debugger-review`.

On Windows, if `InstallRoot` is this clone, `mcp\` and `MCP\` are the same folder. `bootstrap.ps1` must skip self-copy.

### Step 5 — Report

What landed, what was skipped, leftover risk.

---

## 2. MCP policy

- Default client MCP: **only** `debugger-router`. It starts one of 19 backends on demand and exits.
- Do not load every backend by default. Direct profiles: `mcp-mobile` / `mcp-re` / `mcp-net` / `mcp-ce` / `mcp-intel` / `mcp-all`.
- Templates: `mcp/.mcp.json.template`, `mcp/codex-mcp-config.example.toml` (`{{DEBUGGER_ROOT}}`).
- Never put the 19 backends into Claude / Codex / Cursor / Grok **user-global** MCP.
- Upstream list: `manifests/mcp-backends.json`.
- If the host already has an IDA MCP (idalib), do not add a second IDA server.

---

## 3. Commands

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
python -c "import json,glob;[json.load(open(f,encoding='utf-8')) for f in glob.glob('manifests/*.json')]"
```

Post-bootstrap smokes (paths relative to install root):

```
Static-Reversing\capa\capa.exe --version
Static-Reversing\YARA-X\yr.exe --version
Unpackers-Game\7-Zip-full\7z.exe
Mobile-Android\jadx\bin\jadx.bat --version
```

Optional private zip cache (not required for public clones): `scripts/restore-from-cache.ps1`.

---

## 4. High-risk ops

Brief consequences and rollback, then follow intent. Do not refuse and do not silent-install drivers.

- Drivers, services, Npcap, Defender exclusions, registry, startup, scheduled tasks.
- Running untrusted samples on the host (offer a VM; the user decides).
- Downloading third-party binaries, cloning many repos, writing outside the install root.

Repo rules:

- No third-party binaries in git. Official sources only (`DISCLAIMER.md`).
- No `.env`, API keys, pcaps, dumps, APKs, Cheat Engine tables in git.
- Authorized security testing, CTF, research, and education only.

---

## 5. Layout

```
AGENTS.md / CLAUDE.md       this contract
README.md / DISCLAIMER.md / LICENSE
docs/                       rules, playbook, tool index, evolution
skills/                     debugger-workstation + debugger-review
notes/                      durable facts (no samples, no secrets)
manifests/                  tools.json + mcp-backends.json
mcp/                        debugger-router + bin wrappers + templates
scripts/                    bootstrap.ps1, download-tools.ps1
templates/                  init questionnaire + after-action
```

---

## 6. After every material job

Read `docs/AGENT_EVOLUTION.md` and `skills/debugger-review/SKILL.md`. Notes go in `notes/`. Local scores may go in `Reports/` (gitignored). Chat and jsonl are not memory.

---

## 7. Language

1. Resolve locale: user chat → `local.json` `ui_language` → `WORKSTATION_UI_LANG` → OS UI culture → `en`.
2. Read `AGENTS.<locale>.md` when it exists (this file is English). Use `templates/i18n/<locale>/INIT_QUESTIONNAIRE.md`.
3. **Reply in that locale.** Persist `ui_language` in gitignored `local.json`.
4. Public git history and commit messages stay **English**.

Supported: `en`, `zh-CN`, `ja`, `ko`. Paths: absolute, or relative to the install root.
