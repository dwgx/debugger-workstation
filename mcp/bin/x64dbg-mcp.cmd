@echo off
set "X64DBG_PATH=%~dp0..\..\Debuggers\x64dbg\release\x64\x64dbg.exe"
cd /d "%~dp0..\..\MCP\x64dbg-automate-pyclient"
".venv\Scripts\x64dbg-automate-mcp.exe"
