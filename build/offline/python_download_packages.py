"""
Download python packages based on requirement files
"""

import re
import time
import os
import subprocess

def main():

    package_path=os.environ['MIRROR_OUTPUT']+"/mirror_python/packages"
    requirements_path=os.environ['PYTHON_REQ_DIR']
    file_py2 = open(requirements_path+"/pnda_requirements_py2.txt","r") 
    file_py3 = open(requirements_path+"/pnda_requirements_py3.txt","r") 
    # init directory
    if not os.path.exists(package_path):
        os.makedirs(package_path)

    # download python 2 libs
    subprocess.call(["pip2","download","setuptools","--platform","multilinux1_x86_64","--python-version","27","--implementation","py","--only-binary=:all:","-d",package_path])
    subprocess.call(["pip2","download","pbr","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip2","download","pip==9.0.1","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip2","download","virtualenv==15.1.0","--no-binary",":all:","--process-dependency-links","-d",package_path])
    python_deps = (file_py2.read()).rstrip().split('\n')
    for one_dep in python_deps:
        subprocess.call(["pip2","download",one_dep,"--no-binary",":all:","--process-dependency-links","-d",package_path])

    # download python 3 libs
    subprocess.call(["pip3","download","setuptools","--only-binary=:all:","-d",package_path])
    subprocess.call(["pip3","download","pbr","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip3","download","pip==9.0.1","--no-binary",":all:","--process-dependency-links","-d",package_path])
    subprocess.call(["pip3","download","virtualenv==15.1.0","--no-binary",":all:","--process-dependency-links","-d",package_path])
    python_deps = (file_py3.read()).rstrip().split('\n')
    for one_dep in python_deps:
        subprocess.call(["pip3","download",one_dep,"--process-dependency-links","-d",package_path])

if __name__ == '__main__':
    main()
