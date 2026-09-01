---
name: debugger-review
description: >-
  Dual-axis review and after-action learning for reverse-engineering jobs.
  Auto-apply when finishing unpack/RE/bootstrap/tool-download work, or when
  the user says debugger review / 评分 / 进化 / 收尾. Writes Reports/ and notes/.
---

# debugger-review

Read `AGENTS.md` then `docs/AGENT_EVOLUTION.md`. This skill is **review + memory**, not a second constitution.

## Axes (always both)

**Standard:** correctness, security, style, no drive-by. Security defaults to guilty until a negative check exists (did not run the sample on the host, did not merge 19 MCP backends into user-global config, did not commit `.env` / dumps).

**Spec:** the clone owner's asked slice is present; extra scope is a finding. Tests/smoke that were named were actually run.

## Loop

1. Restate the mission in one sentence (install / unpack / triage / MCP / docs).
2. List evidence with path + command + exit. Do not upgrade to `verified` without current reconciliation.
3. Score 0–10 on each axis. Overall = min(standard, spec) if either has a **critical**; else weighted mean (spec 0.55, standard 0.45).
4. Findings first, ranked. Critical blocks "done".
5. **Evolve:** if the next agent would repeat a mistake, append `notes/YYYY-MM-DD-slug.md` and link `notes/INDEX.md`. If it is a standing rule, patch `docs/EXPERT_PLAYBOOK.md` or this skill — not chat.
6. Refresh `docs/TOOLS_INDEX.md` or `Reports/` when tools/MCP changed (`WORKSTATION_RULES.md` update flow).

## MCP

Clients attach **debugger-router only**. Catalog `mcp/.mcp.json` is for the router. Never `mcp-all` in Claude / Codex / Cursor / Grok **user** config. If a host already has an IDA MCP (idalib), do not add a second IDA server.

## Outputs

- `Reports/<date>-review.md` — scores, findings, leftover risk (local; not for git).
- `notes/` — durable facts (Defender PUA, missing binary, pin drift).
- Chat — resolved locale to the clone owner; one paragraph of scores then findings.
