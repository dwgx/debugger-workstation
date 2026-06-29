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
3. **Don't add silent system-level actions.** Scripts must not install drivers, services, Npcap, Defender exclusions, registry keys, or startup items without explicit, documented opt-in.
   **不要加无声的系统级动作。** 脚本不得在无明确、有文档的 opt-in 下安装驱动、服务、Npcap、Defender 例外、注册表项或启动项。
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

- Keep the four README languages (`README.md` EN, `README.zh-CN.md`, `README.ja.md`, `README.ru.md`) in sync when changing user-facing content. The English `README.md` is canonical.
  改动面向用户的内容时,请同步四个语言版本的 README,以英文 `README.md` 为准。
- Internal docs (`AGENTS.md`, `docs/`) are maintained in Chinese.
  内部文档(`AGENTS.md`、`docs/`)以中文维护。

## Commit & PR style / 提交与 PR 规范

- Keep PR titles concise (under ~70 chars). Put detail in the description: what changed, what you tested.
  PR 标题简洁(~70 字符内),细节写在描述里:改了什么、测了什么。
- One logical change per PR where possible.
  尽量一个 PR 只做一件事。

## Reporting issues / 报告问题

Use the issue templates. For security-sensitive reports, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.
请用 issue 模板。安全敏感问题请按 [SECURITY.md](SECURITY.md) 处理,不要开公开 issue。
