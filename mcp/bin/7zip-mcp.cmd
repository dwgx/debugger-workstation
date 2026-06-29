@echo off
set "PYTHONIOENCODING=utf-8"
cd /d "%~dp0..\..\MCP\mcp7zop"
".venv\Scripts\python.exe" -m mcp7zop --mcp-server
