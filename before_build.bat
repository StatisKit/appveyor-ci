echo ON

if not "%RECIPE%"=="" (
	if exist ..\conda\%RECIPE%\appveyor-ci.patch (
		git apply -v ..\conda\$RECIPE\appveyor-ci.patch
		if errorlevel neq 0 exit /b 1
	)
)

echo OFF