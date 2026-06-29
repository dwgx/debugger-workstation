@echo off
cd /d "%~dp0..\..\MCP\YaraFlux"
if exist ".env" for /f "usebackq eol=# tokens=1,* delims==" %%A in (".env") do (
  if not "%%A"=="" set "%%A=%%B"
)
".venv\Scripts\yaraflux-mcp-server.exe" run --host 127.0.0.1 --port 8000

