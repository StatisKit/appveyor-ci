echo OFF

git clone https://github.com/StatisKit/StatisKit.git
if "%PLATFORM%" == "x86" (
  set WIN=32
) else (
  set WIN=64
)
if not exist StatisKit\doc\win mkdir StatisKit\doc\win
if not exist StatisKit\doc\win\%WIN% mkdir StatisKit\doc\win\%WIN%
if exist StatisKit\doc\win\%INSTALL%.exe (
  del StatisKit\doc\win\%WIN%\%INSTALL%.exe
)

move %INSTALL%.exe StatisKit\doc\win\%WIN%\%INSTALL%.exe
cd StatisKit
git config --global user.email %GIT_EMAIL%
git config --global user.name %GIT_NAME%
dir doc
git add doc\win\%WIN%\%INSTALL%.exe
git commit -a -m "Update win/"%WIN%"/"%INSTALL%".exe script"
echo machine github.com >>  %USERPROFILE%\_netrc
echo login %GITHUB_USERNAME% >> %USERPROFILE%\_netrc
echo password %GITHUB_PASSWORD% >>  %USERPROFILE%\_netrc
git push

echo OFF
