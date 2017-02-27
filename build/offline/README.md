# Offline mirrors and indexes

## Mirrors
Use the script create.sh in order to generate all the required mirrors needed during PNDA provisioning. This script is based on pnda-deb-package-dependencies.txt for Ubuntu and pnda-rpm-package-dependencies.txt for RHEL.

```sh
./create_mirror.sh
```

## Python mirror

### Requirements
You will need python 2.7 and python 3.4 with also pip2 / pip3 version 9.0.1+ & github3 for using GitHub API:
```sh
sudo -i
# Ubuntu only, already install in RHEL
apt-get install libffi-dev

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip2 install setuptools==34.2.0
pip2 install github3.py
apt-get install python3-pip
easy_install3 pip==9.0.1
pip3 install setuptools==34.2.0
``` 

### Build the PNDA global requirements file
Run the following command in order to get all the requirements.txt from the pndaproject repositories. This step requires generating toekn for accessing GitHub API. See [Personal API tokens](https://github.com/blog/1509-personal-api-tokens0 and change XXXXXXX user / token in the "python_build_requirements.py" before running it:
```sh
vi python_build_requirements.py
python python_build_requirements.py
```

this will download all requirement files in the python-2 and python-3 requirements folder

### Download python packages
Once you have all requirement files, run:
```sh
python python_download_packages.py
```

it will download all the packages in the packages directory ./packages by default

### Genrate the pip index
To generate all the required index in the simple directory run:

```sh
python python_index_generator.py
```

### Move resources to the HTTP Server
So then you just need to put this 2 folders in your HTTP server such as for example:
```sh
cp simple packages /var/www/html
```
and then, on your pnda_env, you need to specify:
PNDA_MIRROR: http://x.x.x.x

so that the pip index URL will be generated as $PNDA_MIRROR/simple

