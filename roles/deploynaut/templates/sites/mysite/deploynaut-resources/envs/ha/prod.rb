# Set your application name here, used as the base folder
set :application, "mysite"

# Extra tasks for locking csync2 out.
namespace :deploy do
	# For instances with csync.
	# We are deploying to both sides, signal to csync2 that we want it disabled, and wait for it to finish.
	task :disable_csync do
		run "touch /sites/#{application}/csync2.disable"

		# Check lock by trying to acquire it for one minute (36 checks, 5s delay).
		# Outer bash is needed for the loop to function correctly.
		begin
			run <<ACQUIRELOCK
			bash -c "\
				for i in {1..36}; do\
					if flock -n -e /var/run/csync2.lock -c 'true'; then exit 0; fi;\
					echo 'Waiting for current file sync to finish...';\
					sleep 5;\
				done;\
				echo 'Timed out. Please try again later.';\
				exit 1\
			"
ACQUIRELOCK
			rescue Exception => e
					run "rm /sites/#{application}/csync2.disable"
					raise e
			end

	end

	# For instances with csync.
	# Re-enable csync2.
	task :enable_csync do
			run "rm /sites/#{application}/csync2.disable"
	end

end

before "deploy:update_code", "deploy:disable_csync"
after "deploy:restart", "deploy:enable_csync"

before "data:pushassets", "deploy:disable_csync"
after "data:pushassets", "deploy:enable_csync"

# The path on the servers we’re going to be deploying the application to.
set :deploy_to, "/sites/#{application}"

# Set a build script that is run before the code .tar.gz is sent to the server
set :build_script, "composer install --prefer-dist --no-dev"

# Set the sake path for this project
set :sake_path, "./framework/sake"

# This will be used to chown the deployed files, make sure that the deploy user is part of this group
set :webserver_group, "sites"

set :webserver_user, "www-data"

# Which SSH user will deploynaut use to SSH into the server
ssh_options[:username] = 'sites'

server "10.0.1.5", :app, :web, :db, {
	:primary => true
}

server "10.0.1.6", :app, :web, :db

# Dummy deploy target to catch capistrano erroneously trying to execute on role-less, no-deploy hosts.
server '10.0.1.254:22', :unused
