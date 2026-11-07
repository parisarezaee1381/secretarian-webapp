<#
.SYNOPSIS
  Runs the Flutter tests, sliced whichever way you need.

.DESCRIPTION
  No switch            whole suite in one `flutter test` run (fastest)
  -Each                every test file in its own run, then a summary
  -File <path>         one file, e.g. -File data/user_repository_test.dart
  -Name <text>         tests whose name contains <text> (combines with -File)
  -Filter <pattern>    with -Each: only files whose path matches, e.g. 'test\data\*'
  -Analyze             flutter analyze instead of running tests
  -IsarLibrary <path>  sets ISAR_CORE_LIBRARY for the database tests

.EXAMPLE
  .\test\run_tests.ps1

.EXAMPLE
  .\test\run_tests.ps1 -Each

.EXAMPLE
  .\test\run_tests.ps1 -Each -Filter 'test\attachments\*'

.EXAMPLE
  .\test\run_tests.ps1 -File documents\document_list_test.dart -Name pagination

.EXAMPLE
  .\test\run_tests.ps1 -Name "jalaliToComparable"
#>
[CmdletBinding()]
param(
  [switch]$Each,
  [string]$File,
  [string]$Name,
  [string]$Filter,
  [switch]$Analyze,
  [string]$IsarLibrary
)

$ErrorActionPreference = 'Stop'

# This script lives in test/, so the project root is its parent.
$root = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $root

if ($IsarLibrary) {
  $env:ISAR_CORE_LIBRARY = $IsarLibrary
}

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw 'flutter is not on PATH.'
}

function Invoke-Flutter {
  param([string[]]$FlutterArgs)

  # Out-Host keeps the tool's output on the console: piping it would become the
  # function's return value instead of something the user can read.
  & flutter @FlutterArgs | Out-Host

  return $LASTEXITCODE
}

function Resolve-TestPath {
  param([string]$Path)

  if ([System.IO.Path]::IsPathRooted($Path)) {
    return $Path
  }

  if ($Path -like 'test/*' -or $Path -like 'test\*') {
    return (Join-Path $root $Path)
  }

  return (Join-Path $root (Join-Path 'test' $Path))
}

if ($Analyze) {
  Write-Host '==> flutter analyze' -ForegroundColor Cyan

  exit (Invoke-Flutter @('analyze'))
}

# One file, optionally narrowed to a single test name.
if ($File) {
  $path = Resolve-TestPath $File

  if (-not (Test-Path -LiteralPath $path)) {
    throw "No such test file: $path"
  }

  $flutterArgs = @('test', $path)

  if ($Name) {
    $flutterArgs += @('--plain-name', $Name)
  }

  Write-Host ('==> flutter ' + ($flutterArgs -join ' ')) -ForegroundColor Cyan

  exit (Invoke-Flutter $flutterArgs)
}

# One name across the whole suite.
if ($Name) {
  Write-Host "==> flutter test --plain-name '$Name'" -ForegroundColor Cyan

  exit (Invoke-Flutter @('test', '--plain-name', $Name))
}

$files = Get-ChildItem -LiteralPath (Join-Path $root 'test') -Recurse -Filter '*_test.dart' |
  Sort-Object FullName

if (-not $Each) {
  Write-Host "==> flutter test  ($($files.Count) test files)" -ForegroundColor Cyan

  $code = Invoke-Flutter @('test')

  if ($code -ne 0) {
    Write-Host "FAILED (exit $code)" -ForegroundColor Red
  }

  exit $code
}

if ($Filter) {
  $files = @(
    $files | Where-Object {
      ($_.FullName.Substring($root.Length).TrimStart('\', '/')) -like $Filter
    }
  )

  if ($files.Count -eq 0) {
    throw "No test files match '$Filter'."
  }
}

Write-Host "==> running $($files.Count) test files one by one" -ForegroundColor Cyan

$results = @()

try {
  foreach ($testPath in $files) {
    $relative = $testPath.FullName.Substring($root.Length).TrimStart('\', '/')

    Write-Host ''
    Write-Host "--- $relative" -ForegroundColor Yellow

    & flutter test $testPath.FullName

    $results += [pscustomobject]@{
      File   = $relative
      Passed = ($LASTEXITCODE -eq 0)
    }
  }
} catch {
  Write-Host ''
  Write-Host "Stopped: $($_.Exception.Message)" -ForegroundColor Red
  Write-Host $_.ScriptStackTrace

  exit 1
}

Write-Host ''
Write-Host '==> summary' -ForegroundColor Cyan
$results | Format-Table -AutoSize | Out-String | Write-Host

$failed = @($results | Where-Object { -not $_.Passed })

if ($failed.Count -gt 0) {
  Write-Host "$($failed.Count) file(s) failed:" -ForegroundColor Red
  $failed | ForEach-Object { Write-Host "  $($_.File)" -ForegroundColor Red }

  exit 1
}

Write-Host "All $($results.Count) test files passed." -ForegroundColor Green

exit 0
