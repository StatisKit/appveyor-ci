echo OFF

if "%ANACONDA_DEPLOY%" == "true" (
    echo y|anaconda login --password %ANACONDA_PASSWORD% --username %ANACONDA_USERNAME%
    if errorlevel 1 exit 1
)

echo OFF
