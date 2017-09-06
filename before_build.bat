echo ON

if not "%CONDA_RECIPE%" == "" (
	if exist ..\bin\conda\%CONDA_RECIPE%\appveyor-ci.patch (
		cd ..\bin\conda\%CONDA_RECIPE%
		git apply -v appveyor-ci.patch
		if errorlevel neq 0 exit /b 1
		cd ..\..\..\appveyor-ci
	)
)

if not "%CONDA_ENVIRONMENT%" == "" (
	conda env create -f ..\environment.yml
	activate %CONDA_ENVIRONMENT%
)

echo OFF
