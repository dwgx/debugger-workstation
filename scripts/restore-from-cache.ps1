#Requires -Version 5.1
<#
.SYNOPSIS
  Unpack an optional private 7z cache into this debugger-workstation clone.
  Binaries are not in the public git repo. Point -ArchivePath at an archive you maintain.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ArchivePath,
    [string]$InstallRoot = '',
    [switch]$Apply
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($InstallRoot)) {
    $InstallRoot = Split-Path -Parent $PSScriptRoot
}
if (-not (Test-Path -LiteralPath $ArchivePath)) {
    throw "Archive not found: $ArchivePath"
}
if (-not $Apply) {
    Write-Host "dry-run. Archive=$ArchivePath  root=$InstallRoot"
    Write-Host 'Re-run with -Apply to extract.'
    exit 0
}

$z7 = @(
    (Join-Path $InstallRoot 'Unpackers-Game\7-Zip-full\7z.exe'),
    'C:\Program Files\7-Zip\7z.exe'
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $z7) { throw 'Need 7z.exe (install 7-Zip, or extract 7z2602-extra from the cache first).' }

$unpack = Join-Path $InstallRoot '_cache-unpack'
New-Item -ItemType Directory -Force -Path $unpack | Out-Null
& $z7 x $ArchivePath "-o$unpack" -y
if ($LASTEXITCODE -ne 0) { throw "7z extract failed: $LASTEXITCODE" }

$stage = Join-Path $InstallRoot '_download-stage'
New-Item -ItemType Directory -Force -Path $stage | Out-Null
$stageSrc = Join-Path $unpack '_download-stage'
if (Test-Path -LiteralPath $stageSrc) {
    Copy-Item (Join-Path $stageSrc '*') $stage -Force
}

$ceSrc = Join-Path $unpack 'Cheat Engine'
$ceDest = Join-Path $InstallRoot 'Debuggers\Cheat Engine'
if (Test-Path -LiteralPath $ceSrc) {
    New-Item -ItemType Directory -Force -Path $ceDest | Out-Null
    Copy-Item (Join-Path $ceSrc '*') $ceDest -Recurse -Force
}

$npcap = Get-ChildItem $unpack -Recurse -Filter 'npcap-*.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($npcap) {
    $dest = Join-Path $InstallRoot 'Network-HTTP\Npcap-installer'
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item $npcap.FullName $dest -Force
    Write-Host "Npcap installer copied. Free Npcap is GUI-only (/S is OEM). Run: $($npcap.Name)"
}

$ws = Get-ChildItem $unpack -Recurse -Filter 'WiresharkPortable*.paf.exe' -ErrorAction SilentlyContinue | Select-Object -First 1
if ($ws) {
    $dest = Join-Path $InstallRoot 'Network-HTTP\Wireshark'
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item $ws.FullName $dest -Force
}

Write-Host 'Next: powershell -File scripts\download-tools.ps1 -Apply  (expands zips into category dirs)'
Write-Host 'IDA Pro is not in the cache. Junction it yourself if you have a license.'
