# Replace with the HTTP (NOT HTTPS) read-only URL of your Google Code SVN.
set :repository, "http://research-cs194.googlecode.com/svn/trunk/research"

# Directory for deployment on the production (remote) machine.
set :deploy_to, "/mnt/app"

# Replace the below with the hostname of your EC2 instance.
set :machine_name, "ec2-174-129-122-92.compute-1.amazonaws.com"

# We're using one instance for all three roles.
role :app, "#{machine_name}"
role :web, "#{machine_name}"
role :db,  "#{machine_name}", :primary => true

set :use_sudo, false
set :user, "root"

#ssh_options[:keys] = File.join(ENV["HOME"], "/id_rsa-cs194")
ssh_options[:keys] = "id_rsa-cs194"

namespace :deploy do
  %w(start stop restart).each do |action| 
     desc "#{action} the Thin processes"  
     task action.to_sym do
       find_and_execute_task("thin:#{action}")
    end
  end 
end

namespace :thin do  
  %w(start stop restart).each do |action| 
  desc "#{action} the app's Thin Cluster"  
    task action.to_sym, :roles => :app do  
      run "thin #{action} -c #{deploy_to}/current/research -e production -p 80 -d" 
    end
  end
end