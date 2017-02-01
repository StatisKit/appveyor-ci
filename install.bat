echo ON

set BATCH_MODE=true
set ENVIRONMENT=false
curl https://raw.githubusercontent.com/StatisKit/StatisKit/master/doc/developer/developer_install.bat -o developer_install.bat
if errorlevel 1 exit 1
call developer_install.bat
if errorlevel 1 exit 1
echo ON
del developer_install.bat

for /f %%i in ('python python_version.py') DO (set PYTHON_VERSION=%%i)
if errorlevel 1 exit 1

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if errorlevel 1 exit 1

echo OFF
