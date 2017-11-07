echo ON

set

if "%ANACONDA_DEPLOY%"=="true" (
  for /f %%i in ('conda build --old-build-string --python=%MAJOR_PYTHON_VERSION%.%MINOR_PYTHON_VERSION% ..\%CONDA_RECIPE% --output') do anaconda upload %%i --user %ANACONDA_UPLOAD% --force
  if %errorlevel% neq 0 exit /b %errorlevel%
)

echo OFF
