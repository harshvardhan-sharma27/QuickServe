$srcDir = 'd:\Kiran Academy\QuickServe\src\main\java'
$outDir = 'd:\Kiran Academy\QuickServe\src\main\webapp\WEB-INF\classes'
$libDir = 'd:\Kiran Academy\QuickServe\src\main\webapp\WEB-INF\lib'
$tomcatLib = 'C:\Users\Harshvardhan\Downloads\apache-tomcat-10.1.52\apache-tomcat-10.1.52\lib'

# Collect all .java files
$javaFiles = Get-ChildItem -Recurse -Filter '*.java' -Path $srcDir | Select-Object -ExpandProperty FullName

# Build classpath
$cpParts = @($outDir)
$cpParts += Get-ChildItem $libDir -Filter '*.jar' | Select-Object -ExpandProperty FullName
$cpParts += Get-ChildItem $tomcatLib -Filter '*.jar' | Select-Object -ExpandProperty FullName
$cpStr = $cpParts -join ';'

# Write file list to argfile to avoid command-line length limit
$argFile = 'd:\Kiran Academy\QuickServe\build\scratch\sources.txt'
New-Item -ItemType Directory -Force -Path 'd:\Kiran Academy\QuickServe\build\scratch' | Out-Null
# Write file list with Unix-style slashes (javac argfile supports them)
$javaFiles | ForEach-Object { $_.Replace('\', '/') } | Out-File -FilePath $argFile -Encoding UTF8

# Compile - javac reads argfile with one source path per line
# Need to quote paths with spaces in the argfile
$javaFiles | ForEach-Object { "`"" + $_.Replace('\', '/') + "`"" } | Out-File -FilePath $argFile -Encoding ASCII

# Compile
$result = & javac -cp "$cpStr" -d "$outDir" -encoding UTF-8 "@$argFile" 2>&1
$result | Out-String | Write-Host
Write-Host "Exit code: $LASTEXITCODE"
