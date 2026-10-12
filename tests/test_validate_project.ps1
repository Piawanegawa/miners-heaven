param(
    [Parameter(Mandatory = $true)]
    [string]$GodotPath
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$validator = Join-Path $root 'scripts/validate_project.ps1'
$powershell = (Get-Process -Id $PID).Path
$temporaryRoot = Join-Path $env:LOCALAPPDATA ('Temp/opencode/validator-tests-' + [guid]::NewGuid())
$null = New-Item -ItemType Directory -Path $temporaryRoot
$script:failures = 0
$script:checks = 0

function Check-Validation {
    param([string]$Name, [string[]]$Arguments, [bool]$ShouldSucceed, [string]$Diagnostic, [int]$ExpectedExitCode = -1)
    # A swallowed error, silent fallback, or omitted scene/import stage breaks these checks.
    $output = & $powershell -NoProfile -File $validator @Arguments 2>&1
    $code = $LASTEXITCODE
    $text = $output -join "`n"
    $script:checks++
    if (($ShouldSucceed -and $code -ne 0) -or
        (-not $ShouldSucceed -and $code -eq 0) -or $text -notmatch $Diagnostic -or
        ($ExpectedExitCode -ge 0 -and $code -ne $ExpectedExitCode)) {
        $script:failures++
        Write-Host "FAIL: $Name (exit $code; expected diagnostic: $Diagnostic)"
        Write-Host $text
    } else {
        Write-Host "PASS: $Name (exit $code)"
    }
}

function New-Fixture {
    param([string]$Name, [string]$Project, [string]$Scene = '')
    $path = Join-Path $temporaryRoot $Name
    $null = New-Item -ItemType Directory -Path $path
    if ($Project) { Set-Content -Path (Join-Path $path 'project.godot') -Value $Project }
    if ($Scene) { Set-Content -Path (Join-Path $path 'main.tscn') -Value $Scene }
    return $path
}

try {
    $missingExe = Join-Path $temporaryRoot 'unavailable-godot.exe'
    Check-Validation 'unavailable explicit executable fails without fallback' @('-GodotPath', $missingExe) $false 'Godot executable.*(unavailable|not found)'

    # The Windows GUI companion may not provide output/status to PowerShell.
    # It must never cause a failed version check to return success.
    $guiCompanion = $GodotPath -replace '_console\.exe$', '.exe'
    if ($guiCompanion -ne $GodotPath -and (Test-Path -LiteralPath $guiCompanion)) {
        Check-Validation 'unobservable GUI version check cannot report success' @('-GodotPath', $guiCompanion) $false '(version check|console executable)' 1
    }

    $missingProject = New-Fixture 'missing-project' ''
    Check-Validation 'missing project file fails clearly' @('-GodotPath', $GodotPath, '-ProjectPath', $missingProject) $false 'project.godot.*(missing|not found)'

    $malformed = New-Fixture 'malformed-project' 'config_version=5
[application
run/main_scene="res://main.tscn"'
    Check-Validation 'malformed project fails even if Godot exits zero' @('-GodotPath', $GodotPath, '-ProjectPath', $malformed) $false 'Validation failed during editor import/project load: Godot reported errors despite exit 0' 1

    $noMain = New-Fixture 'no-main' 'config_version=5
[application]
config/name="No main scene"'
    Check-Validation 'unregistered main scene fails instead of opening project manager' @('-GodotPath', $GodotPath, '-ProjectPath', $noMain) $false 'main scene.*(missing|registered)'

    $project = 'config_version=5
[application]
config/name="Validator fixture"
run/main_scene="res://main.tscn"
[rendering]
renderer/rendering_method="gl_compatibility"'
    $badScene = New-Fixture 'broken-scene' $project '[gd_scene format=3]
[node name="Main" type="NonexistentNodeType"]'
    Check-Validation 'scene-load errors fail even if Godot exits zero' @('-GodotPath', $GodotPath, '-ProjectPath', $badScene) $false 'Validation failed during (editor import/project load|main scene load): Godot reported errors despite exit 0'

    $badScript = New-Fixture 'broken-script' $project '[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://broken.gd" id="1"]
[node name="Main" type="Node"]
script = ExtResource("1")'
    Set-Content -Path (Join-Path $badScript 'broken.gd') -Value "extends Node`nfunc broken(:"
    Check-Validation 'script import errors fail even if Godot exits zero' @('-GodotPath', $GodotPath, '-ProjectPath', $badScript) $false 'Validation failed during editor import/project load: Godot reported errors despite exit 0'

    $nativeFailure = New-Fixture 'native-failure' $project '[gd_scene load_steps=2 format=3]
[ext_resource type="Script" path="res://exit.gd" id="1"]
[node name="Main" type="Node"]
script = ExtResource("1")'
    Set-Content -Path (Join-Path $nativeFailure 'exit.gd') -Value "extends Node`nfunc _ready() -> void:`n`tget_tree().quit(7)"
    Check-Validation 'native main-scene exit code is preserved exactly' @('-GodotPath', $GodotPath, '-ProjectPath', $nativeFailure) $false 'Validation failed during main scene load \(Godot exit 7\)' 7

    Check-Validation 'real playable project validates via explicit executable' @('-GodotPath', $GodotPath, '-ProjectPath', $root) $true 'Validation passed'
    $previousGodot = $env:GODOT_BIN
    try {
        $env:GODOT_BIN = $GodotPath
        Check-Validation 'environment executable discovery works' @('-ProjectPath', $root) $true 'Validation passed'
        $env:GODOT_BIN = $missingExe
        Check-Validation 'unavailable environment executable fails without fallback' @('-ProjectPath', $root) $false 'Godot executable.*(unavailable|not found)'
    } finally {
        $env:GODOT_BIN = $previousGodot
    }
} finally {
    # Remove only the uniquely named fixtures created by this run.
    Remove-Item -LiteralPath $temporaryRoot -Recurse -Force
}

Write-Host "Validator: $script:checks checks, $script:failures failures"
if ($script:failures -gt 0) { exit 1 }
exit 0
