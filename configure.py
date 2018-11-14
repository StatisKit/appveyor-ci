import os
import six
import platform
import sys

if six.PY2:
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
    return "false"

def get_anaconda_label():
    if "APPVEYOR_SCHEDULED_BUILD" in environ and environ["APPVEYOR_SCHEDULED_BUILD"] == "True":
        return "cron"
    else:
        return "develop"

def get_docker_owner():
    if "DOCKER_LOGIN" in environ:
        return environ["DOCKER_LOGIN"]

def get_docker_deploy():
    if "DOCKER_LOGIN" in environ and environ["TRAVIS_OS_NAME"] == "linux":
        return environ["CI"]
    else:
        return "false"

def get_docker_container():
    if "DOCKER_CONTEXT" in environ:
        return os.path.basename(environ["DOCKER_CONTEXT"])

def get_appveyor_repo_tag_name():
    return "latest"

def get_jupyter_kernel():
    return "python" + environ["CONDA_VERSION"]

def get_python_version():
    return environ["CONDA_VERSION"]

def get_anaconda_force():
    if environ["ANACONDA_LABEL"] == "release" and environ["APPVEYOR_REPO_BRANCH"] == "master":
        return "false"
    else:
        return "true"

def get_test_level():
    if environ["CI"] == "True":
        return "1"
    else:
        return "3"

def get_old_build_string():
    if environ["ANACONDA_FORCE"] == "true":
        return "true"
    else:
        return "false"    

def get_anaconda_tmp_label():
    if environ["ANACONDA_LABEL"] == "release":
        return environ["TRAVIS_OS_NAME"] + "-" + environ["ARCH"] + "_release"
    else:
        return environ["ANACONDA_LABEL"]

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
                "DOCKER_OWNER",
                "DOCKER_CONTAINER",
                "APPVEYOR_REPO_TAG_NAME",
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
    if environ["ANACONDA_LABEL"] == "release":
        if environ["TRAVIS_EVENT_TYPE"] == "cron":
            environ["ANACONDA_LABEL"] = "cron"
        else:
            environ["ANACONDA_LABEL"] = "main"
    if environ["ANACONDA_FORCE"] == "true":
        environ["ANACONDA_FORCE"] = "--force"
    else:
        environ["ANACONDA_FORCE"] = ""
    if environ["OLD_BUILD_STRING"] == "true":
        environ["OLD_BUILD_STRING"] = "--old-build-string"
    else:
        environ["OLD_BUILD_STRING"] = ""
    ANACONDA_CHANNELS = []
    if "ANACONDA_OWNER" in environ:
        ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"])
        if not environ["ANACONDA_LABEL"] == "main":
            ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/" + environ["ANACONDA_LABEL"])
        if not environ["ANACONDA_TMP_LABEL"] == environ["ANACONDA_LABEL"]:
            ANACONDA_CHANNELS.append(environ["ANACONDA_OWNER"] + "/label/" + environ["ANACONDA_TMP_LABEL"])
    ANACONDA_CHANNELS.reverse()
    environ["ANACONDA_CHANNELS"] = " ".join(ANACONDA_CHANNELS + environ.get("ANACONDA_CHANNELS", "").split(" "))
    with open("configure.bat", "w") as filehandler:
        filehandler.write("echo ON\n\n")
        if six.PY2:
            for key, value in environ.iteritems():
                if key not in os.environ or not os.environ[key] == environ[key]:
                    filehandler.write("set " + key + "=\"" + value + "\"\n")
        else:
            for key, value in environ.items():
                if key not in os.environ or not os.environ[key] == environ[key]:
                    filehandler.write("set " + key + "=\"" + value + "\"\n")
        filehandler.write("\necho OFF")

if __name__ == "__main__":
    main()