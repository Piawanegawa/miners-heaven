param(
    [string]$GodotPath,
    [string]$ProjectPath = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = 'Stop'
# Native failures are handled explicitly so their exit codes survive PowerShell 7 settings.
$PSNativeCommandUseErrorActionPreference = $false

function Find-Godot {
    if ($GodotPath) { return $GodotPath }
    if ($env:GODOT_BIN) { return $env:GODOT_BIN }
    foreach ($name in @('godot', 'godot4', 'godot_console')) {
        $command = Get-Command $name -CommandType Application -ErrorAction SilentlyContinue
        if ($command) { return $command.Source }
    }
    # Supported Windows fallback: the per-user WinGet Godot console installation.
    if ($env:LOCALAPPDATA) {
        $pattern = Join-Path $env:LOCALAPPDATA 'Microsoft/WinGet/Packages/GodotEngine.GodotEngine_*/Godot_v4*-stable_win64_console.exe'
        $installed = Get-ChildItem -Path $pattern -File -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($installed) { return $installed.FullName }
    }
    throw 'Godot executable not found. Supply -GodotPath, set GODOT_BIN, or put Godot 4 on PATH.'
}

function Invoke-GodotCheck {
    param([string]$Stage, [string[]]$Arguments)
    Write-Host "Validating $Stage..."
    $output = & $script:executable @Arguments 2>&1
    $code = $LASTEXITCODE
    foreach ($line in $output) { Write-Host $line }
    if ($code -ne 0) {
        [Console]::Error.WriteLine("Validation failed during $Stage (Godot exit $code).")
        exit $code
    }
    # Godot can report resource/script/import errors yet exit 0. Never hide them.
    if (($output -join "`n") -match '(?im)^\s*(ERROR:|SCRIPT ERROR:|Parse Error:)') {
        [Console]::Error.WriteLine("Validation failed during ${Stage}: Godot reported errors despite exit 0.")
        exit 1
    }
}

try {
    $script:executable = Find-Godot
    $command = Get-Command $script:executable -CommandType Application -ErrorAction SilentlyContinue
    if (-not $command) {
        throw "Godot executable unavailable: $script:executable. Supply a valid -GodotPath or GODOT_BIN."
    }
    $script:executable = $command.Source
    $versionOutput = & $script:executable --version 2>&1
    $versionCode = $LASTEXITCODE
    if ($null -eq $versionCode) {
        throw 'Godot version check returned no process status. On Windows, use the console executable.'
    }
    if ($versionCode -ne 0) {
        [Console]::Error.WriteLine("Godot version check failed (exit $versionCode): $versionOutput")
        exit $versionCode
    }
    if (($versionOutput -join "`n") -notmatch '^4\.') {
        throw "Godot 4 is required; executable reported: $versionOutput"
    }
    Write-Host "Godot: $script:executable ($versionOutput)"

    $projectFile = Join-Path $ProjectPath 'project.godot'
    if (-not (Test-Path -LiteralPath $projectFile -PathType Leaf)) {
        throw "project.godot not found in project directory: $ProjectPath"
    }
    $projectDirectory = (Resolve-Path -LiteralPath $ProjectPath).Path
    Invoke-GodotCheck 'editor import/project load' @('--headless', '--editor', '--path', $projectDirectory, '--quit')

    # Avoid launching the project manager when no playable main scene is registered.
    $configuration = Get-Content -LiteralPath $projectFile -Raw
    if ($configuration -notmatch '(?m)^\s*run/main_scene\s*=\s*"[^"]+"') {
        throw 'Playable main scene missing: register application/run/main_scene in project.godot.'
    }
    Invoke-GodotCheck 'main scene load' @('--headless', '--path', $projectDirectory, '--quit-after', '5')
    Write-Host 'Validation passed: editor import/project load and playable main scene load.'
    exit 0
} catch {
    [Console]::Error.WriteLine("Validation failed: $($_.Exception.Message)")
    exit 1
}
