# AI usage guide

<!-- I18N:START -->
**English** · [简体中文](i18n/zh-CN/AI_USAGE_GUIDE.md) · [日本語](i18n/ja/AI_USAGE_GUIDE.md) · [한국어](i18n/ko/AI_USAGE_GUIDE.md)
<!-- I18N:END -->

After clone, agents read **[`AGENTS.md`](../AGENTS.md)** first (handshake + MCP policy).

This file is the post-bootstrap reading order. Directories such as `Reports\`, `OriginalBase\`, and backend `tests\` are created on the install machine; they are not in the skeleton git.

## Read in this order

1. `AGENTS.md` — handshake, lazy MCP, high-risk ops.
2. `templates/INIT_QUESTIONNAIRE.md` — if the user asked to install.
3. `docs/WORKSTATION_RULES.md` — update / cleanup / distribution (Chinese operational rules; install-root relative).
4. `docs/TOOLS_INDEX.md` — per-tool commands after binaries exist.
5. `docs/EXPERT_PLAYBOOK.md` — sample triage playbook (Chinese).
6. `docs/SMARTCLI.md` — CLI tools in SmartCLI; GUIs via router.
7. `docs/AGENT_EVOLUTION.md` — after-action notes.

MCP templates: `mcp/.mcp.json.template`. Generated local JSON is gitignored.

## Default MCP

Only `debugger-router`. Catalog JSON is for the router. Never `mcp-all` in user-global client config.

## Commands

```powershell
pwsh scripts\bootstrap.ps1 -InstallRoot "D:\Tool\debugger"
powershell -File scripts\download-tools.ps1 -Apply
```

Npcap installer may be fetched; do not silent-install. Cheat Engine is clickwrap on cheatengine.org.

## What the AI may do on its own

- Read docs, manifests, notes.
- Dry-run bootstrap.
- Dual-axis review after a job (`skills/debugger-review`).

## What needs confirmation

- `-Apply`, `-CloneMcp`, `download-tools.ps1 -Apply`.
- Drivers, Defender exclusions, samples on the host.

## Leftover risk

capa zip may be blocked as PUA. IDA Pro is user-supplied. Do not commit `.env` or samples.
