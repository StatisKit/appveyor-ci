echo ON

if exist ANACONDA_DEPLOY anaconda logout
if %errorlevel% neq 0 exit /b %errorlevel%

echo OFF