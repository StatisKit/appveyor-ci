echo ON

if "%ANACONDA_DEPLOY%"=="true" anaconda logout
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF