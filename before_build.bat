echo ON

dir

if not "%RECIPE%"=="" (
	dir ..\conda\%RECIPE%
	if exist ..\conda\%RECIPE%\appveyor-ci.patch (
		echo apply
		git apply -v ..\conda\%RECIPE%\appveyor-ci.patch
		if errorlevel neq 0 exit /b 1
	)
)

echo OFF
