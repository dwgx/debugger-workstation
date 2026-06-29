# Security Policy / 安全策略

## Scope / 范围

This repository contains only self-developed code (the MCP router, wrapper scripts, bootstrap, manifests, docs). It ships **no third-party tool binaries**. Vulnerabilities in the third-party tools or third-party MCP servers listed in the manifests should be reported to their respective upstreams, not here.

本仓库只含自研代码(MCP 路由、包装脚本、bootstrap、清单、文档),**不分发任何第三方工具二进制**。清单中列出的第三方工具或第三方 MCP server 的漏洞,请向其各自上游报告,而非本仓库。

In scope for this repo / 本仓库范围内:
- `scripts/bootstrap.ps1` — e.g. command/argument injection, path traversal, writing outside the install root, silent privilege escalation.
- `mcp/debugger-router/server.py` and `mcp/bin/*.cmd` — e.g. unintended command execution, credential leakage.
- Manifest entries pointing at typosquatted or malicious upstreams.

## Reporting / 报告方式

**Please do not open a public issue for security problems.**
**安全问题请勿开公开 issue。**

Use **GitHub Private Vulnerability Reporting** (the repo's *Security* tab → *Report a vulnerability*). If that is unavailable, contact the maintainers privately through the channel listed on the repository profile.

请使用 **GitHub 私密漏洞报告**(仓库 *Security* 标签页 → *Report a vulnerability*)。若不可用,请通过仓库主页列出的渠道私下联系维护者。

Please include / 请包含:
- A description of the issue and its impact / 问题描述与影响。
- Steps to reproduce (a minimal manifest or command line helps) / 复现步骤(最小 manifest 或命令行最佳)。
- The commit / version you tested against / 你测试的 commit 或版本。

## Response / 响应

We aim to acknowledge reports within a few days and to coordinate a fix and disclosure timeline with you. There is no bug-bounty program for this project.

我们会尽量在数日内确认报告,并与你协调修复与披露时间。本项目无漏洞赏金计划。

## Responsible use / 负责任使用

This workstation aggregates debuggers, injectors, hooks, packet capture, and memory-analysis tooling. It is intended for **authorized** security testing, CTFs, research, and education. Misuse — unauthorized intrusion, circumventing copyright protection or anti-cheat, attacking systems you do not own — is out of scope and unsupported. See [DISCLAIMER.md](DISCLAIMER.md).

本工作站聚合了调试器、注入器、Hook、抓包与内存分析工具,仅面向**授权的**安全测试、CTF、研究与教育。滥用(未授权入侵、绕过版权保护或反作弊、攻击非自有系统)不在支持范围内。见 [DISCLAIMER.md](DISCLAIMER.md)。
