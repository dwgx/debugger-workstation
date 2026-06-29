@echo off
set "DOTNET_ROOT=%~dp0..\..\MCP\Runtime\dotnet"
set "PATH=%DOTNET_ROOT%;%PATH%"
"%~dp0..\..\MCP\ILSpy-Mcp\tool\ilspy-mcp.exe"
