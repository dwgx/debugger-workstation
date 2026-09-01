# Disclaimer

<!-- I18N:START -->
**English** · [简体中文](DISCLAIMER.zh-CN.md) · [日本語](DISCLAIMER.ja.md) · [한국어](DISCLAIMER.ko.md)
<!-- I18N:END -->

## Third-party tools

**debugger-workstation** is a **skeleton / bootstrap**. It does **not** contain, distribute, or re-publish source or binaries of third-party reverse-engineering, debugging, or security tools, including but not limited to:

Ghidra, IDA Pro, radare2, x64dbg, ImHex, Detect It Easy, capa, FLOSS, YARA-X, ILSpy, dnSpy/dnSpyEx, ReClass.NET, ScyllaHide, Cheat Engine, JADX, Apktool, MobSF, objection, Reqable, Wireshark, 7-Zip, Universal Extractor, AssetRipper, Il2CppDumper, GoReSym, pyinstxtractor-ng, Volatility 3, Sysinternals, System Informer.

**IDA Pro is Hex-Rays commercial software.** You buy a license and install it yourself. This repo does not ship IDA and does not circumvent its licensing.

Copyright, trademarks, and licenses stay with each vendor. This repo only records names, versions, and **official download URLs** in `manifests/tools.json`. You fetch tools via `scripts/bootstrap.ps1` / `scripts/download-tools.ps1` or by hand.

## Third-party MCP servers

Backends listed in `manifests/mcp-backends.json` are **not** in this git tree. Bootstrap only `git clone`s upstream URLs. **VirusTotal MCP** sends IOCs (hashes, URLs, IPs, domains) to VirusTotal's public API and needs your `VIRUSTOTAL_API_KEY`. Use it only on authorized investigations; do not upload sensitive samples.

## In-tree work

Shipped here: `mcp/debugger-router/`, `mcp/bin/*.cmd`, MCP templates, `scripts/`, `docs/`, `manifests/`. License: [LICENSE](LICENSE).

## Your responsibility

- Intended for **authorized** security testing, CTF, research, defensive analysis, and education.
- The set includes debuggers, injectors, hooks, capture, and memory tools. AV/EDR may fire. Some EULAs forbid reversing. **You** must keep your use lawful and authorized.
- Do not use this for unauthorized intrusion, breaking commercial copy protection, bypassing anti-cheat, or attacking systems you do not own.
- Do not run unknown / malware samples on the host; use an isolated VM.

The authors are not liable for consequences of using this repo or tools obtained from the official links it cites.
