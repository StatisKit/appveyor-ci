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

if "%ANACONDA_DEPLOY%" == "true" (
    if not "%CONDA_RECIPE%" == "" (
        for /f %%i in ('conda build --old-build-string --python=%PYTHON_VERSION% ..\%CONDA_RECIPE% --output') do anaconda upload %%i --user %ANACONDA_UPLOAD% --force --label %ANACONDA_LABEL%
        if errorlevel 1 exit 1
    )
)

if "%ANACONDA_RELEASE%" == "true" (
    if "%APPVEYOR_REPO_BRANCH%" == "master" (
        if "%APPVEYOR_SCHEDULED_BUILD%" == "True" (
            anaconda label -o %ANACONDA_UPLOAD% --copy %ANACONDA_LABEL% cron
            if errorlevel 1 exit 1
        ) else (
            anaconda label -o %ANACONDA_UPLOAD% --copy %ANACONDA_LABEL% main
            if errorlevel 1 exit 1
        )
        anaconda label -o %ANACONDA_UPLOAD% --remove %ANACONDA_LABEL%
        if errorlevel 1 exit 1
    )
)

echo OFF
