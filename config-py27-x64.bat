echo ON

set PATH=C:\Miniconda-x64;C:\Miniconda-x64\Scripts;%PATH%
if %errorlevel% neq 0 exit /b %errorlevel%

call config-conda.bat

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if %errorlevel% neq 0 exit /b %errorlevel%