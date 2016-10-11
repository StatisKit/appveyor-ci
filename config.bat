echo ON

if "%MINICONDA%"=="" set MINICONDA="2"
if "%PLATFORM%"=="x32" if "%MINICONDA%"=="2" set CONDA=C:\Miniconda
if %errorlevel% neq 0 exit /b %errorlevel%
if "%PLATFORM%"=="x32" if "%MINICONDA%"=="3" set CONDA=C:\Miniconda3
if %errorlevel% neq 0 exit /b %errorlevel%
if "%PLATFORM%"=="x64" if "%MINICONDA%"=="2" set CONDA=C:\Miniconda-x64
if %errorlevel% neq 0 exit /b %errorlevel%
if "%PLATFORM%"=="x64" if "%MINICONDA%"=="3" set CONDA=C:\Miniconda3-x64
if %errorlevel% neq 0 exit /b %errorlevel%
set PATH=%CONDA%;%CONDA%\Scripts;%PATH%
if %errorlevel% neq 0 exit /b %errorlevel%

conda config --set always_yes yes --set changeps1 no
if %errorlevel% neq 0 exit /b %errorlevel%
for /f %%i in ('python python_version.py') DO (set PYTHON_VERSION=%%i)
if %errorlevel% neq 0 exit /b %errorlevel%
if "%MINICONDA%"=="3" if "%PYTHON_VERSION%"=="34" conda install python=3.5
if %errorlevel% neq 0 exit /b %errorlevel%
conda update -q conda
if %errorlevel% neq 0 exit /b %errorlevel%
conda info -a
if %errorlevel% neq 0 exit /b %errorlevel%
if "%MINICONDA%"=="2" conda install conda-build=2.0.2
if %errorlevel% neq 0 exit /b %errorlevel%
if "%MINICONDA%"=="3" conda install conda-build=1.21
if %errorlevel% neq 0 exit /b %errorlevel%
conda install anaconda-client
if %errorlevel% neq 0 exit /b %errorlevel%

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if %errorlevel% neq 0 exit /b %errorlevel%