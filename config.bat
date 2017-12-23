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

setlocal EnableDelayedExpansion
set TEST_LEVEL=1
if errorlevel 1 exit 1
rem conda config --add channels r
:: if errorlevel 1 exit 1
if "%ANACONDA_UPLOAD%" == "statiskit" (
  if "%ANACONDA_LABEL%" == "release" (
    if not "%APPVEYOR_REPO_BRANCH%" == "master" (
        set ANACONDA_LABEL_TMP=unstable
    )
  )
)
if "!ANACONDA_LABEL_TMP!" == "" (
    set ANACONDA_LABEL_TMP=%ANACONDA_LABEL%
)


if not "%ANACONDA_UPLOAD%" == "statiskit" (
    conda config --add channels statiskit
    :: if errorlevel 1 exit 1
    conda config --add channels statiskit/label/unstable
    :: if errorlevel 1 exit 1
    conda config --add channels %ANACONDA_UPLOAD%
    :: if errorlevel 1 exit 1
    if not "!ANACONDA_LABEL_TMP!" == "main" (
      conda config --add channels %ANACONDA_UPLOAD%/label/!ANACONDA_LABEL_TMP!
      :: if errorlevel 1 exit 1
    )
) else (
    conda config --add channels statiskit 
    :: if errorlevel 1 exit 1
    if "!ANACONDA_LABEL_TMP!" == "release" (
        set ANACONDA_LABEL_TMP=win-%ARCH%_release
    )
    conda config --add channels statiskit/label/!ANACONDA_LABEL_TMP!
    :: if errorlevel 1 exit 1
)

endlocal && set ANACONDA_LABEL=%ANACONDA_LABEL_TMP%