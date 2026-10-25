$ErrorActionPreference = "Stop"
$projectRoot = "d:\Kiran Academy\QuickServe"
$classesDir = "$projectRoot\build\classes"
$webInfClasses = "$projectRoot\src\main\webapp\WEB-INF\classes"

if (!(Test-Path $classesDir)) { New-Item -ItemType Directory -Force -Path $classesDir | Out-Null }
if (!(Test-Path $webInfClasses)) { New-Item -ItemType Directory -Force -Path $webInfClasses | Out-Null }

$tomcatLib = "C:\Users\Harshvardhan\Downloads\apache-tomcat-10.1.52\apache-tomcat-10.1.52\lib\*"
$webLib = "$projectRoot\src\main\webapp\WEB-INF\lib\*"
$cp = "$tomcatLib;$webLib"

$sourceFiles = (Get-ChildItem -Path "$projectRoot\src\main\java" -Filter "*.java" -Recurse).FullName
$quotedFiles = $sourceFiles | ForEach-Object { '"' + $_.Replace('\', '/') + '"' }
$sourcesFile = "$projectRoot\sources.txt"
[System.IO.File]::WriteAllLines($sourcesFile, $quotedFiles, [System.Text.Encoding]::ASCII)

Write-Host "Compiling Java files..."
& javac -encoding UTF-8 -d $classesDir -cp $cp "@$sourcesFile"
if ($LASTEXITCODE -eq 0) {
    Write-Host "BUILD SUCCESSFUL!"
    Copy-Item -Path "$classesDir\*" -Destination $webInfClasses -Recurse -Force
    Write-Host "Copied classes to WEB-INF/classes"
} else {
    Write-Error "BUILD FAILED"
}
Remove-Item -Path $sourcesFile -Force -ErrorAction SilentlyContinue
