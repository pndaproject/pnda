export PYTHON_REQ_DIR=$THIS_DIR/requirements

if [ "x$DISTRO" == "xubuntu" ]; then
	apt-get install libffi-dev python3-pip
fi

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo pip2 install setuptools==34.2.0
sudo pip2 install github3.py
sudo easy_install3 pip==9.0.1
sudo pip3 install setuptools==34.2.0
sudo rm get-pip.py

python python_download_packages.py
python python_index_generator.py