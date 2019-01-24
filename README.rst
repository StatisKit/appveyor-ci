.. Copyright [2017-2018] UMR MISTEA INRA, UMR LEPSE INRA,                ..
..                       UMR AGAP CIRAD, EPI Virtual Plants Inria        ..
..                                                                       ..
.. This file is part of the StatisKit project. More information can be   ..
.. found at                                                              ..
..                                                                       ..
..     http://autowig.rtfd.io                                            ..
..                                                                       ..
.. The Apache Software Foundation (ASF) licenses this file to you under  ..
.. the Apache License, Version 2.0 (the "License"); you may not use this ..
.. file except in compliance with the License. You should have received  ..
.. a copy of the Apache License, Version 2.0 along with this file; see   ..
.. the file LICENSE. If not, you may obtain a copy of the License at     ..
..                                                                       ..
..     http://www.apache.org/licenses/LICENSE-2.0                        ..
..                                                                       ..
.. Unless required by applicable law or agreed to in writing, software   ..
.. distributed under the License is distributed on an "AS IS" BASIS,     ..
.. WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       ..
.. mplied. See the License for the specific language governing           ..
.. permissions and limitations under the License.                        ..

appveyor-ci: Tools for Using Conda in AppVeyor CI
=================================================

This collection of scripts for **AppVeyor CI** can be used with the following :code:`appveyor.yml` file:

.. code-block:: yaml

    platform:
      - x86
      - x64

    environment:
      matrix:
        # Add here environement variables to control the AppVeyor CI build

    install:
      - git clone https://github.com/StatisKit/appveyor-ci.git appveyor-ci
      - cd appveyor-ci
      - call install.bat

    before_build:
      - call before_build.bat

    build_script:
      - call build_script.bat

    after_build:
      - call after_build.bat

    deploy:
      provider: Script
      on:
        branch: master

    before_deploy:
      - call before_deploy.bat

    deploy_script:
      - call deploy_script.bat

    after_deploy:
      - call after_deploy.bat

    on_success:
      - call on_success.bat

    on_failure:
      - call on_failure.bat

    on_finish:
      - call on_finish.bat

In the :code:`matrix` section of the :code:`environment` section, you can use the following environement variables to control the **Appveyor CI** build:
  
* :code:`CONDA_VERSION` equal to :code:`2` (default) or :code:`3`.
  Control the **Conda** version used for the build.
    
If you want to:

* Build a **Conda** recipe, you should define these environment variables:

  * :code:`CONDA_RECIPE`.
    The path to the **Conda** recipe to build.
    This path must be relative to the repository root.
  * :code:`ANACONDA_LOGIN` (optional).
    The usename used to connect to the **Anaconda Cloud** in order to upload the **Conda** recipe built.
  * :code:`ANACONDA_PASSWORD` (optional).
    The usename's password used to connect to the **Anaconda Cloud** in order to upload the **Conda** recipe built.
  * :code:`ANACONDA_OWNER` (optional).
    The channel used to upload the **Conda** recipe built.
    If not given, it is set to the :code:`ANACONDA_LOGIN` value.
  * :code:`ANACONDA_DEPLOY` (optional).
    Deployment into the **Anaconda Cloud**.
    If set to :code:`true` (default if :code:`ANACONDA_LOGIN` is provided), the **Conda** recipe built will be deployed in the **Anaconda Cloud**.
    If set to :code:`false` (default if :code:`ANACONDA_LOGIN` is not provided), the **Conda** recipe built will not be deployed in the **Anaconda Cloud**.
  * :code:`ANACONDA_LABEL` equal to :code:`main` by default.
    Label to associate to the **Conda** recipe deployed in the **Anaconda Cloud**.
    
* Run a **Jupyter** notebook, you should define these environment  variables:

  * :code:`JUPYTER_NOTEBOOK`.
    The path to the **Jupyter** notbook to run.
    This path must be relative to the repository root.
  * :code:`CONDA_ENVIRONMENT`.
    The path to the **Conda** environment to use when runnning the **Jupyter** notebook.
    
.. note::

   It is recommanded to define the environment variables :code:`ANACONDA_LOGIN` (resp. :code:`DOCKER_LOGIN`), :code:`ANACONDA_PASSWORD` (resp. :code:`DOCKER_PASSWORD`) and :code:`ANACONDA_OWNER` (resp. :code:`DOCKER_OWNER`) in the :code:`Settings` pannel of **Travis CI** instead of in the :code:`appveyor.yml`.
 
