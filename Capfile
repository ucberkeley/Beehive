# Replace with the HTTP (NOT HTTPS) read-only URL of your Google Code SVN.
set :repository, "http://research-cs194.googlecode.com/svn/trunk/research"

# Directory for deployment on the production (remote) machine.
set :deploy_to, "/home/amber/researchmatch/"

# Replace the below with the machine name
set :machine_name, "upe.cs.berkeley.edu"

# We're using one instance for all three roles.
role :app, "#{machine_name}"
role :web, "#{machine_name}"
role :db,  "#{machine_name}", :primary => true

set :use_sudo, false
set :user, "amber"

namespace :mod_rails do
  desc <<-DESC
  Restart the application altering tmp/restart.txt for mod_rails.
  DESC
  task :restart, :roles => :app do
    run "touch  #{release_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  %w(start restart).each { |name| task name, :roles => :app do mod_rails.restart end }
end

