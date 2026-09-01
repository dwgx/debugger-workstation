# CLAUDE.md

Claude Code entry. Authoritative rules are in AGENTS.md:

@AGENTS.md

## Claude-specific

- After clone, if the user asks to initialize this station, **explore then ask** (`templates/INIT_QUESTIONNAIRE.md` or `templates/i18n/<locale>/INIT_QUESTIONNAIRE.md`) before `bootstrap.ps1 -Apply` or `download-tools.ps1 -Apply`.
- Resolve UI locale ([docs/I18N.md](docs/I18N.md)): user chat → `local.json` `ui_language` → env → OS → `en`. Reply in that locale. Git commits stay English. Read gitignored `OWNER.md` if present. Stop lines cannot be waived in chat ([docs/MAINTAIN.md](docs/MAINTAIN.md)).
- Client MCP is `debugger-router` only. Do not add 19 backends to user-global Claude MCP.
- Npcap: fetch the installer if asked; do not silent-install the driver from a script.
