set TEST_LEVEL=1
if errorlevel 1 exit 1
conda config --set always_yes yes
if errorlevel 1 exit 1
conda config --add channels r
if errorlevel 1 exit 1
conda config --add channels statiskit
if errorlevel 1 exit 1
if not "%ANACONDA_UPLOAD%" == "statiskit" (
    conda config --add channels statiskit/label/unstable
    if errorlevel 1 exit 1
    conda config --add channels %ANACONDA_UPLOAD%
    if errorlevel 1 exit 1
    if not "%ANACONDA_LABEL%" == "main" (
      conda config --add channels %ANACONDA_UPLOAD%/label/%ANACONDA_LABEL%
      if errorlevel 1 exit 1
    )
) else (
    if not "%ANACONDA_LABEL%" == "main" (
      conda config --add channels statiskit/label/%ANACONDA_LABEL%
      if errorlevel 1 exit 1
    )
)
