@echo off
set "PYTHONIOENCODING=utf-8"
set "REQABLE_DATA_DIR=%~dp0..\..\MCP\workspaces\reqable"
cd /d "%~dp0..\..\MCP\reqable-mcp"
".venv\Scripts\python.exe" -m reqable_mcp
