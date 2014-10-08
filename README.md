# Vagrant / Ansible test bench

This is a SilverStripe module that provides an automated setup of a dev environment for the [deploynuat](https://github.com/silverstripe/deploynaut) module by using virtualbox, vagrant and ansible.

## System requirements

On your development machine you will need:

 * [Virtualbox](https://www.virtualbox.org/)
 * [Vagrant](https://www.vagrantup.com/)
 * [Ansible](http://docs.ansible.com/intro_installation.html)

You can install ansible via `pip`:

	sudo pip install ansible
 
## Installation

It is meant to be installed in a project that already have deploynaut installed, see the [deploynaut installation instructions](https://github.com/silverstripe/deploynaut/blob/master/docs/en/index.md#deploynaut-1). Please note that you will **not** be required to install capistrano or php-resque, just the source code for the project.

Install this module to your current deploynaut project with composer:

	composer require --dev "silverstripe/deploynaut-vagrant:*"

Start the virtual machines from the root of the project from a terminal:

	VAGRANT_CWD=deploynaut-vagrant/ vagrant up

You can also only boot selected machines if you don't need the complete environment:

	VAGRANT_CWD=deploynaut-vagrant/ vagrant up deploynaut prod

The purpose of using `VAGRANT_CWD` is that we need to run vagrant from the root folder of the project so that it can be mounted over shared volume into the virtual machine.

On `vagrant up` the vagrant will start three virtualbox machines and use ansible to install the necessary software for running one deploynaut site and two generic silverstripe sites.

## Provisioned machines

Note the last octet of IP is reused as the last part of the forwarded HTTP port number.

### deploynaut

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh deploynaut`
 * hostname: deploynaut
 * Internal ip address: 10.0.1.2
 * http://localhost:8102/
 * http://localhost:5678/ (resque-web for debugging failing Resque workers)

## uat

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh uat`
 * hostname: uat
 * Internal ip address: 10.0.1.3
 * http://localhost:8103/

## prod

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh prod`
 * hostname: prod
 * Internal ip address: 10.0.1.4
 * http://localhost:8104/

## rep1

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh rep1`
 * hostname: uat
 * Internal ip address: 10.0.1.5
 * http://localhost:8105/

## rep2

 * SSH Access: `VAGRANT_CWD=deploynaut-vagrant/ vagrant ssh rep2`
 * hostname: prod
 * Internal ip address: 10.0.1.6
 * http://localhost:8106/

## Detailed usage instructions

Step by step instructions to setup a fully working environment

	VAGRANT_CWD=ansible/ vagrant up

Go to the admin [http://localhost:8102/admin/naut/](http://localhost:8102/admin/naut/)

The username and password is: `admin` / `password`

Configure a git repository where needed, e.g. `https://github.com/stojg/sandbox.dev.git`

You can click "Check connection", it should report "You appear to have all necessary dependencies installed"

Go to [project/mytest](http://localhost:8102/) and deploy to the selected environment. The site should be up now.

## FAQ

*Q: I have restarted (or vagrant reloaded) the deploynaut server and now it's not working!*

A: Resque might not have started. Rerun the provisioner by calling vagrant provision deploynaut.
