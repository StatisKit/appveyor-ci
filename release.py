import requests
import json
import os

headers = {"Content-Type": "application/json"}
url = "https://ci.appveyor.com/api/projects/" + os.environ["APPVEYOR_ACCOUNT_NAME"] + "/" + os.environ["APPVEYOR_PROJECT_SLUG"] + "/build/" + os.environ["APPVEYOR_BUILD_VERSION"]
status = requests.get(url, headers=headers).json()

APPVEYOR_JOB_NUMBER = int(os.environ["APPVEYOR_JOB_NUMBER"])
ARCH = os.environ["ARCH"]
if ARCH == 'x86_64':
    ARCH = 'x64'
    
if all("Platform: " in job["name"] for job in status['build']['jobs']):
    for job in status['build']['jobs'][:APPVEYOR_JOB_NUMBER]:
        if not job["allowFailure"] and "Platform: " + ARCH in job["name"] and job["status"] == 'failed':
            raise Exception("A previous job failed !")
else:
    for job in status['build']['jobs'][:APPVEYOR_JOB_NUMBER]:
        if not job["allowFailure"] and job["status"] == 'failed':
            raise Exception("A previous job failed !")
