echo OFF

git clone https://github.com/StatisKit/StatisKit.git
if exist StatisKit\doc\win_%INSTALL%.exe (
  del StatisKit\doc\win_%INSTALL%.exe
)
if "%PLATFORM%" == "x86" (
  set WIN=32
) else (
  set WIN=64
)
move %INSTALL%.exe StatisKit\doc\win%WIN%_%INSTALL%.exe
cd StatisKit
git config --global user.email %GIT_EMAIL%
git config --global user.name %GIT_NAME%
dir doc
git add doc\win%WIN%_%INSTALL%.exe
git commit -a -m "Update "win%WIN%_%INSTALL%".exe script"
echo machine github.com >>  %USERPROFILE%\_netrc
echo login %GITHUB_USERNAME% >> %USERPROFILE%\_netrc
echo password %GITHUB_PASSWORD% >>  %USERPROFILE%\_netrc
git push

echo OFF
