setlocal EnableDelayedExpansion
echo ON

if not exist ANACONDA_DEPLOY (
  if exist CONDA_RECIPE (
    if not "%ANACONDA_USERNAME%"=="" (
      if not "%ANACONDA_PASSWORD%"=="" (
        echo y|anaconda login --password %ANACONDA_PASSWORD% --username %ANACONDA_USERNAME%
        if errorlevel 1 exit 1
        set ANACONDA_DEPLOY=true
      ) else (
        set ANACONDA_DEPLOY=false
      )
    ) else (
      set ANACONDA_DEPLOY=false
    )
  ) else (
    set ANACONDA_DEPLOY=false
  )
)

echo OFF
