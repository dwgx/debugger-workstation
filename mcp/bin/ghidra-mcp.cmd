@echo off
set "PYTHONIOENCODING=utf-8"
cd /d "%~dp0..\..\MCP\GhidraMCP\ghidra-mcp"
".venv\Scripts\python.exe" "bridge_mcp_ghidra.py" --transport stdio
