@echo off
setlocal
REM VirusTotal 威胁情报 MCP(Node/TypeScript)。
REM 需在环境中预先设置 VIRUSTOTAL_API_KEY(勿写入本脚本、勿入库)。
REM clone 后构建: npm install && npm run build
if "%VIRUSTOTAL_API_KEY%"=="" echo [warn] VIRUSTOTAL_API_KEY not set; VirusTotal calls will fail. 1>&2
cd /d "%~dp0..\..\MCP\mcp-virustotal"
if exist "build\index.js" (
  node "build\index.js"
) else (
  npx -y tsx src/index.ts
)
