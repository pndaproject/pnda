"""
Download python packages based on requirement files
"""

import re
import time
import os
import subprocess
from os import listdir
from os.path import isfile, join

def main():

    package_path=os.environ['MIRROR_OUTPUT']+"/packages"
    requirements_path=os.environ['PYTHON_REQ_DIR']
    requirements_path_py2=requirements_path+"/python-2"
    requirements_path_py3=requirements_path+"/python-3"
    # init directory
    if not os.path.exists(package_path):
        os.makedirs(package_path)

    # download python 2 libs
    subprocess.call(["pip2","download","setuptools","--platform","multilinux1_x86_64","--python-version","27","--implementation","py","--only-binary=:all:","-d",package_path])
    subprocess.call(["pip2","download","pbr","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip2","download","pip==9.0.1","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip2","download","virtualenv==15.1.0","--no-binary",":all:","--process-dependency-links","-d",package_path])
    onlyfiles = [f for f in listdir(requirements_path_py2) if isfile(join(requirements_path_py2, f))]
    for afile in onlyfiles:
        subprocess.call(["pip2","download","-r",requirements_path_py2+"/"+afile,"--no-binary",":all:","--process-dependency-links","-d",package_path])

    # download python 3 libs
    subprocess.call(["pip3","download","setuptools","--only-binary=:all:","-d",package_path])
    subprocess.call(["pip3","download","pbr","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip3","download","pip==9.0.1","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip3","download","virtualenv==15.1.0","--no-binary",":all:","--process-dependency-links","-d",package_path])
    onlyfiles = [f for f in listdir(requirements_path_py3) if isfile(join(requirements_path_py3, f))]
    for afile in onlyfiles:
        subprocess.call(["pip3","download","-r",requirements_path_py3+"/"+afile,"--process-dependency-links","-d",package_path])

if __name__ == '__main__':
    main()
