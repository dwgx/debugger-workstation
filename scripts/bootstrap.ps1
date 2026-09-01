<#
.SYNOPSIS
    debugger-workstation bootstrap.
    按 manifests/ 在目标机器上还原便携逆向/安全分析工作站。

.DESCRIPTION
    本仓库不含第三方工具二进制。此脚本:
      1. 读取 manifests/tools.json,列出各工具官方下载源(默认只展示,不自动下载)。
      2. 读取 manifests/mcp-backends.json,clone 第三方 MCP 上游到 MCP/ 下。
      3. 从 mcp/.mcp.json.template 生成本机 MCP/.mcp.json(替换 {{DEBUGGER_ROOT}})。
      4. 复制自研 router/bin 到 MCP/。

    默认 -DryRun:只打印计划动作,不写盘、不下载、不联网 clone。
    确认无误后用 -Apply 真正执行。

.PARAMETER InstallRoot
    工作站根目录,默认 D:\Tool\debugger。

.PARAMETER Apply
    真正执行(clone / 生成配置 / 复制)。不加则为 dry-run。

.PARAMETER CloneMcp
    执行第三方 MCP clone(需要 git 和网络)。

.PARAMETER SkipTools
    跳过工具下载源提示。

.PARAMETER SkipRouterVenv
    不为 debugger-router 建 .venv（CI / 布局测试）。

.PARAMETER UiLanguage
    写入 local.json 的 ui_language（en / zh-CN / ja / ko）。不传则不把 OS 猜测写入。

.NOTES
    工具二进制需用户按官方源手工下载或经明确授权后由 AI 联网核验下载,
    本脚本默认不自动抓取第三方工具二进制(版权 + 体积),但用户要求时可配合执行。
    系统级变更(服务/驱动/注册表/Defender/Npcap)由用户确认后按意图执行。
#>

[CmdletBinding()]
param(
    [string]$InstallRoot = "D:\Tool\debugger",
    [switch]$Apply,
    [switch]$CloneMcp,
    [switch]$SkipTools,
    [switch]$SkipRouterVenv,
    [string]$UiLanguage = ''
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$Mode = if ($Apply) { "APPLY" } else { "DRY-RUN" }

. (Join-Path $PSScriptRoot 'resolve-locale.ps1')
$localeProbe = $RepoRoot
if (Test-Path -LiteralPath (Join-Path $InstallRoot 'local.json')) {
    $localeProbe = $InstallRoot
}
$uiLocale = Get-WorkstationLocale -RepoRoot $localeProbe -Hint $UiLanguage

function Write-Step($msg) { Write-Host "[$Mode] $msg" -ForegroundColor Cyan }
function Write-Plan($msg) { Write-Host "        -> $msg" -ForegroundColor DarkGray }
function Write-Warn2($msg) { Write-Host "[WARN] $msg" -ForegroundColor Yellow }

# 写 UTF-8 无 BOM 文件。PS5.1 的 Set-Content -Encoding UTF8 会写 BOM,
# 而 .mcp.json 被 server.py 以 utf-8 读取,BOM 会导致 json.loads 报错。
function Write-Utf8NoBom($path, $text) {
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($path, $text, $enc)
}

Write-Host "==================================================" -ForegroundColor Green
Write-Host " debugger-workstation bootstrap  ($Mode)" -ForegroundColor Green
Write-Host " RepoRoot    : $RepoRoot"
Write-Host " InstallRoot : $InstallRoot"
Write-Host "==================================================" -ForegroundColor Green
Write-LocaleBanner -RepoRoot $RepoRoot -Locale $uiLocale
if (-not $Apply) {
    Write-Warn2 "当前是 DRY-RUN,只展示计划,不写盘/不下载。确认后加 -Apply 执行。"
}

# --- 0. 前置检查 ---
Write-Step "检查前置工具"
$haveGit = [bool](Get-Command git -ErrorAction SilentlyContinue)
$havePy  = [bool](Get-Command python -ErrorAction SilentlyContinue)
Write-Plan "git:    $haveGit"
Write-Plan "python: $havePy"

$mcpRoot = Join-Path $InstallRoot "MCP"

function Test-SamePath($a, $b) {
    if (-not (Test-Path -LiteralPath $a)) { return $false }
    if (-not (Test-Path -LiteralPath $b)) { return $false }
    return ((Resolve-Path -LiteralPath $a).Path -eq (Resolve-Path -LiteralPath $b).Path)
}

# --- 1. 自研核心复制 (router + bin + 模板) ---
Write-Step "部署自研 MCP 核心 (router / bin / 配置模板)"
$selfMap = @(
    @{ src = "mcp\debugger-router\server.py"; dst = "MCP\debugger-router\server.py" },
    @{ src = "mcp\debugger-router\requirements.txt"; dst = "MCP\debugger-router\requirements.txt" }
)
foreach ($m in $selfMap) {
    $src = Join-Path $RepoRoot $m.src
    $dst = Join-Path $InstallRoot $m.dst
    if (Test-SamePath $src $dst) { Write-Plan "[skip self-copy] $($m.src)"; continue }
    Write-Plan "copy $($m.src) -> $dst"
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
        Copy-Item $src $dst -Force
    }
}
# bin 脚本整目录
$binSrc = Join-Path $RepoRoot "mcp\bin"
$binDst = Join-Path $mcpRoot "bin"
if (Test-SamePath $binSrc $binDst) {
    Write-Plan "[skip self-copy] mcp\bin"
} else {
    Write-Plan "copy mcp\bin\*.cmd -> $binDst"
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path $binDst | Out-Null
        Copy-Item (Join-Path $binSrc "*.cmd") $binDst -Force
    }
}

function Copy-RelTree([string]$Rel) {
    $src = Join-Path $RepoRoot $Rel
    $dst = Join-Path $InstallRoot $Rel
    if (-not (Test-Path -LiteralPath $src)) { return }
    if (Test-SamePath $src $dst) { Write-Plan "[skip self-copy] $Rel"; return }
    Write-Plan "copy $Rel -> $dst"
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path $dst | Out-Null
        Get-ChildItem -LiteralPath $src -Force | Where-Object {
            $_.Name -notin @('__pycache__', '.venv', '.git')
        } | ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dst $_.Name) -Recurse -Force
        }
    }
}

function Copy-RelFile([string]$Rel) {
    $src = Join-Path $RepoRoot $Rel
    $dst = Join-Path $InstallRoot $Rel
    if (-not (Test-Path -LiteralPath $src)) { return }
    if (Test-SamePath $src $dst) { Write-Plan "[skip self-copy] $Rel"; return }
    Write-Plan "copy $Rel -> $dst"
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
        Copy-Item -LiteralPath $src -Destination $dst -Force
    }
}

# AI 入口 + 合同 + 手册：安装根必须能独立被 agent 打开
Write-Step "部署骨架文件 (合同 / docs / skills / manifests / scripts)"
$rootFiles = @(
    'AGENTS.md', 'AGENTS.zh-CN.md', 'AGENTS.ja.md', 'AGENTS.ko.md',
    'README.md', 'README.zh-CN.md', 'README.ja.md', 'README.ko.md',
    'DISCLAIMER.md', 'DISCLAIMER.zh-CN.md', 'DISCLAIMER.ja.md', 'DISCLAIMER.ko.md',
    'CLAUDE.md', 'GEMINI.md', 'CONTRIBUTING.md', 'OWNER.example.md',
    'locales.json', 'local.json.example'
)
foreach ($f in $rootFiles) { Copy-RelFile $f }
Copy-RelFile '.github\copilot-instructions.md'
Copy-RelFile '.cursor\rules\debugger-workstation.mdc'
Copy-RelFile 'mcp\.mcp.json.template'
Copy-RelFile 'mcp\client-mcp.json.template'
Copy-RelFile 'mcp\codex-mcp-config.example.toml'
foreach ($tree in @('manifests', 'skills', 'docs', 'scripts', 'templates')) {
    Copy-RelTree $tree
}

# --- 2. 生成本机 .mcp.json ---
Write-Step "生成本机 MCP\.mcp.json (替换 {{DEBUGGER_ROOT}})"
$tplPath = Join-Path $RepoRoot "mcp\.mcp.json.template"
$cfgDst  = Join-Path $mcpRoot ".mcp.json"
$escaped = $InstallRoot.Replace('\', '\\')
Write-Plan "template -> $cfgDst  (DEBUGGER_ROOT=$escaped)"
if ($Apply) {
    $content = Get-Content $tplPath -Raw -Encoding UTF8
    $content = $content.Replace('{{DEBUGGER_ROOT}}', $escaped)
    New-Item -ItemType Directory -Force -Path $mcpRoot | Out-Null
    Write-Utf8NoBom $cfgDst $content
    Write-Plan "已写入 $cfgDst (router inventory)"
}

# Client MCP: router only. Cursor + Claude Code discover these paths.
Write-Step "写入项目 MCP (.mcp.json / .cursor\mcp.json) — 仅 debugger-router"
$clientTpl = Join-Path $RepoRoot "mcp\client-mcp.json.template"
$clientText = $null
if (Test-Path -LiteralPath $clientTpl) {
    $clientText = (Get-Content $clientTpl -Raw -Encoding UTF8).Replace('{{DEBUGGER_ROOT}}', $escaped)
} else {
    Write-Warn2 "缺少 mcp\client-mcp.json.template"
}
$clientTargets = @(
    (Join-Path $InstallRoot '.mcp.json'),
    (Join-Path $InstallRoot '.cursor\mcp.json')
)
foreach ($cpath in $clientTargets) {
    Write-Plan "client MCP -> $cpath"
    if ($Apply -and $clientText) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $cpath) | Out-Null
        Write-Utf8NoBom $cpath $clientText
    }
}
# codex toml 模板同样替换
$tomlTpl = Join-Path $RepoRoot "mcp\codex-mcp-config.example.toml"
if (Test-Path $tomlTpl) {
    $tomlDst = Join-Path $mcpRoot "codex-mcp-config.toml"
    Write-Plan "codex toml template -> $tomlDst"
    if ($Apply) {
        $tomlOut = (Get-Content $tomlTpl -Raw -Encoding UTF8).Replace('{{DEBUGGER_ROOT}}', $escaped)
        Write-Utf8NoBom $tomlDst $tomlOut
    }
}

# --- 2b. router 自有 venv(默认启用的唯一 MCP,必须能独立启动)---
Write-Step "debugger-router 运行环境 (.venv + requirements.txt)"
$routerDir = Join-Path $mcpRoot "debugger-router"
$routerVenv = Join-Path $routerDir ".venv"
$routerReq = Join-Path $routerDir "requirements.txt"
if ($SkipRouterVenv) {
    Write-Plan "[skip] router .venv (-SkipRouterVenv)"
} elseif (-not $havePy) {
    Write-Warn2 "未检测到 python:无法为 router 建 .venv。请装 Python 3.11+ 后重跑,或确保 frida-mcp 的 .venv 已含 mcp 包(回退路径)。"
} elseif (Test-Path (Join-Path $routerVenv "Scripts\python.exe")) {
    Write-Plan "[skip] router .venv 已存在: $routerVenv"
} else {
    Write-Plan "python -m venv $routerVenv  然后 pip install -r requirements.txt"
    if ($Apply) {
        python -m venv $routerVenv
        $venvPy = Join-Path $routerVenv "Scripts\python.exe"
        if (Test-Path $venvPy) {
            & $venvPy -m pip install --quiet --upgrade pip
            & $venvPy -m pip install --quiet -r $routerReq
            if ($LASTEXITCODE -ne 0) {
                Write-Warn2 "router 依赖安装失败 (exit=$LASTEXITCODE):请检查网络,手动 `"$venvPy`" -m pip install -r `"$routerReq`"。"
            } else {
                Write-Plan "router .venv 就绪(已装 mcp)。"
            }
        } else {
            Write-Warn2 "router .venv 创建失败:请确认 python 可用。"
        }
    }
}

# --- 3. 第三方 MCP clone ---
Write-Step "第三方 MCP backend (来自 manifests/mcp-backends.json)"
$mcpManifest = Get-Content (Join-Path $RepoRoot "manifests\mcp-backends.json") -Raw -Encoding UTF8 | ConvertFrom-Json

# 判断目录是否已是有效 clone(非空且含 .git),避免半成品被永久 skip
function Test-ValidClone($path) {
    if (-not (Test-Path $path)) { return $false }
    if (-not (Test-Path (Join-Path $path ".git"))) { return $false }
    return ((Get-ChildItem $path -Force | Measure-Object).Count -gt 0)
}

function Invoke-CloneBackend($b) {
    $target = Join-Path $InstallRoot ($b.path.Replace('/', '\'))
    if (Test-Path $target) {
        if (Test-ValidClone $target) {
            Write-Plan "[skip] $($b.name) 已存在(有效 clone): $target"
            return
        }
        Write-Warn2 "$($b.name) 目录存在但不是有效 clone(半成品?): $target — 请手工清理后重试,本次跳过。"
        return
    }
    Write-Plan "clone $($b.git) -> $target  [$($b.build)]"
    if ($b.needs_env) { Write-Warn2 "$($b.name) 需要 .env(API key 等),clone 后请手工配置,勿入库。" }
    if ($Apply -and $CloneMcp) {
        if (-not $haveGit) { Write-Warn2 "缺 git,跳过 clone $($b.name)"; return }
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $target) | Out-Null
        # -- 分隔符防止以 -- 开头的 URL 被当作 git 选项
        git clone --depth 1 -- $b.git $target
        if ($LASTEXITCODE -ne 0) {
            Write-Warn2 "clone 失败 ($($b.name), exit=$LASTEXITCODE):请检查网络/认证,稍后重试。"
            $script:CloneFailures += $b.name
        }
    }
}

$script:CloneFailures = @()
foreach ($b in $mcpManifest.third_party) { Invoke-CloneBackend $b }

# resolved_upstream:原本无 .git、经核验确认的上游,同样需要 clone(否则 ghidra/jadx/x64dbg 后端缺源码)
if ($mcpManifest.resolved_upstream -and $mcpManifest.resolved_upstream.entries) {
    Write-Step "已确认上游的 MCP backend (resolved_upstream)"
    foreach ($b in $mcpManifest.resolved_upstream.entries) {
        if ($b.confidence) { Write-Plan "  ($($b.name) 上游置信度: $($b.confidence))" }
        Invoke-CloneBackend $b
    }
}

if (-not $CloneMcp) { Write-Warn2 "未加 -CloneMcp:跳过第三方 MCP 实际 clone(上面仅为计划)。" }
if ($script:CloneFailures.Count -gt 0) {
    Write-Warn2 "以下 backend clone 失败,需重试: $($script:CloneFailures -join ', ')"
}

# --- 4. 工具下载源提示 (默认不自动下载二进制) ---
if (-not $SkipTools) {
    Write-Step "工具下载源 (本仓库不分发二进制,请按官方源获取)"
    $toolsManifest = Get-Content (Join-Path $RepoRoot "manifests\tools.json") -Raw -Encoding UTF8 | ConvertFrom-Json
    foreach ($cat in $toolsManifest.tools.PSObject.Properties) {
        Write-Host "  [$($cat.Name)]" -ForegroundColor Magenta
        foreach ($t in $cat.Value) {
            $flag = if ($t.verify) { " (下载前联网核验官方页)" } else { "" }
            Write-Host ("    - {0,-22} {1,-10} {2}{3}" -f $t.name, $t.version, $t.official_source, $flag)
        }
    }
    Write-Warn2 "Cheat Engine 默认不下载/不更新,除非用户明确要求。"
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
if ($Apply) {
    $envHint = $null
    foreach ($cand in @($UiLanguage, $env:WORKSTATION_UI_LANG, $env:DEBUGGER_UI_LANG, $env:VRC_DCC_UI_LANG)) {
        if (-not [string]::IsNullOrWhiteSpace($cand)) { $envHint = $cand; break }
    }
    $writeLocale = [bool]$envHint
    if (-not (Test-Path -LiteralPath (Join-Path $InstallRoot 'local.json'))) {
        $ex = Join-Path $InstallRoot 'local.json.example'
        if (-not (Test-Path -LiteralPath $ex)) { $ex = Join-Path $RepoRoot 'local.json.example' }
        if (Test-Path -LiteralPath $ex) {
            Copy-Item -LiteralPath $ex -Destination (Join-Path $InstallRoot 'local.json')
        }
    }
    if ($writeLocale) {
        Save-WorkstationLocale -RepoRoot $InstallRoot -Locale $uiLocale -InstallRoot $InstallRoot -WriteLocale
    } else {
        Save-WorkstationLocale -RepoRoot $InstallRoot -InstallRoot $InstallRoot
    }
    Write-Host " 完成。下一步: 按上面官方源获取工具二进制," -ForegroundColor Green
    Write-Host " 然后重建第三方 MCP 的 .venv/dotnet/node 依赖并 smoke test。" -ForegroundColor Green
    Write-Host " 项目 MCP 仅 debugger-router：.mcp.json 与 .cursor\mcp.json（gitignore）。" -ForegroundColor Green
} else {
    Write-Host " DRY-RUN 结束。确认计划无误后:" -ForegroundColor Green
    Write-Host "   pwsh scripts\bootstrap.ps1 -Apply -CloneMcp -InstallRoot '$InstallRoot'" -ForegroundColor White
}
Write-Host "==================================================" -ForegroundColor Green
