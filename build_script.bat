echo ON

if not "%RECIPE%"=="" %CMD_IN_ENV% conda build ..\conda\%RECIPE% -c statiskit -c conda-forge
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF