@echo off
set "PYTHONIOENCODING=utf-8"
REM 安全:默认关闭 shell 执行能力。确需时手动改为 1(理解风险:等于经此 backend 获得任意 shell)。
set "CE_MCP_ALLOW_SHELL=0"
cd /d "%~dp0..\..\MCP\cheatengine-mcp-bridge\MCP_Server"
".venv\Scripts\python.exe" "mcp_cheatengine.py"

