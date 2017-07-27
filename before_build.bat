echo ON

if not "%RECIPE%"=="" (
	if exist ..\bin\%RECIPE%\appveyor-ci.patch (
		cd ..
		git apply -v bin\%RECIPE%\appveyor-ci.patch
		if errorlevel neq 0 exit /b 1
		cd appveyor-ci
	)
)

if not "%CONDA_ENVIRONMENT%"== "" (
	conda env create -f ..\environment.yml
	activate $CONDA_ENVIRONMENT
)

echo OFF
