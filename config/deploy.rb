require "#{File.dirname(__FILE__)}/capistrano_database"

set :application, "Beehive"
set :repository,  "git://github.com/jonathank/ResearchMatch.git"
set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :branch, "rails3"

set :machine_name, "upe.cs.berkeley.edu"

# Directory for deployment on the production (remote) machine.
set :deploy_to, "/home/amber/Beehive/"

role :web, "#{machine_name}"                          # Your HTTP server, Apache/etc
role :app, "#{machine_name}"                          # This may be the same as your `Web` server
role :db,  "#{machine_name}", :primary => true # This is where Rails migrations will run

set :user, "amber"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts
namespace :mod_rails do
  desc <<-DESC
  Restart the application altering tmp/restart.txt for mod_rails.
  DESC
  task :restart, :roles => :app do
    run "touch  #{release_path}/tmp/restart.txt"
  end
  
  task :search_rebuild, :roles => :app do
  end
  
end
 
# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
# task :start do ; end
# task :stop do ; end
# task :restart, :roles => :app, :except => { :no_release => true } do
#   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
# end
  %w(start restart).each { |name| task name, :roles => :app do mod_rails.restart end }
end
