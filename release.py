import requests
import json
import os

headers = {"Content-Type": "application/json"}
url = "https://ci.appveyor.com/api/projects/" + os.environ["APPVEYOR_PROJECT_SLUG"] + "/build/" + os.environ["APPVEYOR_BUILD_VERSION"] + "." + os.environ["APPVEYOR_BUILD_NUMBER"]
print(url)
status = requests.get(url, headers=headers).json()

APPVEYOR_JOB_NUMBER = int(os.environ["APPVEYOR_JOB_NUMBER"])
ARCH = os.environ["ARCH"]

for job in status['build']['jobs'][:APPVEYOR_JOB_NUMBER]:
    if not job["allowFailure"] and "Platform: " + ARCH in job["name"] and job["status"] == 'failed':
        raise Exception("A previous job failed !")
