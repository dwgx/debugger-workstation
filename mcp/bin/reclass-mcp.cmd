@echo off
set "PYTHONIOENCODING=utf-8"
cd /d "%~dp0..\..\MCP\ReClass.NET-MCP\ReClassMCP.Server"
".venv\Scripts\python.exe" "reclass_mcp_server.py"
