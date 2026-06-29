@echo off
set "PYTHONIOENCODING=utf-8"
set "PATH=%~dp0..\..\Network-HTTP\Wireshark;%PATH%"
cd /d "%~dp0..\..\MCP\mcp-wireshark"
".venv\Scripts\mcp-wireshark.exe"
