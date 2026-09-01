# Agent evolution (debugger-workstation)

The station must get **smarter after each job** without growing a second constitution. Chat is not memory. Jsonl is not memory.

## What stays thin

`AGENTS.md` = handshake + clone-owner overlay + MCP policy + danger.  
`OWNER.md` (gitignored) = this clone's extra prompts.  
`docs/EXPERT_PLAYBOOK.md` = how to reverse.  
`docs/WORKSTATION_RULES.md` = how to update tools.  
`skills/debugger-review/SKILL.md` = how to score a finished slice.

Do not paste session transcripts into those files.

## After-action (every material job)

```
mission → evidence → dual-axis score → findings → note? → patch skill/playbook? → TOOLS_INDEX/Reports
```

1. **Note** when a fact will still be true next week (path, Defender hit, pin, Owner ruling). Template: `templates/AFTER_ACTION.md`.
2. **Patch** when the next agent should behave differently (lazy MCP, in-place Windows bootstrap, never global `mcp-all`).
3. **Do not patch** for one-off sample names, secrets, or a failed download that you will retry the same hour.

## Self-learning rules

- Prefer a 20-line note over a 200-line SKILL.md addendum.
- If three notes say the same thing, fold them into the playbook and delete the duplicates.
- Manifest pins (`manifests/tools.json`) older than ~90 days: re-verify official releases before teaching them as current.
- New MCP/skill candidates go to `docs/extensions/INDEX.md` first, not into `mcp/.mcp.json.template` until the Owner accepts a backend.
- Four runtimes (Claude / Codex / Cursor / Grok) load **skills**, not 19 MCP processes. Skills point at this folder; MCP is `--mcp-config` / project attach.

## Windows in-place install

If `InstallRoot` is the git clone itself, `mcp\` and `MCP\` are the same directory. `bootstrap.ps1` must skip self-copy (`Test-SamePath`). Do not "fix" it by copying a file onto itself.

## Review scores (how to read them)

| Band | Meaning |
|---|---|
| 9–10 | Spec complete, smoke ran, leftover risk named |
| 7–8 | Usable; known gaps recorded |
| 5–6 | Skeleton only or missing smoke |
| ≤4 | Wrong install root, global MCP dump, or secrets in git |

Critical on either axis caps the overall score at 4.
