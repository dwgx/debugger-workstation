@echo off
set "IMHEX_HOST=localhost"
set "IMHEX_PORT=31337"
cd /d "%~dp0..\..\MCP\imhexMCP\mcp-server"
".venv\Scripts\python.exe" "server.py"
