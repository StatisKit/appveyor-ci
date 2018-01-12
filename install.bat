:: Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ::
::                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ::
::                                                                       ::
:: This file is part of the StatisKit project. More information can be   ::
:: found at                                                              ::
::                                                                       ::
::     http://autowig.rtfd.io                                            ::
::                                                                       ::
:: The Apache Software Foundation (ASF) licenses this file to you under  ::
:: the Apache License, Version 2.0 (the "License"); you may not use this ::
:: file except in compliance with the License. You should have received  ::
:: a copy of the Apache License, Version 2.0 along with this file; see   ::
:: the file LICENSE. If not, you may obtain a copy of the License at     ::
::                                                                       ::
::     http://www.apache.org/licenses/LICENSE-2.0                        ::
::                                                                       ::
:: Unless required by applicable law or agreed to in writing, software   ::
:: distributed under the License is distributed on an "AS IS" BASIS,     ::
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ::
:: mplied. See the License for the specific language governing           ::
:: permissions and limitations under the License.                        ::

echo ON

set "CWD_VAR=%cd%"
cd %APPVEYOR_BUILD_FOLDER%
git submodule update --init --recursive
cd %CWD_VAR%

if "%CONDA_VERSION%" == "" (
  set CONDA_VERSION=2
)

if not "%ANACONDA_USERNAME%" == "" (
  if "%ANACONDA_UPLOAD%" == "" (
    set ANACONDA_UPLOAD=%ANACONDA_USERNAME%
  )
)

if "%ANACONDA_DEPLOY%" == "" (
    if not "%ANACONDA_USERNAME%" == "" (
        set ANACONDA_DEPLOY=true
    ) else (
        set ANACONDA_DEPLOY=false
    )
)

if "%ANACONDA_RELEASE%" == "" (
    set ANACONDA_RELEASE=false
)

if "%ANACONDA_LABEL%" == "" (
    set ANACONDA_LABEL=main
)

if "%PLATFORM%" == "x86" (
  set ARCH=x86
) else (
  set ARCH=x86_64
)

rmdir /s /q C:\Miniconda
if errorlevel 1 exit 1
curl https://repo.continuum.io/miniconda/Miniconda%CONDA_VERSION%-latest-Windows-%ARCH%.exe -o miniconda.exe
if errorlevel 1 exit 1
miniconda.exe /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%HOMEDRIVE%\Miniconda 
if errorlevel 1 exit 1
del miniconda.exe
if errorlevel 1 exit 1
set PATH=%HOMEDRIVE%\Miniconda;%HOMEDRIVE%\Miniconda\Scripts;%PATH%
if errorlevel 1 exit 1
call %HOMEDRIVE%\Miniconda\Scripts\activate.bat root
if not "%ANACONDA_CHANNELS%"=="" (
  conda config --add channels %ANACONDA_CHANNELS%
  if errorlevel 1 exit 1
)
conda config --set always_yes yes
if errorlevel 1 exit 1

conda install conda=4.3.30
if errorlevel 1 exit 1

python release.py
if errorlevel 1 exit 1

call config.bat
if errorlevel 1 exit 1

for /f %%i in ('python major_python_version.py') DO (set MAJOR_PYTHON_VERSION=%%i)
if errorlevel 1 exit 1

for /f %%i in ('python minor_python_version.py') DO (set MINOR_PYTHON_VERSION=%%i)
if errorlevel 1 exit 1

set PYTHON_VERSION=%MAJOR_PYTHON_VERSION%.%MINOR_PYTHON_VERSION%

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if errorlevel 1 exit 1

conda install conda=4.3.30 conda-build=3.0.30 anaconda-client %CONDA_PACKAGES%
if errorlevel 1 exit 1
call %HOMEDRIVE%\Miniconda\Scripts\activate.bat root
if errorlevel 1 exit 1

conda config --set remote_read_timeout_secs 600
if errorlevel 1 exit 1

anaconda config --set auto_register yes
if errorlevel 1 exit 1

call post_config.bat
if errorlevel 1 exit 1

echo OFF
