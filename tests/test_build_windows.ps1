$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$builder = Join-Path $root 'scripts/build_windows.ps1'
$powershell = (Get-Process -Id $PID).Path
$temporaryRoot = Join-Path ([IO.Path]::GetTempPath()) ('build-script-tests-' + [guid]::NewGuid())
$null = New-Item -ItemType Directory -Path $temporaryRoot
$script:checks = 0
$script:failures = 0

function Check-Build {
    param(
        [string]$Name,
        [string[]]$Arguments,
        [bool]$ShouldSucceed,
        [string]$Diagnostic,
        [int]$ExpectedExitCode = -1
    )

    $output = & $powershell -NoProfile -File $builder @Arguments 2>&1
    $code = $LASTEXITCODE
    $text = $output -join "`n"
    $script:checks++
    if (($ShouldSucceed -and $code -ne 0) -or
        (-not $ShouldSucceed -and $code -eq 0) -or
        $text -notmatch $Diagnostic -or
        ($ExpectedExitCode -ge 0 -and $code -ne $ExpectedExitCode)) {
        $script:failures++
        Write-Host "FAIL: $Name (exit $code; expected diagnostic: $Diagnostic)"
        Write-Host $text
    } else {
        Write-Host "PASS: $Name (exit $code)"
    }
}

function New-FakeGodot {
    param([string]$Name)

    $path = Join-Path $temporaryRoot "$Name.cmd"
    @'
@echo off
if "%1"=="--version" (
  echo %FAKE_GODOT_VERSION%
  exit /b 0
)
echo %*>>"%FAKE_GODOT_ARGS_LOG%"
if "%FAKE_GODOT_ERROR%"=="1" echo ERROR: simulated Godot export error
if not "%FAKE_GODOT_EXIT%"=="0" if not "%FAKE_GODOT_EXIT%"=="" exit /b %FAKE_GODOT_EXIT%
set output=%~6
if "%output%"=="" exit /b 91
type nul > "%output%"
set pack=%output:.exe=.pck%
type nul > "%pack%"
exit /b 0
'@ | Set-Content -LiteralPath $path
    return $path
}

try {
    $project = Join-Path $temporaryRoot 'project'
    $null = New-Item -ItemType Directory -Path $project
    Set-Content -LiteralPath (Join-Path $project 'project.godot') -Value 'config_version=5'

    $fakeGodot = New-FakeGodot 'godot'
    $env:FAKE_GODOT_VERSION = '4.7.2.stable.official'
    $env:FAKE_GODOT_EXIT = '0'
    $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'godot-args.txt'

    $defaultOutput = Join-Path $project 'build/windows'
    Check-Build 'default configuration exports Release to project build/windows' @(
        '-GodotPath', $fakeGodot, '-ProjectPath', $project
    ) $true 'Windows Release build exported'
    if (Test-Path -LiteralPath $env:FAKE_GODOT_ARGS_LOG) {
        $releaseArgs = Get-Content -LiteralPath $env:FAKE_GODOT_ARGS_LOG -Raw
        if ($releaseArgs -notmatch '--export-release\s+"Windows Desktop"') {
            $script:failures++
            Write-Host 'FAIL: default configuration did not select the Release preset'
        }
        if (-not (Test-Path -LiteralPath (Join-Path $defaultOutput 'Miners Heaven.exe')) -or
            -not (Test-Path -LiteralPath (Join-Path $defaultOutput 'Miners Heaven.pck'))) {
            $script:failures++
            Write-Host 'FAIL: default build did not produce both executable and PCK'
        }
    }

    $debugOutput = Join-Path $project 'custom-output'
    $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'debug-args.txt'
    Check-Build 'Debug configuration creates a custom output directory' @(
        '-GodotPath', $fakeGodot, '-ProjectPath', $project,
        '-Configuration', 'Debug', '-OutputDirectory', 'custom-output'
    ) $true 'Windows Debug build exported'
    if (Test-Path -LiteralPath $env:FAKE_GODOT_ARGS_LOG) {
        $debugArgs = Get-Content -LiteralPath $env:FAKE_GODOT_ARGS_LOG -Raw
        if ($debugArgs -notmatch '--export-debug\s+"Windows Desktop"') {
            $script:failures++
            Write-Host 'FAIL: Debug configuration did not select the Debug preset'
        }
        if (-not (Test-Path -LiteralPath (Join-Path $debugOutput 'Miners Heaven.exe')) -or
            -not (Test-Path -LiteralPath (Join-Path $debugOutput 'Miners Heaven.pck'))) {
            $script:failures++
            Write-Host 'FAIL: custom output did not contain both executable and PCK'
        }
    }

    $previousGodot = $env:GODOT_BIN
    try {
        $env:GODOT_BIN = $fakeGodot
        $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'environment-args.txt'
        Check-Build 'GODOT_BIN discovery works' @(
            '-ProjectPath', $project, '-OutputDirectory', (Join-Path $temporaryRoot 'environment-output')
        ) $true 'Windows Release build exported'
    } finally {
        $env:GODOT_BIN = $previousGodot
    }

    $pathDirectory = Join-Path $temporaryRoot 'path-bin'
    $null = New-Item -ItemType Directory -Path $pathDirectory
    Copy-Item -LiteralPath $fakeGodot -Destination (Join-Path $pathDirectory 'godot.cmd')
    $previousPath = $env:PATH
    $previousGodot = $env:GODOT_BIN
    try {
        Remove-Item Env:GODOT_BIN -ErrorAction SilentlyContinue
        $env:PATH = "$pathDirectory;$previousPath"
        $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'path-args.txt'
        Check-Build 'PATH discovery works' @(
            '-ProjectPath', $project, '-OutputDirectory', (Join-Path $temporaryRoot 'path-output')
        ) $true 'Windows Release build exported'
    } finally {
        $env:PATH = $previousPath
        $env:GODOT_BIN = $previousGodot
    }

    $previousLocation = Get-Location
    try {
        Set-Location $temporaryRoot
        $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'default-project-args.txt'
        Check-Build 'default project root resolves when called from elsewhere' @(
            '-GodotPath', $fakeGodot, '-OutputDirectory', (Join-Path $temporaryRoot 'default-project-output')
        ) $true 'Windows Release build exported'
        $defaultProjectArgs = Get-Content -LiteralPath $env:FAKE_GODOT_ARGS_LOG -Raw
        if ($defaultProjectArgs -notmatch ("--path\s+" + [regex]::Escape($root))) {
            $script:failures++
            Write-Host 'FAIL: default project root depended on the caller working directory'
            Write-Host "Observed Godot arguments: $defaultProjectArgs"
        }
    } finally {
        Set-Location $previousLocation
    }

    Check-Build 'unavailable explicit Godot path fails clearly' @(
        '-GodotPath', (Join-Path $temporaryRoot 'missing-godot.exe'), '-ProjectPath', $project
    ) $false 'Godot executable unavailable'

    $env:FAKE_GODOT_VERSION = '3.6.stable'
    Check-Build 'non-Godot-4 executable fails clearly' @(
        '-GodotPath', $fakeGodot, '-ProjectPath', $project
    ) $false 'Godot 4 is required'

    $env:FAKE_GODOT_VERSION = '4.7.2.stable.official'
    $env:FAKE_GODOT_ERROR = '1'
    $env:FAKE_GODOT_EXIT = '0'
    $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'reported-error-args.txt'
    Check-Build 'reported Godot errors fail even with exit zero' @(
        '-GodotPath', $fakeGodot, '-ProjectPath', $project,
        '-OutputDirectory', (Join-Path $temporaryRoot 'reported-error-output')
    ) $false 'Godot reported export errors' 1

    Remove-Item Env:FAKE_GODOT_ERROR -ErrorAction SilentlyContinue
    $env:FAKE_GODOT_EXIT = '7'
    $env:FAKE_GODOT_ARGS_LOG = Join-Path $temporaryRoot 'failed-export-args.txt'
    Check-Build 'native export failure code is preserved' @(
        '-GodotPath', $fakeGodot, '-ProjectPath', $project
    ) $false 'Godot export failed' 7
} finally {
    Remove-Item Env:FAKE_GODOT_VERSION -ErrorAction SilentlyContinue
    Remove-Item Env:FAKE_GODOT_EXIT -ErrorAction SilentlyContinue
    Remove-Item Env:FAKE_GODOT_ARGS_LOG -ErrorAction SilentlyContinue
    Remove-Item Env:FAKE_GODOT_ERROR -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
}

Write-Host "Build script: $script:checks scenarios, $script:failures failures"
if ($script:failures -gt 0) { exit 1 }
exit 0
