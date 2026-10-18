param(
    [string]$GodotPath,
    [ValidateSet('Release', 'Debug')]
    [string]$Configuration = 'Release',
    [string]$OutputDirectory = 'build/windows',
    [string]$ProjectPath = (Split-Path $PSScriptRoot -Parent)
)

$ErrorActionPreference = 'Stop'
# Native failures are handled explicitly so their exit codes survive PowerShell 7 settings.
$PSNativeCommandUseErrorActionPreference = $false

function Find-Godot {
    if ($GodotPath) { return $GodotPath }
    if ($env:GODOT_BIN) { return $env:GODOT_BIN }
    foreach ($name in @('godot', 'godot4', 'godot_console')) {
        $command = Get-Command $name -CommandType Application -ErrorAction SilentlyContinue |
            Select-Object -First 1
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

try {
    $script:executable = Find-Godot
    $command = Get-Command $script:executable -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if (-not $command) {
        throw "Godot executable unavailable: $script:executable. Supply a valid -GodotPath or GODOT_BIN."
    }
    $script:executable = $command.Source

    $versionOutput = & $script:executable --version 2>&1
    $versionCode = $LASTEXITCODE
    if ($versionCode -ne 0) {
        throw "Godot version check failed (exit $versionCode): $($versionOutput -join "`n")"
    }
    if (($versionOutput -join "`n") -notmatch '(?m)^4\.') {
        throw "Godot 4 is required; executable reported: $($versionOutput -join "`n")"
    }

    $projectFile = Join-Path $ProjectPath 'project.godot'
    if (-not (Test-Path -LiteralPath $projectFile -PathType Leaf)) {
        throw "project.godot not found in project directory: $ProjectPath"
    }
    $projectDirectory = (Resolve-Path -LiteralPath $ProjectPath).Path

    if ([IO.Path]::IsPathRooted($OutputDirectory)) {
        $resolvedOutputDirectory = $OutputDirectory
    } else {
        $resolvedOutputDirectory = Join-Path $projectDirectory $OutputDirectory
    }
    $null = New-Item -ItemType Directory -Path $resolvedOutputDirectory -Force

    $exportMode = if ($Configuration -eq 'Debug') { '--export-debug' } else { '--export-release' }
    $executablePath = Join-Path $resolvedOutputDirectory 'Miners Heaven.exe'
    Write-Host "Exporting Windows $Configuration build with Godot $($versionOutput -join ' ')..."
    $exportOutput = & $script:executable --headless --path $projectDirectory $exportMode 'Windows Desktop' $executablePath 2>&1
    $exportCode = $LASTEXITCODE
    foreach ($line in $exportOutput) { Write-Host $line }
    if ($exportCode -ne 0) {
        [Console]::Error.WriteLine("Godot export failed (exit $exportCode). Ensure the matching Windows export templates are installed.")
        exit $exportCode
    }
    if (($exportOutput -join "`n") -match '(?im)^\s*(ERROR:|SCRIPT ERROR:|Parse Error:)') {
        [Console]::Error.WriteLine('Godot reported export errors despite exit 0.')
        exit 1
    }

    $packPath = [IO.Path]::ChangeExtension($executablePath, '.pck')
    if (-not (Test-Path -LiteralPath $executablePath -PathType Leaf)) {
        throw "Godot reported success but the executable was not created: $executablePath"
    }
    if (-not (Test-Path -LiteralPath $packPath -PathType Leaf)) {
        throw "Godot reported success but the project data pack was not created: $packPath"
    }

    Write-Host "Windows $Configuration build exported:"
    Write-Host "  Executable: $executablePath"
    Write-Host "  Project data: $packPath"
    exit 0
} catch {
    [Console]::Error.WriteLine("Windows build failed: $($_.Exception.Message)")
    exit 1
}
