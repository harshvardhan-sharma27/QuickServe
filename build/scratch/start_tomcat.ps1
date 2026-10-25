$JAVA_HOME = 'C:\Program Files\Java\jdk-25'
$CATALINA_HOME = 'C:\Users\Harshvardhan\Downloads\apache-tomcat-10.1.52\apache-tomcat-10.1.52'
$env:JAVA_HOME = $JAVA_HOME
$env:CATALINA_HOME = $CATALINA_HOME
$env:JRE_HOME = $JAVA_HOME

Start-Process -FilePath "$CATALINA_HOME\bin\startup.bat" -WorkingDirectory $CATALINA_HOME -WindowStyle Minimized
Write-Host 'Tomcat startup initiated. Waiting 8 seconds...'
Start-Sleep 8

$portCheck = netstat -ano | findstr ':8080'
if ($portCheck) {
    Write-Host 'SUCCESS: Port 8080 is listening'
    Write-Host $portCheck
} else {
    Write-Host 'Port 8080 not yet open - check Tomcat logs'
}
