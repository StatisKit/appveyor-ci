setlocal EnableDelayedExpansion
echo ON

if not exist ANACONDA_DEPLOY (
  if exist CONDA_RECIPE (
    set ANACONDA_DEPLOY=true
    if "%ANACONDA_USERNAME%"=="" set ANACONDA_DEPLOY=false
    if "%ANACONDA_PASSWORD%"=="" set ANACONDA_DEPLOY=false
  )
)

echo !ANACONDA_DEPLOY!

if "!ANACONDA_DEPLOY!"=="true" (
  echo y|anaconda login --password %ANACONDA_PASSWORD% --username %ANACONDA_USERNAME%
  if %errorlevel% neq 0 exit /b %errorlevel%
  type NUL > ANACONDA_DEPLOY
  if %errorlevel% neq 0 exit /b %errorlevel%
)

echo OFF
