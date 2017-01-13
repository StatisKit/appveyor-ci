setlocal EnableDelayedExpansion
echo OFF

set ANACONDA_DEPLOY=true
if "%ANACONDA_USERNAME%"=="" set ANACONDA_DEPLOY=false
if "%ANACONDA_PASSWORD%"=="" set ANACONDA_DEPLOY=false
if "%RECIPE%"=="" set ANACONDA_DEPLOY=false

if "!ANACONDA_DEPLOY!"=="true" echo y|anaconda login --password %ANACONDA_PASSWORD% --username %ANACONDA_USERNAME%
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF