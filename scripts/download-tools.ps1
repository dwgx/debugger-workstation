#Requires -Version 5.1
<#
.SYNOPSIS
  Download official portable tool binaries into this debugger-workstation clone.
  Uses `gh` when available (avoids unauthenticated GitHub REST 403).
  Default dry-run. Pass -Apply to write. Never commits binaries.
  Npcap: downloads the installer only; does not run it.
#>
[CmdletBinding()]
param(
    [string]$InstallRoot = '',
    [switch]$Apply,
    [switch]$SkipExisting = $true
)

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$RepoRoot = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot 'resolve-locale.ps1')
if ([string]::IsNullOrWhiteSpace($InstallRoot)) {
    $InstallRoot = Get-WorkstationInstallRoot -RepoRoot $RepoRoot
}

function Write-Job([string]$Name, [string]$Msg) {
    Write-Host ("[{0}] {1}" -f $Name, $Msg)
}

function Test-HasFiles([string]$Dir) {
    if (-not (Test-Path -LiteralPath $Dir)) { return $false }
    return [bool](Get-ChildItem -LiteralPath $Dir -Recurse -File -ErrorAction SilentlyContinue | Select-Object -First 1)
}

function Save-Url([string]$Url, [string]$OutFile) {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $OutFile) | Out-Null
    if ((Test-Path -LiteralPath $OutFile) -and ((Get-Item -LiteralPath $OutFile).Length -gt 0)) {
        Write-Host "  skip exists $OutFile"
        return
    }
    Write-Host "  GET $Url"
    if ($Apply) {
        Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
    }
}

function Get-GhAsset([string]$Repo, [string]$Tag, [string]$Pattern) {
    $path = if ($Tag -eq 'latest') { "repos/$Repo/releases/latest" } else { "repos/$Repo/releases/tags/$Tag" }
    $rel = gh api $path | ConvertFrom-Json
    $asset = @($rel.assets) | Where-Object { $_.name -match $Pattern } | Select-Object -First 1
    if (-not $asset) { throw "No asset /$Pattern/ in $Repo $Tag" }
    return @{ url = [string]$asset.browser_download_url; name = [string]$asset.name; tag = [string]$rel.tag_name }
}

function Expand-ToolZip([string]$Zip, [string]$Dest) {
    if (-not $Apply) { Write-Host "  would unzip $Zip -> $Dest"; return }
    New-Item -ItemType Directory -Force -Path $Dest | Out-Null
    Expand-Archive -LiteralPath $Zip -DestinationPath $Dest -Force
}

$stage = Join-Path $InstallRoot '_download-stage'
New-Item -ItemType Directory -Force -Path $stage | Out-Null
$sevenZip = $null

# --- GitHub zip/exe jobs ---
$ghJobs = @(
    @{ name = 'ImHex'; repo = 'WerWolv/ImHex'; tag = 'latest'; pat = 'Windows-Portable-x86_64\.zip$'; dir = 'Static-Reversing\ImHex' },
    @{ name = 'radare2'; repo = 'radareorg/radare2'; tag = 'latest'; pat = 'radare2-.*-w64\.zip$'; dir = 'Static-Reversing\radare2' },
    @{ name = 'GH-Injector'; repo = 'guidedhacking/GuidedHacking-Injector'; tag = 'latest'; pat = 'GH\.Injector\.zip$'; dir = 'Debuggers\GH-Injector' },
    @{ name = 'UniExtract'; repo = 'Bioruebe/UniExtract2'; tag = 'v2.0.0-rc.3'; pat = 'UniExtractRC3\.zip$'; dir = 'Unpackers-Game\UniExtract' },
    @{ name = 'pyinstxtractor-ng'; repo = 'pyinstxtractor/pyinstxtractor-ng'; tag = 'latest'; pat = 'pyinstxtractor-ng\.exe$'; dir = 'Unpackers-Game\pyinstxtractor-ng'; copy = $true },
    @{ name = 'SystemInformer'; repo = 'winsiderss/systeminformer'; tag = 'latest'; pat = '-bin\.zip$'; dir = 'System-Forensics\systeminformer' },
    @{ name = 'UPX'; repo = 'upx/upx'; tag = 'latest'; pat = 'upx-.*-win64\.zip$'; dir = 'Unpackers-Game\upx' },
    @{ name = 'YARA-X'; repo = 'VirusTotal/yara-x'; tag = 'latest'; pat = 'yara-x-v.*-x86_64-pc-windows-msvc\.zip$'; dir = 'Static-Reversing\YARA-X' },
    @{ name = 'Reqable'; repo = 'reqable/reqable-app'; tag = 'latest'; pat = 'reqable-app-windows-x86_64\.zip$'; dir = 'Network-HTTP\reqable-app-windows-x86_64' },
    @{ name = 'volatility3-win'; repo = 'volatilityfoundation/volatility3'; tag = 'latest'; pat = 'volatility3-win-exes-.*\.zip$'; dir = 'System-Forensics\volatility3' },
    @{ name = 'Ghidra-12.1.3'; repo = 'NationalSecurityAgency/ghidra'; tag = 'Ghidra_12.1.3_build'; pat = 'PUBLIC_.*\.zip$'; dir = 'Static-Reversing\Ghidra' },
    @{ name = 'capa'; repo = 'mandiant/capa'; tag = 'latest'; pat = 'capa-v.*-windows\.zip$'; dir = 'Static-Reversing\capa' }
)

foreach ($j in $ghJobs) {
    $dest = Join-Path $InstallRoot $j.dir
    Write-Job $j.name $j.repo
    if ($SkipExisting -and (Test-HasFiles $dest) -and $j.name -ne 'YARA-X' -and $j.name -ne 'Ghidra-12.1.3' -and $j.name -ne 'capa') {
        Write-Host '  skip dest has files'
        continue
    }
    try {
        $a = Get-GhAsset $j.repo $j.tag $j.pat
        $out = Join-Path $stage $a.name
        Save-Url $a.url $out
        if ($j.copy) {
            if ($Apply) {
                New-Item -ItemType Directory -Force -Path $dest | Out-Null
                Copy-Item $out (Join-Path $dest $a.name) -Force
            }
        } else {
            Expand-ToolZip $out $dest
        }
    } catch {
        Write-Warning ("{0}: {1}" -f $j.name, $_.Exception.Message)
    }
}

# ReClass.NET is a .rar
Write-Job 'ReClass.NET' 'ReClassNET/ReClass.NET'
$reDest = Join-Path $InstallRoot 'Static-Reversing\ReClass.NET'
try {
    $a = Get-GhAsset 'ReClassNET/ReClass.NET' 'latest' '\.rar$'
    $rar = Join-Path $stage $a.name
    Save-Url $a.url $rar
} catch {
    Write-Warning $_.Exception.Message
    $rar = $null
}

# 7-Zip: 7zr then extra.7z then x64 installer for full GUI
Write-Job '7-Zip' 'ip7z/7zip 26.02'
try {
    $zr = Get-GhAsset 'ip7z/7zip' '26.02' '^7zr\.exe$'
    $zrPath = Join-Path $stage $zr.name
    Save-Url $zr.url $zrPath
    $extra = Get-GhAsset 'ip7z/7zip' '26.02' '7z2602-extra\.7z$'
    $extraPath = Join-Path $stage $extra.name
    Save-Url $extra.url $extraPath
    $full = Get-GhAsset 'ip7z/7zip' '26.02' '7z2602-x64\.exe$'
    $fullPath = Join-Path $stage $full.name
    Save-Url $full.url $fullPath
    $extraDest = Join-Path $InstallRoot 'Unpackers-Game\7-Zip'
    $fullDest = Join-Path $InstallRoot 'Unpackers-Game\7-Zip-full'
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path $extraDest | Out-Null
        & $zrPath x "-o$extraDest" -y $extraPath | Out-Null
        $sevenZip = Get-ChildItem -LiteralPath $extraDest -Recurse -Filter '7za.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $sevenZip) {
            $sevenZip = Get-ChildItem -LiteralPath $extraDest -Recurse -Filter '7z.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
        }
        New-Item -ItemType Directory -Force -Path $fullDest | Out-Null
        Start-Process -FilePath $fullPath -ArgumentList @('/S', "/D=$fullDest") -Wait
        if (-not $sevenZip) {
            $hit = Get-ChildItem -LiteralPath $fullDest -Recurse -Filter '7z.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
            if ($hit) { $sevenZip = $hit }
        }
    }
} catch {
    Write-Warning ("7-Zip: {0}" -f $_.Exception.Message)
}

if ($Apply -and $rar -and (Test-Path -LiteralPath $rar)) {
    $unpacker = $null
    $full7z = Join-Path $InstallRoot 'Unpackers-Game\7-Zip-full\7z.exe'
    if (Test-Path -LiteralPath $full7z) { $unpacker = $full7z }
    elseif ($sevenZip) { $unpacker = $sevenZip.FullName }
    if ($unpacker) {
        New-Item -ItemType Directory -Force -Path $reDest | Out-Null
        & $unpacker x $rar "-o$reDest" -y | Out-Null
        Write-Job 'ReClass.NET' "extracted with $unpacker"
    } else {
        Write-Warning 'ReClass.NET: no 7z yet; rar left in _download-stage'
    }
}

# Direct URLs
Write-Job 'Sysinternals' 'download.sysinternals.com'
$sysZip = Join-Path $stage 'SysinternalsSuite.zip'
Save-Url 'https://download.sysinternals.com/files/SysinternalsSuite.zip' $sysZip
$sysDest = Join-Path $InstallRoot 'System-Forensics\SysinternalsSuite'
if ($SkipExisting -and (Test-HasFiles $sysDest)) {
    Write-Host '  skip dest has files'
} else {
    Expand-ToolZip $sysZip $sysDest
}

Write-Job 'Npcap-installer' 'npcap.com (download only, do not run)'
$npcap = Join-Path $InstallRoot 'Network-HTTP\Npcap-installer\npcap-1.88.exe'
Save-Url 'https://npcap.com/dist/npcap-1.88.exe' $npcap

Write-Job 'Wireshark-portable' 'wireshark.org PAF'
$ws = Join-Path $InstallRoot 'Network-HTTP\Wireshark\WiresharkPortable64_4.6.8.paf.exe'
Save-Url 'https://2.na.dl.wireshark.org/win64/WiresharkPortable64_4.6.8.paf.exe' $ws

# pip / git tools
$py = Get-Command python -ErrorAction SilentlyContinue
if ($null -ne $py) {
    Write-Job 'objection' 'pip venv'
    $objVenv = Join-Path $InstallRoot 'Mobile-Android\objection'
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path $objVenv | Out-Null
        $pyExe = Join-Path $objVenv '.venv\Scripts\python.exe'
        if (-not (Test-Path -LiteralPath $pyExe)) {
            & python -m venv (Join-Path $objVenv '.venv')
        }
        & (Join-Path $objVenv '.venv\Scripts\python.exe') -m pip install --upgrade pip objection | Out-Host
    }
} else {
    Write-Warning 'python missing; skip objection venv'
}

$git = Get-Command git -ErrorAction SilentlyContinue
if ($null -ne $git) {
    Write-Job 'MobSF' 'git clone --depth 1'
    $mobsf = Join-Path $InstallRoot 'Mobile-Android\MobSF'
    if ($SkipExisting -and (Test-Path (Join-Path $mobsf '.git'))) {
        Write-Host '  skip clone exists'
    } elseif ($Apply) {
        git clone --depth 1 https://github.com/MobSF/Mobile-Security-Framework-MobSF.git $mobsf
    }
}

$dotnet = Get-Command dotnet -ErrorAction SilentlyContinue
if ($null -ne $dotnet) {
    Write-Job 'ilspycmd' 'dotnet tool-path'
    $ilspyCmd = Join-Path $InstallRoot 'Static-Reversing\ilspycmd'
    if ($Apply) {
        New-Item -ItemType Directory -Force -Path $ilspyCmd | Out-Null
        & dotnet tool install ilspycmd --tool-path $ilspyCmd
    }
}

Write-Host ''
Write-Host 'Cheat Engine: official Windows build is clickwrap on cheatengine.org (no GitHub binary). Not scraped.'
Write-Host 'Npcap: installer downloaded only. Do not silent-install the driver from this script.'
if (-not $Apply) { Write-Host 'dry-run. Re-run with -Apply to download.' }
