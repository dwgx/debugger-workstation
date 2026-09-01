# Bootstrap layout

<!-- I18N:START -->
**English** · this file stays English (like `docs/EVAL.md`)
<!-- I18N:END -->

How `-Apply` turns this skeleton into a station. Dry-run is the default.

## Two MCP files (debugger)

| File | Who reads it | Contents |
|---|---|---|
| `MCP/.mcp.json` | `debugger-router` (`server.py`) | Full backend inventory (router + 19 wrappers). |
| `.mcp.json` and `.cursor/mcp.json` | Claude Code / Cursor **project** MCP | **Only** `debugger-router`. Template: `mcp/client-mcp.json.template`. |

Never copy the 19-backend file into a client or into user-global MCP. Codex example: `mcp/codex-mcp-config.example.toml` (router enabled, backends off).

## VRC DCC

`-Apply` writes the same rendered JSON to `mcp/local.mcp.json` (for `--mcp-config`), `.mcp.json`, and `.cursor/mcp.json`. Still never user-global.

## InstallRoot ≠ clone

Bootstrap copies `manifests/`, `skills/`, `docs/`, `scripts/`, templates, and root contract files so an agent opening `D:\Tool\debugger` can still handshake. Self-copy is skipped when paths are the same folder.

## `local.json`

Always gitignored. `-Apply` writes `install_root`. `ui_language` is written only with `-UiLanguage` or `WORKSTATION_UI_LANG` / `DEBUGGER_UI_LANG` / `VRC_DCC_UI_LANG`, so an English Windows UI cannot lock out a Chinese chat. `download-tools.ps1` reads `install_root` when `-InstallRoot` is omitted.
