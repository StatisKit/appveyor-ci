echo ON

if not "%CONDA_RECIPE%"=="" conda build --old-build-string --python=%MAJOR_PYTHON_VERSION%.%MINOR_PYTHON_VERSION% ..\bin\conda\%CONDA_RECIPE% -c statiskit -c conda-forge
if not "%JUPYTER_NOTEBOOK%"=="" (
  if not "%CONDA_ENVIRONMENT%"=="" (
    activate %CONDA_ENVIRONMENT%
  )
  jupyter nbconvert --ExecutePreprocessor.timeout=3600 --to notebook --execute ..\share\jupyter\%JUPYTER_NOTEBOOK% --output %JUPYTER_NOTEBOOK%
)
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF
