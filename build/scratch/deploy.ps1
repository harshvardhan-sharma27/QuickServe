$tomcatBase = 'C:\Users\Harshvardhan\Downloads\apache-tomcat-10.1.52\apache-tomcat-10.1.52'
$webappSrc = 'd:\Kiran Academy\QuickServe\src\main\webapp'
$deployDir = "$tomcatBase\webapps\QuickServe"

New-Item -ItemType Directory -Force -Path $deployDir | Out-Null
Copy-Item -Recurse -Force -Path "$webappSrc\*" -Destination $deployDir

Write-Host "Deployed to: $deployDir"
Get-ChildItem $deployDir | Select-Object Name
