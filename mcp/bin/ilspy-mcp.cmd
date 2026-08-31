@echo off
REM ILSpy MCP - .NET 9 dotnet tool. Upstream ships no prebuilt exe.
REM Build after clone (see docs/TOOLS_INDEX.md): dotnet publish -c Release -o publish
REM Produces publish\ILSpy.Mcp.exe; dotnet pack + tool install produces publish\ilspy-mcp.exe.
set "DOTNET_ROOT=%~dp0..\..\MCP\Runtime\dotnet"
set "PATH=%DOTNET_ROOT%;%PATH%"
if exist "%~dp0..\..\MCP\ILSpy-Mcp\publish\ILSpy.Mcp.exe" (
  "%~dp0..\..\MCP\ILSpy-Mcp\publish\ILSpy.Mcp.exe"
) else (
  "%~dp0..\..\MCP\ILSpy-Mcp\publish\ilspy-mcp.exe"
)
