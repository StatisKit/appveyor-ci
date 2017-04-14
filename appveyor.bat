echo OFF

git clone https://github.com/StatisKit/StatisKit.git
if exist StatisKit\doc\win_%INSTALL% (
  del StatisKit\doc\win_%INSTALL%
)
move $INSTALL StatisKit\doc\win_%INSTALL%
cd StatisKit
git config --global user.email %GIT_EMAIL%
git config --global user.name %GIT_NAME%
git add doc\win_%INSTALL%
git commit -a -m "Update "win_%INSTALL%" script"
echo machine github.com >>  %USERPROFILE%\_netrc
echo login %GITHUB_USERNAME% >> %USERPROFILE%\_netrc
echo password %GITHUB_PASSWORD% >>  %USERPROFILE%\_netrc
git push

echo OFF
