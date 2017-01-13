echo ON

if "%MINICONDA%"=="" set MINICONDA=2

rmdir %SystemDrive%\miniconda /s /Q

if "%PLATFORM%"=="x32" if "%MINICONDA%"=="2" curl https://repo.continuum.io/miniconda/Miniconda2-latest-Windows-x86.exe -o miniconda.exe
if %errorlevel% neq 0 exit /b %errorlevel%
if "%PLATFORM%"=="x32" if "%MINICONDA%"=="3" curl https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86.exe -o miniconda.exe
if %errorlevel% neq 0 exit /b %errorlevel%
if "%PLATFORM%"=="x64" if "%MINICONDA%"=="2" curl https://repo.continuum.io/miniconda/Miniconda2-latest-Windows-x86_64.exe -o miniconda.exe
if %errorlevel% neq 0 exit /b %errorlevel%
if "%PLATFORM%"=="x64" if "%MINICONDA%"=="3" curl https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe -o miniconda.exe
if %errorlevel% neq 0 exit /b %errorlevel%
dir
start /wait "" miniconda.exe /InstallationType=JustMe /RegisterPython=0 /S /D=%SystemDrive%\miniconda
if %errorlevel% neq 0 exit /b %errorlevel%
set PATH=%SystemDrive%\miniconda;%SystemDrive%\miniconda\Scripts;%PATH%
call %SystemDrive%\miniconda\Scripts\activate.bat root
if %errorlevel% neq 0 exit /b %errorlevel%

conda config --set always_yes yes --set changeps1 no
if %errorlevel% neq 0 exit /b %errorlevel%
conda update -q conda
if %errorlevel% neq 0 exit /b %errorlevel%
for /f %%i in ('python python_version.py') DO (set PYTHON_VERSION=%%i)
if %errorlevel% neq 0 exit /b %errorlevel%
conda info -a
if %errorlevel% neq 0 exit /b %errorlevel%
conda install conda-build
if %errorlevel% neq 0 exit /b %errorlevel%
conda install anaconda-client
if %errorlevel% neq 0 exit /b %errorlevel%

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF