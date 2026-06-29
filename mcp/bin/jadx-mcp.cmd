@echo off
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
set "FASTMCP_SHOW_SERVER_BANNER=false"
set "FASTMCP_CHECK_FOR_UPDATES=off"
set "FASTMCP_ENABLE_RICH_LOGGING=false"
cd /d "%~dp0..\..\MCP\jadx-mcp-server"
".venv\Scripts\python.exe" "jadx_mcp_server.py"
