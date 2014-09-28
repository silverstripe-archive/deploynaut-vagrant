# Vagrant / Ansible test bench

This is a SilverStripe module that provides an automated setup of a dev environment for the [deploynuat](https://github.com/silverstripe/deploynaut) module by using virtualbox, vagrant and ansible.

## System requirements

On your development machine you will need:

 * [Virtualbox](https://www.virtualbox.org/)
 * [Vagrant](https://www.vagrantup.com/)
 * [Ansible](http://docs.ansible.com/intro_installation.html)

To install ansible on Mac OS X you can install it in numerous ways, e.g

	sudo pip install ansible
 
## Installation

It is meant to be installed in a project that already have deploynaut installed, see the [deploynaut installation instructions](https://github.com/silverstripe/deploynaut/blob/master/docs/en/index.md#deploynaut-1). Please note that you will **not** be required to install capistrano or php-resque, just the source code for the project.

Install this module to your current deploynaut project with composer:

	$ composer require --dev "silverstripe/deploynaut-vagrant:*"

Start the virtual machines from the root of the project from a terminal:

	$ VAGRANT_CWD=deploynaut-vagrant/ vagrant up

The purpose of using `VAGRANT_CWD` is that we need to run vagrant from the root folder of the project so that it can be mounted over shared volume into the virtual machine.

On `vagrant up` the vagrant will start three virtualbox machines and use ansible to install the necessary software for running one deploynaut site and two generic silverstripe sites.

## deploynaut server

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh deploynaut`
 * hostname: deploynaut
 * Internal ip address: 10.0.1.2
 * http://localhost:8080/

## uat server

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh uat`
 * hostname: uat
 * Internal ip address: 10.0.1.3
 * http://localhost:8081/

## prod

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh prod`
 * hostname: prod
 * Internal ip address: 10.0.1.4
 * http://localhost:8082/

## Detailed usage instructions

Step by step instructions to setup a fully working environment

    VAGRANT_CWD=ansible/ vagrant up

Dev build [http://localhost:8080/dev/build](http://localhost:8080/dev/build)

Go to the admin [http://localhost:8080/admin/naut/](http://localhost:8080/admin/naut/)

The username and password is: `admin` / `password`

Add a new project:

	Project name: myproject
	Git repository: https://github.com/stojg/sandbox.dev.git

Click "Create"

Check the box "Create folder" and click "Save"

Click the "+ Add" on the Environments Grid field

    Environment name: uat
    Server URL: http://localhost:8081

Click "Create"

Check the box "Create Config" and click "Save"

Copy paste the following into the  `Deploy config` textarea:

	# The server, either a valid hostname or an IP address and port number
	server '10.0.1.3:22', :web, :db

	# Set your application name here, used as the base folder
	set :application, "mysite"

	# The path on the servers we’re going to be deploying the application to.
	set :deploy_to, "/sites/#{application}"

	# Set a build script that is run before the code .tar.gz is sent to the server
	set :build_script, "composer install --prefer-dist --no-dev"

	# Set the sake path for this project
	set :sake_path, "./framework/sake"

	# This will be used to chown the deployed files, make sure that the deploy user is part of this group
	set :webserver_group, "sites"

	# Which SSH user will deploynaut use to SSH into the server
	ssh_options[:username] = 'sites'

	# Enable SSH debugging
	#ssh_options[:verbose] = :debug

Click "save"

Click "Check connection", it should report "You appear to have all necessary dependencies installed"

Go to [project/mytest](http://localhost:8080/naut/project/mytest)

The repository should be there with all commits

Go to [project/mytest/environment/production](http://localhost:8080/naut/project/mytest/environment/production)

Deploy latest version of the master branch

Deployment should be successful

Go to [http://localhost:8081/](http://localhost:8081/)


