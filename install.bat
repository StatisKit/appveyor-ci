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

:: set CONDA_PIN=4.3.30
:: set CONDA_BUILD_PIN=3.0.30
:: set ANACONDA_CLIENT_PIN=1.6.5

git -C %APPVEYOR_BUILD_FOLDER% submodule update --init --recursive

if "%CONDA_VERSION%" == "" (
  set CONDA_VERSION=2
)

if not "%ANACONDA_LOGIN%" == "" (
  if "%ANACONDA_OWNER%" == "" (
    set ANACONDA_OWNER=%ANACONDA_LOGIN%
  )
)

if "%ANACONDA_DEPLOY%" == "" (
    if not "%ANACONDA_LOGIN%" == "" (
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

if "%JUPYTER_KERNEL%" == "" (
  if "%CONDA_VERSION%" == "" (
    set JUPYTER_KERNEL=python2
  ) else (
    set JUPYTER_KERNEL=python%CONDA_VERSION%
  )
)


if "%CI%" == "True" rmdir /s /q C:\Miniconda
if errorlevel 1 exit 1
curl https://repo.continuum.io/miniconda/Miniconda%CONDA_VERSION%-latest-Windows-%ARCH%.exe -o miniconda.exe
if errorlevel 1 exit 1
miniconda.exe /AddToPath=1 /InstallationType=JustMe /RegisterPython=0 /S /D=%HOMEDRIVE%\Miniconda 
if errorlevel 1 exit 1
del miniconda.exe
if errorlevel 1 exit 1
set PATH=%HOMEDRIVE%\Miniconda;%HOMEDRIVE%\Miniconda\Scripts;%PATH%
if errorlevel 1 exit 1
call %HOMEDRIVE%\Miniconda\Scripts\activate.bat
if not "%ANACONDA_CHANNELS%"=="" (
  conda config --add channels %ANACONDA_CHANNELS%
  if errorlevel 1 exit 1
)
conda config --set always_yes yes
if errorlevel 1 exit 1
conda config --set remote_read_timeout_secs 600
if errorlevel 1 exit 1
conda config --set auto_update_conda False
if errorlevel 1 exit 1

if not "%CONDA_PIN%" == "" conda install conda=%CONDA_PIN%
if not "%CONDA_BUILD_PIN%" == "" (
  conda install conda-build=%CONDA_BUILD_PIN% 
) else (
  conda install conda-build
)

if errorlevel 1 exit 1
call %HOMEDRIVE%\Miniconda\Scripts\activate.bat
if errorlevel 1 exit 1

call config.bat
if errorlevel 1 exit 1

if "%CI%" == "True" (
  python release.py
  if errorlevel 1 exit 1
)

if not "%CI%" == "True" (
    conda create -n py%CONDA_VERSION%k python=%CONDA_VERSION%
    if errorlevel 1 exit 1
    call %HOMEDRIVE%\Miniconda\Scripts\activate.bat activate py%CONDA_VERSION%k
)
if not "%ANACONDA_CLIENT_PIN%" == "" (
    conda install anaconda-client=$ANACONDA_CLIENT_PIN
    if errorlevel 1 exit 1
) else (
    conda install anaconda-client
    if errorlevel 1 exit 1
)
for /f %%i in ('python major_python_version.py') DO (set MAJOR_PYTHON_VERSION=%%i)
if errorlevel 1 exit 1

for /f %%i in ('python minor_python_version.py') DO (set MINOR_PYTHON_VERSION=%%i)
if errorlevel 1 exit 1

set PYTHON_VERSION=%MAJOR_PYTHON_VERSION%.%MINOR_PYTHON_VERSION%

set CMD_IN_ENV=cmd /E:ON /V:ON /C %cd%\\cmd_in_env.cmd
if errorlevel 1 exit 1

if not "%CONDA_PACKAGES%" == "" (
  conda install %CONDA_PACKAGES%
  if errorlevel 1 exit 1
  call %HOMEDRIVE%\Miniconda\Scripts\activate.bat
  if errorlevel 1 exit 1
)

call post_config.bat
if errorlevel 1 exit 1

echo OFF
