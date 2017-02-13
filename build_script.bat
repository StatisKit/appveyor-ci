echo ON

if not "%RECIPE%"=="" conda build ..\conda\%RECIPE% -c statiskit -c conda-forge
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF
