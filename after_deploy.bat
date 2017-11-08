echo ON

if "%ANACONDA_DEPLOY%" == "true" (
    anaconda logout
    if errorlevel 1 exit 1
)

echo OFF