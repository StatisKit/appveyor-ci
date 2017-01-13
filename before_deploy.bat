setlocal EnableDelayedExpansion
echo OFF

echo 0
set ANACONDA_DEPLOY=true
echo 1
if "%ANACONDA_USERNAME%"=="" set ANACONDA_DEPLOY=false
echo 2
if "%ANACONDA_PASSWORD%"=="" set ANACONDA_DEPLOY=false
echo 3
if "%RECIPE%"=="" set ANACONDA_DEPLOY=false
echo 4

if "!ANACONDA_DEPLOY!"=="true" echo y|anaconda login --password %ANACONDA_PASSWORD% --username %ANACONDA_USERNAME%
if %errorlevel% neq 0 exit /b %errorlevel%
echo 5

echo OFF