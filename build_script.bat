echo ON

if not "%RECIPE%"=="" conda build ..\conda\%RECIPE% -c statiskit -c conda-forge
if not "%NOTEBOOK%"=="" jupyter nbconvert --ExecutePreprocessor.timeout=3600 --to notebook --execute ..\jupyter\%NOTEBOOK% --output ..\jupyter\%NOTEBOOK%

if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF
