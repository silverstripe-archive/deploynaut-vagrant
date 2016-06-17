# -*- mode: ruby -*-
# vi: set ft=ruby :

# Will ensure that python is installed so that ansible can provision the servers
$install_pyton = <<SCRIPT
if [ ! -f /usr/bin/python ]; then
	echo "Installing python for ansible"
	apt-get -q update
	apt-get install -q -y python
fi
SCRIPT

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	# A apt-get cache plugin for vagrant can be installed via http://fgrehm.viewdocs.io/vagrant-cachier
	config.vm.box = "halkyon/debian-jessie-amd64"
	config.vm.box_url = "https://halkyon.net/vagrant/debian-jessie-minimal-amd64.box"

	config.vm.provider "virtualbox" do |v|
		v.memory = 512
		v.cpus = 1
	end

	config.vm.define "deploynaut" do |deploynaut|
		deploynaut.vm.hostname = "deploynaut"
		deploynaut.vm.network "private_network", ip: "10.0.1.2"
		deploynaut.vm.network "forwarded_port", guest: 80, host: 8102
		deploynaut.vm.network "forwarded_port", guest: 5678, host: 5678
		deploynaut.vm.synced_folder "../", "/sites/mysite/www", owner: "www-data", group: "www-data"
		deploynaut.vm.provision "ansible", playbook: "node_deploynaut.yml"
	end

	config.vm.define "uat" do |uat|
		uat.vm.hostname = "uat"
		uat.vm.network "private_network", ip: "10.0.1.3"
		uat.vm.network "forwarded_port", guest: 80, host: 8103
		uat.vm.provision "ansible", playbook: "node_web.yml"
	end

	config.vm.define "prod" do |prod|
		prod.vm.hostname = "prod"
		prod.vm.network "private_network", ip: "10.0.1.4"
		prod.vm.network "forwarded_port", guest: 80, host: 8104
		prod.vm.provision "ansible", playbook: "node_web.yml"
	end

	config.vm.define "rep1" do |rep1|
		rep1.vm.hostname = "rep1"
		rep1.vm.network "private_network", ip: "10.0.1.5"
		rep1.vm.network "forwarded_port", guest: 80, host: 8105
		rep1.vm.provision "ansible", playbook: "node_ha.yml", extra_vars: { ha_primary: true }
	end

	config.vm.define "rep2" do |rep2|
		rep2.vm.hostname = "rep2"
		rep2.vm.network "private_network", ip: "10.0.1.6"
		rep2.vm.network "forwarded_port", guest: 80, host: 8106
		rep2.vm.provision "ansible", playbook: "node_ha.yml", extra_vars: { ha_primary: false }
	end

	config.vm.provision "shell", inline: $install_pyton
end
