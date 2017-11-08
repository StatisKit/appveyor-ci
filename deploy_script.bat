echo ON

if "%ANACONDA_DEPLOY%" == "true" (
    if not "%CONDA_RECIPE%" == "" (
        for /f %%i in ('conda build --old-build-string --python=%MAJOR_PYTHON_VERSION%.%MINOR_PYTHON_VERSION% ..\%CONDA_RECIPE% --output') do anaconda upload %%i --user %ANACONDA_UPLOAD% --force --label %ANACONDA_LABEL%
        if errorlevel 1 exit 1
    )
)

echo OFF
