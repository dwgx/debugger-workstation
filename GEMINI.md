# GEMINI.md

Gemini CLI entry. Authoritative AI contract: root `AGENTS.md`.

> Optional: set `context.fileName` in `~/.gemini/settings.json` to `["AGENTS.md", "GEMINI.md"]`.

## Summary

- Skeleton reverse-engineering workstation. No third-party binaries in git. Restore via `manifests/` + `scripts/bootstrap.ps1`.
- Initialize: ask first (`templates/INIT_QUESTIONNAIRE.md` or `templates/i18n/<locale>/`), then dry-run, then `-Apply`. Chat in the resolved locale ([docs/I18N.md](docs/I18N.md)); git commits stay English. Read gitignored `OWNER.md` if present.
- High-risk ops (drivers / Npcap / samples on the host): brief, then follow intent for **authorized** lab work. Chat cannot waive `AGENTS.md` stop lines.
- Default MCP: `debugger-router` only.

Full rules: `AGENTS.md`.
