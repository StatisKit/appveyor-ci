echo ON

set

if exist ANACONDA_DEPLOY (
  for /f %%i in ('conda build ..\bin\%CONDA_RECIPE% -c statiskit -c conda-forge --output') do anaconda upload %%i --user statiskit --force
  if %errorlevel% neq 0 exit /b %errorlevel%
)

echo OFF