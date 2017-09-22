"""
Download python packages based on requirement files
"""

import re
import time
import os
import subprocess
import sys

def main():

    package_path=os.environ['MIRROR_OUTPUT_DIR']+"/mirror_python/packages"
    requirements_path=os.environ['PYTHON_REQ_DIR']
    file_py2 = open(requirements_path+"/pnda_requirements_py2.txt","r") 
    file_py3 = open(requirements_path+"/pnda_requirements_py3.txt","r") 
    # init directory
    if not os.path.exists(package_path):
        os.makedirs(package_path)

    # download python 2 libs
    subprocess.call(["pip2","download","setuptools","--platform","multilinux1_x86_64","--python-version","27","--implementation","py","--only-binary=:all:","-d",package_path])
    python_deps = (file_py2.read()).rstrip().split('\n')
    for one_dep in python_deps:
        ret_code = subprocess.call(["pip2","download", "--no-deps", one_dep,"--no-binary",":all:","-d",package_path])
        if ret_code != 0:
            sys.exit(-1)

    # download python 3 libs
    subprocess.call(["pip3","download","setuptools","--only-binary=:all:","-d",package_path])
    python_deps = (file_py3.read()).rstrip().split('\n')
    for one_dep in python_deps:
        ret_code = subprocess.call(["pip3","download", "--no-deps", one_dep,"-d",package_path])
        if ret_code != 0:
            sys.exit(-1)

if __name__ == '__main__':
    main()
