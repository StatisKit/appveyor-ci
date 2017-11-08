echo ON

if not "%CONDA_ENVIRONMENT%" == "" (
    conda create -n appveyor-ci python=%CONDA_VERSION%
    if errorlevel 1 exit 1
    activate appveyor-ci 
    if errorlevel 1 exit 1
    conda env update -f ..\%CONDA_ENVIRONMENT%
    if errorlevel 1 exit 1
    activate appveyor-ci
    if errorlevel 1 exit 1
)

echo OFF
