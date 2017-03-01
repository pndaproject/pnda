"""
Generate the pip index file based on download packages
"""

import re
import time
import os
import subprocess
from os import listdir
from os.path import isfile, join

def main():
    simple_path=os.environ['MIRROR_OUTPUT']+"/mirror_python/simple"
    package_path=os.environ['MIRROR_OUTPUT']+"/mirror_python/packages"
    package_list = {}
    # init directory
    if not os.path.exists(simple_path):
        os.makedirs(simple_path)
    if not os.path.exists(package_path):
        os.makedirs(package_path)

    # parse all packages and generate index files
    onlyfiles = [f for f in listdir(package_path) if isfile(join(package_path, f))]
    for afile in onlyfiles:
        print afile
        package=afile
        if afile.find("-py2.py3-none") != -1:
            package=afile[0:afile.find("-py2.py3-none")]
        elif afile.find("-cp35-cp35m-manylinux1_x86_64") != -1:
            package=afile[0:afile.find("-cp35-cp35m-manylinux1_x86_64")]
        elif afile.find("-cp34-cp34m-manylinux1_x86_64") != -1:
            package=afile[0:afile.find("-cp34-cp34m-manylinux1_x86_64")]
        elif afile.find("-py3-none-any") != -1:
            package=afile[0:afile.find("-py3-none-any")]

        package=package.replace(".zip","")
        package=package.replace(".tar.gz","")
        package_name=re.split('-\d+(?:\.\d+)+',package)[0].lower()
        package_name=package_name.replace("_","-")
        package_name=package_name.replace(".","-")
        package_version=package[package.rfind("-")+1:]
        print "Managing package "+package_name+" version "+package_version
        md5sum = subprocess.check_output(["md5sum", package_path+"/"+afile]).split(' ')[0]
        print md5sum

        package_p=simple_path+"/"+package_name
        if not os.path.exists(package_p):
            os.makedirs(package_p)

        if not package_list.has_key(package_name):
            package_list[package_name]=""

        package_list[package_name] = package_list[package_name]+ \
            '<a href="../../packages'+'/'+afile+'#md5='+md5sum+'">'+afile+'</a><br>'

    for package_name,links in package_list.items():
        str_package='<html><head><title>Links for '+package_name+'</title></head>' + \
            '<body><h1>Links for '+package_name+'</h1>' + \
            links + \
            '</body></html>'
        file_package = open(simple_path+"/"+package_name+"/index.html","w")
        file_package.write(str_package)
        file_package.close()


if __name__ == '__main__':
    main()
