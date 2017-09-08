
git clone https://github.com/StatisKit/install-binaries.git --depth=1
if "%PLATFORM%" == "x86" (
  set WIN=32
) else (
  set WIN=64
)

if not exist install-binaries\win mkdir install-binaries\win
if not exist install-binaries\win\%WIN% mkdir install-binaries\win\%WIN%
if not exist install-binaries\win\%WIN%\PY%PYTHON_VERSION% mkdir install-binaries\win\%WIN%\PY%PYTHON_VERSION%

if exist install-binaries\win\%WIN%\PY%PYTHON_VERSION%\%INSTALL%_install.exe (
  del install-binaries\win\%WIN%\PY%PYTHON_VERSION%\%INSTALL%_install.exe
)

move %INSTALL%_install.exe install-binaries\win\%WIN%\PY%PYTHON_VERSION%\%INSTALL%_install.exe
cd install-binaries
git config --global user.email %GIT_EMAIL%
git config --global user.name %GIT_NAME%
git add win\%WIN%\PY%PYTHON_VERSION%\%INSTALL%_install.exe
git commit -m "Update win/"%WIN%"/PY"%PYTHON_VERSION%"/"%INSTALL%"_install.exe script"
echo OFF

echo machine github.com >>  %USERPROFILE%\_netrc
echo login %GITHUB_USERNAME% >> %USERPROFILE%\_netrc
echo password %GITHUB_PASSWORD% >>  %USERPROFILE%\_netrc
git push

echo OFF
