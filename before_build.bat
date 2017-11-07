echo ON

if not "%CONDA_ENVIRONMENT%" == "" (
    conda create -n appveyor-ci python=%CONDA_VERSION%
    activate appveyor-ci 
    conda env update -f ..\%CONDA_ENVIRONMENT%
    activate appveyor-ci 
)

echo OFF
