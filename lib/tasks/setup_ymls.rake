def ask_for(prompt)
  puts "Enter #{prompt}:"
  STDIN.readline.rstrip
end

namespace :db do
  desc "Setup default database.yml, with dev/test username/password"
  task :setup_yml do
    the_file = File.join Rails.root, 'config', 'database.yml'
    location = "#{the_file}.erb"
    template = File.read location
    config = ERB.new template

    # ERB vars
    username = ask_for "username"
    password = ask_for "password"

    File.open( the_file, 'w' ) do |f|
      f.write config.result(binding)
      puts "\nWrote to #{the_file}. Be sure to IGNORE this file in your version control!"
    end
  end
end

namespace :ldap do
  desc "Setup ldap.yml"
  task :setup do
    default_template = <<-EOF
base: &base
  username: <% puts "Enter LDAP username:" %><%= STDIN.readline.rstrip %>
  password: <% puts "Enter LDAP password:" %><%= STDIN.readline.rstrip %>

development:
  <<: *base
test:
  <<: *base
production:
  <<: *base
EOF

    location = File.join(Rails.root, "config", "ldap.yml.erb")
    template = File.file?(location) ? File.read(location) : default_template
    config = ERB.new(template)
    File.open(File.join(Rails.root, "config", "ldap.yml"), 'w') do |f|
     f.write config.result(binding)
     puts "\nThanks, I put your config file in config/ldap.yml. Be sure you IGNORE this file in your version control!"
    end
  end
end
