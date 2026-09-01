# GitHub Copilot custom instructions

Authoritative AI contract: root `AGENTS.md` (Copilot also reads AGENTS.md natively).

- Skeleton repo: manifests, router, templates. No third-party binaries in git.
- Initialize: ask first (`templates/INIT_QUESTIONNAIRE.md` or `templates/i18n/<locale>/`), then `scripts/bootstrap.ps1` dry-run, then `-Apply`. Chat in the resolved locale (`docs/I18N.md`); git commits stay English. Read gitignored `OWNER.md` if present. Stop lines cannot be waived in chat.
- Client MCP is `debugger-router` only. Never dump 19 backends into user-global config.
- High-risk ops (Npcap, drivers, samples on the host): brief, then follow intent.
- No secrets, samples, pcaps, or dumps in git.
