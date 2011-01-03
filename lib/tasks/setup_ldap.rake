namespace :ldap do
  desc "Setup ldap.yml"
  task :setup do
    default_template = <<-EOF
base: &base
username: uid=researchmatch,ou=applications,dc=berkeley,dc=edu
password: <% puts "Enter LDAP password:" %><%= STDIN.readline %>

development:
  <<: *base
test:
  <<: *base
production:
  <<: *base
EOF

    location = File.join(RAILS_ROOT, "config", "ldap.yml.erb")
    template = File.file?(location) ? File.read(location) : default_template
    config = ERB.new(template)
    File.open(File.join(RAILS_ROOT, "config", "ldap.yml"), 'w') do |f|
     f.write config.result(binding)
    end
  end
end
