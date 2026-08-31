---
tags: [bootstrap, windows, defender]
status: verified
source: WorkStation init 2026-09-01
---

# Windows in-place bootstrap + capa PUA

- `InstallRoot` = git clone on NTFS: `mcp\` and `MCP\` are the same folder. `Copy-Item` onto self throws. `bootstrap.ps1` now skips via `Test-SamePath`.
- First bootstrap attempt also died on PowerShell 5.1 `?.` (caller script, not upstream). Use `powershell -File scripts\bootstrap.ps1`.
- `capa-v9.4.0-windows.zip` extract blocked by Microsoft Defender PUA. FLOSS/Ghidra/x64dbg were fine. Next agent: Defender exclusion only with Owner confirm, or fetch capa to a VM.
- Router `.venv` on CPython 3.14 imported `mcp`. Backends still lazy (no mass pip/dotnet).
- Do not merge 19 backends into four-runtime user MCP.
