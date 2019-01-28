import os
import shutil
import platform
import sys
import subprocess
import datetime

if sys.version_info[0] == 2:
    DEVNULL = open(os.devnull, 'wb')
    PY2 = True
    PY3 = False
    environ = {key : value for key, value in os.environ.iteritems() if value}
else:
    from subprocess import DEVNULL
    PY3 = True
    PY2 = False
    environ = {key : value for key, value in os.environ.items() if value}

def get_arch():
    return "x86_64"

def get_git_skip():
    return "False"

def get_conda_version():
    if "PYTHON_VERSION" in environ:
        return environ["PYTHON_VERSION"].split(".")[0]
    else:
        return "3"

def get_anaconda_owner():
    if "ANACONDA_LOGIN" in environ:
        return environ["ANACONDA_LOGIN"]

def get_anaconda_deploy():
    return environ["CI"]

def get_anaconda_release():
    return "False"

def get_anaconda_label():
    return "main"

def get_jupyter_kernel():
    return "python" + environ["CONDA_VERSION"]

def get_python_version():
    return environ["CONDA_VERSION"]

def get_anaconda_force():
    return "True"

def get_test_level():
    if environ["CI"] == "True":
        return "1"
    else:
        return "3"

def get_old_build_string():
    return "True"
    
def get_anaconda_tmp_label():
    if environ["ANACONDA_LABEL"] == "release":
        return "win-" + environ["ARCH"] + "_release"
    else:
        return environ["ANACONDA_LABEL"]

def get_conda_prefix():
    return "%SYSTEMDRIVE%\\miniconda"
    
def get_conda_feature():
    if environ['ANACONDA_FORCE'] == "True":
        return "unstable"
    else:
        return "stable"

def get_appveyor_commit_message():
    try:
        if PY2:
            return subprocess.check_output(['git', '-C', '..', 'log', '-1', '--pretty=%B']).splitlines()[0]
        else:
            return subprocess.check_output(['git', '-C', '..', 'log', '-1', '--pretty=%B']).splitlines()[0].decode()
    except:
        return "no commit message found"

def set_git_describe_version():
    try:
        if PY2:
            return subprocess.check_output(['git', '-C', '..', 'describe', '--tags']).splitlines()[0].split("-")[0].strip('v')
        else:
            return subprocess.check_output(['git', '-C', '..', 'describe', '--tags']).splitlines()[0].decode().split("-")[0].strip('v')
    except:
        return "0.1.0"

def set_git_describe_number():
    try:
        if PY2:
            output = subprocess.check_output(['git', '-C', '..', 'describe', '--tags'], stderr=DEVNULL).splitlines()[0].split('-')
        else:
            output = subprocess.check_output(['git', '-C', '..', 'describe', '--tags'], stderr=DEVNULL).splitlines()[0].decode().split('-')
        if len(output) == 4:
            return output[2]
        elif len(output) == 3:
            return output[1]
        else:
            raise ValueError()
    except:
        try:
            if PY2:
                return subprocess.check_output(['git', '-C', '..', 'rev-list', 'HEAD', '--count']).splitlines()[0]
            else:
                return subprocess.check_output(['git', '-C', '..', 'rev-list', 'HEAD', '--count']).splitlines()[0].decode()
        except:
            return "0"

def set_datetime_describe_version():
    now = datetime.datetime.now()
    return str(now.year % 2000) + "." + str(now.month).rjust(2, '0')  + "." + str(now.day).rjust(2, '0')

def set_datetime_describe_number():
    if 'APPVEYOR_BUILD_NUMBER' in environ:
        return environ['APPVEYOR_BUILD_NUMBER']
    else:
        now = datetime.datetime.now()
        return str(now.hour).rjust(2, '0')

def set_conda_recipe():
    if "CONDA_RECIPE" in environ:
        return ("../" + environ["CONDA_RECIPE"]).replace("/", os.sep)

def set_docker_context():
    if "DOCKER_CONTEXT" in environ:
        return ("../" + environ["DOCKER_CONTEXT"]).replace("/", os.sep)

def set_jupyter_notebook():
    if "JUPYTER_NOTEBOOK" in environ:
        return ("../" + environ["JUPYTER_NOTEBOOK"]).replace("/", os.sep)

def main():
    for key in ["ARCH",
                "CONDA_VERSION",
                "ANACONDA_LABEL",
                "ANACONDA_OWNER",
                "ANACONDA_DEPLOY",
                "ANACONDA_RELEASE",
                "JUPYTER_KERNEL",
                "PYTHON_VERSION",
                "ANACONDA_FORCE", 
                "TEST_LEVEL",
                "OLD_BUILD_STRING",
                "ANACONDA_TMP_LABEL",
                "CONDA_PREFIX",
                "CONDA_FEATURE",
                "APPVEYOR_COMMIT_MESSAGE"]:
        if key not in environ:
            value = eval("get_" + key.lower() + "()")
            if value:
                environ[key] = value
    for key in ["CONDA_RECIPE",
                "JUPYTER_NOTEBOOK",
                "GIT_DESCRIBE_VERSION",
                "GIT_DESCRIBE_NUMBER",
                "DATETIME_DESCRIBE_VERSION",
                "DATETIME_DESCRIBE_NUMBER"]:
        value = eval("set_" + key.lower() + "()")
        if value:
            environ[key] = value
    ANACONDA_CHANNELS = []
    if "ANACONDA_OWNER" in environ:
        ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"])
        if not environ["ANACONDA_LABEL"] == "main":
            if not environ["ANACONDA_LABEL"] == "develop":
                ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/develop")
            ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/" + environ["ANACONDA_LABEL"])
        if not environ["ANACONDA_TMP_LABEL"] == environ["ANACONDA_LABEL"]:
            ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/" + environ["ANACONDA_TMP_LABEL"])
    environ["ANACONDA_CHANNELS"] = ""
    for ANACONDA_CHANNEL in list(reversed(environ.get("ANACONDA_CHANNELS", "").split(" "))) + ANACONDA_CHANNELS:
        if ANACONDA_CHANNEL:
            environ["ANACONDA_CHANNELS"] += " --add channels " + ANACONDA_CHANNEL
    if environ["ANACONDA_LABEL"] == "release":
        environ["ANACONDA_LABEL"] = "main"
    if environ["ANACONDA_FORCE"] == "True":
        environ["ANACONDA_FORCE"] = "--force"
    else:
        environ["ANACONDA_FORCE"] = ""
    if environ["OLD_BUILD_STRING"] == "True":
        environ["OLD_BUILD_STRING"] = "--old-build-string"
    else:
        environ["OLD_BUILD_STRING"] = ""
    with open("environ.bat", "w") as filehandler:
        if PY2:
            for key, value in environ.iteritems():
                if key not in os.environ or not os.environ[key] == environ[key]:
                    filehandler.write("set " + key + "=" + value.strip() + "\n")
                    filehandler.write("if errorlevel 1 exit 1\n")
        else:
            for key, value in environ.items():
                if key not in os.environ or not os.environ[key] == environ[key]:
                    filehandler.write("set " + key + "=" + value.strip() + "\n")
                    filehandler.write("if errorlevel 1 exit 1\n")
        filehandler.write("set \"PATH=%CONDA_PREFIX%;%CONDA_PREFIX%\\Scripts;%PATH%\"\n")

if __name__ == "__main__":
    main()