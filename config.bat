set TEST_LEVEL=1
conda config --set always_yes yes
conda config --add channels r
conda config --add channels statiskit
if not "%ANACONDA_UPLOAD%" == "statiskit" (
  conda config --add channels %ANACONDA_UPLOAD%
)
