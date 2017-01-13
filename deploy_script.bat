echo ON

set

if "%ANACONDA_DEPLOY%"=="true" (
  for /f %%i in ('conda build ..\conda\%RECIPE% -c statiskit -c conda-forge --output') do anaconda upload %%i --user statiskit
  if %errorlevel% neq 0 exit /b %errorlevel%
)

echo OFF