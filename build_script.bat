echo ON

if not "%CONDA_RECIPE%"=="" conda build ..\bin\conda\%CONDA_RECIPE% -c statiskit -c conda-forge
if not "%JUPYTER_NOTEBOOK%"=="" jupyter nbconvert --ExecutePreprocessor.timeout=3600 --to notebook --execute ..\share\%JUPYTER_NOTEBOOK% --output ..\share\%JUPYTER_NOTEBOOK%

if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF
