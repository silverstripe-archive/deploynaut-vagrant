# The server, either a valid hostname or an IP address and port number
server '$SSH_ADDR', :web, :db

# Dummy deploy target to catch capistrano erroneously trying to execute on role-less, no-deploy hosts.
server '$SSH_ADDR', :unused

# Set your application name here, used as the base folder
set :application, "mysite"

# The path on the servers we’re going to be deploying the application to.
set :deploy_to, "/var/www"
set :current_dir, 'html'

# Set a build script that is run before the code .tar.gz is sent to the server
set :build_script, "composer install --prefer-dist --no-dev --no-progress"

# Set the sake path for this project
set :sake_path, "./framework/sake"

# This is used for sudoing into by asset transfer feature. Make sure your ssh user can run sudo -u www-data ...
set :webserver_user, "www-data"

# This will be used to chown the deployed files, make sure that the deploy user is part of this group
set :webserver_group, "sites"

# Which SSH user will deploynaut use to SSH into the server
ssh_options[:username] = 'sites'

# Enable SSH debugging
#ssh_options[:verbose] = :debug
