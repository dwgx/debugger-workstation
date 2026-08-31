@echo off
set "PYTHONIOENCODING=utf-8"
cd /d "%~dp0..\..\MCP\volatility3-mcp"
".venv\Scripts\python.exe" "bridge_mcp_volatility.py"
