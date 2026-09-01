# Contributing / 贡献指南

Thanks for your interest in improving **debugger-workstation**.
感谢你帮助改进 **debugger-workstation**。

This repo is a *skeleton / bootstrap* repo — it carries manifests, the self-developed MCP router, wrapper scripts, and docs. It deliberately ships **no third-party tool binaries**. Keep that boundary intact in every contribution.
本仓库是*骨架 / bootstrap* 仓库——只包含清单、自研 MCP 路由、包装脚本和文档,刻意**不分发任何第三方工具二进制**。每次贡献都请守住这条边界。

---

## Ground rules / 基本规则

1. **Never commit binaries, credentials, or samples.** No `.env`, API keys, tokens, `.exe`/`.zip` tool binaries, pcap/dump/APK, or anything matched by `.gitignore`.
   **绝不提交二进制、凭据或样本。** 不要 `.env`、API key、token、工具二进制、pcap/dump/APK 或任何被 `.gitignore` 命中的内容。
2. **Manifests must stay verifiable.** When adding/changing a tool or MCP entry, link the official source and note when you verified it. Do not guess URLs or versions.
   **清单必须可核验。** 增改工具/MCP 条目时,附官方源链接并注明核验日期,不要臆造 URL 或版本。
3. **System-level actions need clear opt-in.** Scripts that install drivers, services, Npcap, Defender exclusions, registry keys, or startup items should document the opt-in path and brief the user before executing. Do not silent-act. Chat cannot waive `AGENTS.md` stop lines.
   **系统级动作需要明确的 opt-in。** 安装驱动、服务、Npcap、Defender 例外、注册表项或启动项的脚本应提供文档化的 opt-in 路径，执行前说明。不要无声执行。聊天不能取消 `AGENTS.md` 红线。
4. **Keep `bootstrap.ps1` dry-run-safe.** A run without `-Apply` must never write, download, or clone.
   **保持 `bootstrap.ps1` 的 dry-run 安全。** 不带 `-Apply` 时绝不写盘、下载或 clone。

## Before opening a PR / 提 PR 前

Run the local checks (same as CI / 与 CI 相同):

```bash
# Validate all manifest JSON
python -c "import json,glob;[json.load(open(f,encoding='utf-8')) for f in glob.glob('manifests/*.json')]"

# Syntax-check the PowerShell bootstrap (on Windows)
powershell -NoProfile -Command "[System.Management.Automation.PSParser]::Tokenize((Get-Content -Raw scripts/bootstrap.ps1),[ref]$null)"

# Compile-check the router
python -m py_compile mcp/debugger-router/server.py
```

3. English `README.md` is canonical. Keep `README.zh-CN.md`, `README.ja.md`, and `README.ko.md` in sync for user-facing changes. Same for `AGENTS.*` / `DISCLAIMER.*` siblings listed in `locales.json`.
   面向用户的正文以英文 `README.md` 为准，并同步简中 / 日 / 韩 README。`locales.json` 列出的 `AGENTS.*` / `DISCLAIMER.*` 同样保持同步。
- Contract files: English is canonical; localized siblings live next to them. Chinese operational cheat-sheets may remain under `docs/TOOLS_INDEX.md` / `docs/EXPERT_PLAYBOOK.md`.
  合同以英文为正文，旁边放译文。`docs/TOOLS_INDEX.md` / `docs/EXPERT_PLAYBOOK.md` 可以是中文实战速查。
- See `docs/I18N.md` before adding a language. Clone-owner prompts live in gitignored `OWNER.md` (`OWNER.example.md`). Agents may patch **this clone** when the owner asks (`docs/MAINTAIN.md`); chat cannot waive stop lines.

## Commit & PR style / 提交与 PR 规范

- Keep PR titles concise (under ~70 chars). Put detail in the description: what changed, what you tested.
  PR 标题简洁(~70 字符内),细节写在描述里:改了什么、测了什么。
- One logical change per PR where possible.
  尽量一个 PR 只做一件事。

## Reporting issues / 报告问题

Use the issue templates. For security-sensitive reports, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.
请用 issue 模板。安全敏感问题请按 [SECURITY.md](SECURITY.md) 处理,不要开公开 issue。
