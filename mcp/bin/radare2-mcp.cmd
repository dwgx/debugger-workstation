@echo off
REM radare2 官方 MCP(r2mcp,纯 C)。由 r2pm 启动,不要直接执行 r2mcp。
REM 需先安装 radare2 并执行: r2pm -Uci r2mcp
set "PYTHONIOENCODING=utf-8"
r2pm -r r2mcp
