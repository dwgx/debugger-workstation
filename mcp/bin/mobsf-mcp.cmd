@echo off
setlocal
cd /d "%~dp0..\..\MCP\mobsf-mcp-server"
if exist "node_modules\.bin\tsx.cmd" (
  call "node_modules\.bin\tsx.cmd" server.ts
) else (
  npx tsx server.ts
)