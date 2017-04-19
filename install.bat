echo ON

if "%PLATFORM%" == "x86" (
  set ARCH=32
) else (
  set ARCH=64
)
rmdir /s /q C:\Miniconda
if errorlevel 1 exit 1
curl https://raw.githubusercontent.com/StatisKit/StatisKit/master/doc/win/%ARCH%/developer_install.exe -o developer_install.exe
if errorlevel 1 exit 1
developer_install.exe --prepend-path=no --configure-only=yes --prefix=%HOMEDRIVE%\Miniconda
if errorlevel 1 exit 1
del developer_install.exe
if errorlevel 1 exit 1
set PATH=%HOMEDRIVE%\Miniconda;%HOMEDRIVE%\Miniconda\Scripts;%PATH%
if errorlevel 1 exit 1

for /f %%i in ('python python_version.py') DO (set PYTHON_VERSION=%%i)
if errorlevel 1 exit 1

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if errorlevel 1 exit 1

echo OFF
