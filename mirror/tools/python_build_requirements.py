"""
Grab all python requirements file from pndaproject

Uses github3 to interact with the GitHub API v3
pip install github3.py


WARNING: in case of tpl files from platform-salt, replace the context variable
         with the right name/URL 
"""

import re
import time
import requests
from github3 import login
import os

def main():

    requirements_path=os.environ['PYTHON_REQ_DIR']
    if not os.path.exists(requirements_path): 
        os.makedirs(requirements_path)
    file_py2 = open(requirements_path+"/pnda_requirements_py2.txt","w") 
    file_py3 = open(requirements_path+"/pnda_requirements_py3.txt","w") 
    pnda_deps_py2 = {}
    pnda_deps_py3 = {}
    py3_list = ["salt/jupyter"]
    exclude_list = ["test_requirements.txt"]
   
    # put your user and token here:
    gh = login('XXXXXXX', token='XXXXXXX')
    query='filename:requirements*.txt repo:pndaproject/platform-salt '+\
        'repo:pndaproject/platform-deployment-manager '+\
        'repo:pndaproject/platform-data-mgmnt '+\
        'repo:pndaproject/platform-deployment-manager '+\
        'repo:pndaproject/platform-libraries '+\
        'repo:pndaproject/platform-package-repository '+\
        'repo:pndaproject/platform-testing '
    all_req_txt = gh.search_code(query, per_page=100)
    print all_req_txt
    i=0
    for one_req_txt in all_req_txt:
        name = one_req_txt.name
        path = one_req_txt.path
        full_name = one_req_txt.repository.full_name
        url = one_req_txt.html_url
        commit_index_start = url.find("blob")+5
        commit_index_end = url.find(path)-1
        commit_id=url[commit_index_start:commit_index_end]
        raw_url = "https://raw.githubusercontent.com/"+full_name+"/"+commit_id+"/"+path
        print "raw file: "+raw_url

        if any(ex_str in name for ex_str in exclude_list):
            print " do not manage test requirements file"
        else:   
            r = requests.get(raw_url)
            python_deps = (r.text).rstrip().split('\n')
            i=i+1
            if any(py3_str in path for py3_str in py3_list):
                print full_name + "with path "+path+" is python 3"
                pnda_deps = pnda_deps_py3
                file = file_py3
            else:
                print full_name + "with path "+path+" is python 2"
                pnda_deps = pnda_deps_py2
                file = file_py2

            for one_dep in python_deps:
                one_dep_tab = one_dep.split("==")
                if len(one_dep_tab) == 2:
                    if pnda_deps.has_key(one_dep_tab[0]):
                        version = pnda_deps[one_dep_tab[0]]
                        if version != one_dep_tab[1]:
                            print "WARNING on "+one_dep+" : already having version "+version+" for "+one_dep_tab[0]
                            pnda_deps[one_dep_tab[0]]=one_dep_tab[1]
                            file.write(one_dep+'\n')
                    else:
                        pnda_deps[one_dep_tab[0]]=one_dep_tab[1]
                        file.write(one_dep+'\n')
                else:
                    print "WARNING on "+one_dep+" missing version"
    file_py2.close()
    file_py3.close() 
if __name__ == '__main__':
    main()
