# Vagrant / Ansible test bench

This folder contains the Ansible provisioning scripts that are with a VagrantFile config in the root
folder of the project that set up a local development environment.

On a `vagrant up` and `vagrant provision` it will setup three SS LAMP stacks.

Notice that all vagrant commands have to be prepended with a system environment variable that points to the
directory of this folder, i.e.

    VAGRANT_CWD=ansible/ vagrant up
    VAGRANT_CWD=ansible/ vagrant provision

## deploynaut server

 * SSH Access: `vagrant ssh deploynaut`
 * hostname: deploynaut
 * Internal ip address: 10.0.1.2
 * http://localhost:8080/

## uat server

 * SSH Access: `vagrant ssh uat`
 * hostname: uat
 * Internal ip address: 10.0.1.3
 * http://localhost:8081/

## prod

 * SSH Access: `vagrant ssh prod`
 * hostname: prod
 * Internal ip address: 10.0.1.4
 * http://localhost:8082/

Even though it's more common to use puppet or chef scripts to setup the actual environments, they
require access to puppet modules or chef recipes and in some cases a working puppet master or chef master.

Ansible provisioning definitions are more condensed and should give a reasonable close representation
of a puppet or chef provisioning.

## Prerequisites

For Mac OS X you will need:

 * Virtualbox
 * Vagrant
 * Ansible

To install on ansible on Mac OS X you can install it in numerous ways, e.g

	sudo pip install ansible

## Installation / Usage

    VAGRANT_CWD=ansible/ vagrant up

http://localhost:8080/dev/build

http://localhost:8080/admin/naut/
admin / password

Add project:

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




# Example environment configuration

