@echo off

set "JAVA_HOME=C:\Program Files\Java\jdk-25"
set "CATALINA_HOME=C:\Users\Harshvardhan\Downloads\apache-tomcat-10.1.52\apache-tomcat-10.1.52"

cd /d "%CATALINA_HOME%\bin"

echo Starting QuickServe Tomcat...
call catalina.bat run

pause