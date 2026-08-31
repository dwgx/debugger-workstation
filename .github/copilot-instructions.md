# GitHub Copilot custom instructions

Authoritative AI contract: root `AGENTS.md` (Copilot also reads AGENTS.md natively).

- Skeleton repo: manifests, router, templates. No third-party binaries in git.
- Initialize: ask first (`templates/INIT_QUESTIONNAIRE.md`), then `scripts/bootstrap.ps1` dry-run, then `-Apply`.
- Client MCP is `debugger-router` only. Never dump 19 backends into user-global config.
- High-risk ops (Npcap, drivers, samples on the host): brief, then follow intent.
- No secrets, samples, pcaps, or dumps in git.
