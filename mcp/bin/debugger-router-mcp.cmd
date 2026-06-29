@echo off
set "PYTHONUTF8=1"
set "PYTHONIOENCODING=utf-8"
set "FASTMCP_SHOW_SERVER_BANNER=false"
set "FASTMCP_CHECK_FOR_UPDATES=off"
set "FASTMCP_ENABLE_RICH_LOGGING=false"
cd /d "%~dp0..\..\MCP\debugger-router"
REM 优先用 frida-mcp 的 venv(已装 fastmcp);缺失时回退到独立 venv,再回退系统 python。
set "ROUTER_PY=%~dp0..\..\MCP\frida-mcp\.venv\Scripts\python.exe"
if not exist "%ROUTER_PY%" set "ROUTER_PY=%~dp0..\..\MCP\debugger-router\.venv\Scripts\python.exe"
if not exist "%ROUTER_PY%" set "ROUTER_PY=python"
"%ROUTER_PY%" "server.py"

