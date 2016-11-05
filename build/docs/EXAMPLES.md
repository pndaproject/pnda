# Package Server examples

These are some examples of how an HTTP server can be set up to serve binaries for PNDA provisioning.

These notes are intended for guidance only and will not be maintained or supported. You are strongly advised to refer to the official documentation for each technology.

## Apache HTTP Server on Ubuntu

Assuming a working Ubuntu 14.04 server and that built components are in directory pnda-dist below the current working directory -

Install Apache HTTP Server -

	sudo apt-get install apache2

Copy components to the HTTP server -

	cp pnda-dist/* /var/www/html/

The components are now available via HTTP from the server -

	http://server/some-component-0.1.0.tar.gz

## Python

Assuming that the built components are in the current working directory -

	sudo python -m SimpleHTTPServer 80

The components are now available via HTTP from the server -

	http://server/some-component-0.1.0.tar.gz

## Vagrant

The starting assumption is that you have a working Vagrant installation including a suitable provider plugin for the target environment and that built components are in directory pnda-dist below the current working directory.

**AWS**

For this example we'll use a popular [AWS provider](https://github.com/mitchellh/vagrant-aws).

Create a Vagrantfile, substituting in your AWS configuration -

	VAGRANTFILE_API_VERSION = "2"
	
	Vagrant.configure("2") do |config|
	  config.vm.box = "dummy"
	
	  config.vm.provider :aws do |aws, override|
	    aws.access_key_id 		= "<YOUR CONFIG>"
	    aws.secret_access_key 	= "<YOUR CONFIG>"
	    aws.keypair_name		= "<YOUR CONFIG>"
	    aws.ami 				= "<YOUR CONFIG>"
	    aws.region 				= "<YOUR CONFIG>"
	    aws.security_groups 	= [ '<YOUR CONFIG>' ]
	    override.ssh.username 	= "ubuntu"
	    override.ssh.private_key_path = "<YOUR CONFIG>"
	  end
	  config.vm.provision :shell, path: "bootstrap.sh"
	end

Create a bootstrap.sh -

	apt-get update
	apt-get install -y apache2
	rm -rf /var/www/html
	ln -fs /vagrant/pnda-dist /var/www/html

Start the instance -

	vagrant up --provider=aws

The components are now available via HTTP from the server in AWS -

	http://server/some-component-0.1.0.tar.gz

If you need to update the components later -

	vagrant rsync

**OpenStack**

For this example we'll use a popular [OpenStack provider](https://github.com/cloudbau/vagrant-openstack-plugin).

Create a Vagrantfile, substituting in your OpenStack configuration -

	Vagrant.configure("2") do |config|
	  config.vm.box = "dummy"
	  config.ssh.username = "<YOUR CONFIG>"
	  config.ssh.private_key_path = "<YOUR CONFIG>"
	
	  config.vm.provider :openstack do |os|
	    os.username     = "<YOUR CONFIG>"          
	    os.api_key      = "<YOUR CONFIG>"           
	    os.flavor       = "<YOUR CONFIG>"          
	    os.region       = "<YOUR CONFIG>"
	    os.image        = "<YOUR CONFIG>"               
	    os.endpoint     = "<YOUR CONFIG>"
	    os.tenant        = "<YOUR CONFIG>"
	    os.keypair_name       = "<YOUR CONFIG>"
	    os.floating_ip        = :auto
	    os.floating_ip_pool   = "<YOUR CONFIG>"
	    os.networks = ['<YOUR CONFIG>']
	  end
	  config.vm.provision :shell, path: "bootstrap.sh"
	end

Create a bootstrap.sh -

	apt-get update
	apt-get install -y apache2
	rm -rf /var/www/html
	ln -fs /vagrant/pnda-dist /var/www/html

Start the instance -

	vagrant up --provider=openstack

The components are now available via HTTP from the server in OpenStack -

	http://server/some-component-0.1.0.tar.gz

If you need to update the components later -

	vagrant provision

## Docker

Assuming a working Docker installation and that built components are in directory pnda-dist below the current working directory -

Create a Dockerfile -

	FROM httpd:2.4
	COPY ./pnda-dist/ /usr/local/apache2/htdocs/

Build the container -

	sudo docker build -t package-server .
	sudo docker run -dit -p 80:80 --name package-server package-server

The components are now available via HTTP from the server -

	http://server/some-component-0.1.0.tar.gz

If you need to update the components later -

	sudo docker cp pnda-dist/some-component-0.2.0.tar.gz package-server:/usr/local/apache2/htdocs/


