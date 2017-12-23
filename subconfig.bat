if "%ANACONDA_UPLOAD%" == "statiskit" if not "%REAL_ANACONDA_LABEL%" == "release" if not "%REAL_ANACONDA_LABEL%" == "unstable" (
    echo "Variable REAL_ANACONDA_LABEL set to '%REAL_ANACONDA_LABEL%' instead of 'release' or 'unstable'"
    exit 1
)
if "%ANACONDA_UPLOAD%" == "statiskit" if not "%REAL_ANACONDA_LABEL%" == "release" if not "%REAL_ANACONDA_LABEL%" == "unstable" (
    echo "Variable REAL_ANACONDA_LABEL set to '%REAL_ANACONDA_LABEL%' instead of 'release' or 'unstable'"
    exit 1
)
if "%ANACONDA_UPLOAD%" == "statiskit" if not "%REAL_ANACONDA_LABEL%" == "unstable" if not "%REAL_ANACONDA_LABEL%" == "release" (
    echo "Variable REAL_ANACONDA_LABEL set to '%REAL_ANACONDA_LABEL%' instead of 'release' or 'unstable'"
    exit 1
)

if not "%ANACONDA_UPLOAD%" == "statiskit" (
    conda config --add channels statiskit
    :: if errorlevel 1 exit 1
    conda config --add channels statiskit/label/unstable
    :: if errorlevel 1 exit 1
    conda config --add channels %ANACONDA_UPLOAD%
    :: if errorlevel 1 exit 1
    if not "%REAL_ANACONDA_LABEL%" == "main" (
      conda config --add channels %ANACONDA_UPLOAD%/label/%REAL_ANACONDA_LABEL%
      :: if errorlevel 1 exit 1
    )
) else (
    conda config --add channels statiskit 
    :: if errorlevel 1 exit 1
    if "%REAL_ANACONDA_LABEL%" == "release" (
        set REAL_ANACONDA_LABEL=win-%ARCH%_release
    )
    conda config --add channels statiskit/label/%REAL_ANACONDA_LABEL%
    :: if errorlevel 1 exit 1
)