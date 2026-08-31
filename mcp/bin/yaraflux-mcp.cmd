@echo off
cd /d "%~dp0..\..\MCP\YaraFlux"
if exist ".env" for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
  if not "%%A"=="" set "%%A=%%B"
)
".venv\Scripts\python.exe" "-m" "yaraflux_mcp_server.mcp_server" --transport stdio

