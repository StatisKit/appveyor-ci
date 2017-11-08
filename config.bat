set TEST_LEVEL=1
if errorlevel 1 exit 1
conda config --set always_yes yes
if errorlevel 1 exit 1
conda config --add channels r
if errorlevel 1 exit 1
conda config --add channels statiskit
if errorlevel 1 exit 1
if not "%ANACONDA_UPLOAD%" == "statiskit" (
    conda config --add channels %ANACONDA_UPLOAD%
    if errorlevel 1 exit 1
)