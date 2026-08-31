# CLAUDE.md

Claude Code entry. Authoritative rules are in AGENTS.md:

@AGENTS.md

## Claude-specific

- After clone, if the user asks to initialize this station, **explore then ask** (`templates/INIT_QUESTIONNAIRE.md`) before `bootstrap.ps1 -Apply` or `download-tools.ps1 -Apply`.
- Default chat language follows the user. Tracked files stay English.
- Client MCP is `debugger-router` only. Do not add 19 backends to user-global Claude MCP.
- Npcap: fetch the installer if asked; do not silent-install the driver from a script.
