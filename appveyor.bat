echo OFF

git clone https://github.com/StatisKit/StatisKit.git
if "%PLATFORM%" == "x86" (
  set WIN=32
) else (
  set WIN=64
)
if not exist StatisKit\doc\win mkdir StatisKit\doc\win
if not exist StatisKit\doc\win\%WIN% mkdir StatisKit\doc\win\%WIN%
if exist StatisKit\doc\win\%WIN%\%INSTALL%_install.exe (
  del StatisKit\doc\win\%WIN%\%INSTALL%_install.exe
)

move %INSTALL%_install.exe StatisKit\doc\win\%WIN%\%INSTALL%_install.exe
cd StatisKit
git config --global user.email %GIT_EMAIL%
git config --global user.name %GIT_NAME%
dir doc
git add doc\win\%WIN%\%INSTALL%_install.exe
git commit -a -m "Update win/"%WIN%"/"%INSTALL%"_install.exe script"
echo machine github.com >>  %USERPROFILE%\_netrc
echo login %GITHUB_USERNAME% >> %USERPROFILE%\_netrc
echo password %GITHUB_PASSWORD% >>  %USERPROFILE%\_netrc
git push

echo OFF
