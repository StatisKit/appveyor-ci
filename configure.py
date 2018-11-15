import os
import sys

if sys.version_info[0] == 2:
    PY2 = True
    PY3 = False
else:
    PY3 = True
    PY2 = False

if PY2:
    environ = {key : value for key, value in os.environ.iteritems() if value}
else:
    environ = {key : value for key, value in os.environ.items() if value}

def get_appveyor_scheduled_build():
    return "False"

def get_appveyor_repo_branch():
    return "master"

def get_ci():
    return "False"

def get_arch():
    if sys.maxsize > 2**32:
        return "x86_64"
    else:
        return "x86"

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
    if "APPVEYOR_SCHEDULED_BUILD" in environ and environ["APPVEYOR_SCHEDULED_BUILD"] == "True":
        return "cron"
    else:
        return "develop"

def get_jupyter_kernel():
    return "python" + environ["CONDA_VERSION"]

def get_python_version():
    return environ["CONDA_VERSION"]

def get_anaconda_force():
    if environ["ANACONDA_LABEL"] == "release" and environ["APPVEYOR_REPO_BRANCH"] == "master":
        return "False"
    else:
        return "True"

def get_test_level():
    if environ["CI"] == "True":
        return "1"
    else:
        return "3"

def get_old_build_string():
    if environ["ANACONDA_FORCE"] == "True":
        return "True"
    else:
        return "False"    

def get_anaconda_tmp_label():
    if environ["ANACONDA_LABEL"] == "release":
        return "win-" + environ["ARCH"] + "_release"
    else:
        return environ["ANACONDA_LABEL"]

def get_conda_prefix():
    return "\%HOMEPATH\%\\miniconda"

def main():
    for key in ["APPVEYOR_SCHEDULED_BUILD",
                "APPVEYOR_REPO_BRANCH",
                "CI",
                "ARCH",
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
                "ANACONDA_TMP_LABEL"]:
        if key not in environ:
            value = eval("get_" + key.lower() + "()")
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
        if environ["APPVEYOR_SCHEDULED_BUILD"] == "True":
            environ["ANACONDA_LABEL"] = "cron"
        else:
            environ["ANACONDA_LABEL"] = "main"
    if environ["ANACONDA_FORCE"] == "True":
        environ["ANACONDA_FORCE"] = "--force"
    else:
        environ["ANACONDA_FORCE"] = ""
    if environ["OLD_BUILD_STRING"] == "True":
        environ["OLD_BUILD_STRING"] = "--old-build-string"
    else:
        environ["OLD_BUILD_STRING"] = ""
    with open("configure.bat", "w") as filehandler:
        filehandler.write("echo ON\n\n")
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
        filehandler.write("\necho OFF")

if __name__ == "__main__":
    main()