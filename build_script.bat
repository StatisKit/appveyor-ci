echo ON

if not "%CONDA_RECIPE%"=="" (
  conda build --old-build-string --python=%MAJOR_PYTHON_VERSION%.%MINOR_PYTHON_VERSION% ..\%CONDA_RECIPE%
  if errorlevel 1 exit 1
)

if not "%JUPYTER_NOTEBOOK%" == "" (
  if not "%CONDA_ENVIRONMENT%" == "" (
    activate appveyor-ci
    if errorlevel 1 exit 1
  )
  jupyter nbconvert --ExecutePreprocessor.kernel_name="python%CONDA_VERSION%" --ExecutePreprocessor.timeout=0 --to notebook --execute ..\%JUPYTER_NOTEBOOK% --output ..\%JUPYTER_NOTEBOOK%
  if errorlevel 1 exit 1
)

echo OFF
