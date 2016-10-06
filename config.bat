echo ON

set PATH=C:\Miniconda-x64;C:\Miniconda-x64\Scripts;%PATH%
if %errorlevel% neq 0 exit /b %errorlevel%

conda update -q conda
if %errorlevel% neq 0 exit /b %errorlevel%
conda info -a
if %errorlevel% neq 0 exit /b %errorlevel%
conda install conda-build=1.21
if %errorlevel% neq 0 exit /b %errorlevel%

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if %errorlevel% neq 0 exit /b %errorlevel%