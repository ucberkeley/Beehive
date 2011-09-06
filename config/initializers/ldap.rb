#
# UCB::LDAP initialization
#
# Two options for supplying bind credentials:
#   1) set LDAP_USERNAME and LDAP_PASSWORD environment vars
#   2) use config/ldap.yml (generate one with rake ldap:setup)
#

require 'ucb_ldap'

begin
  # This has to go in the initializer (not environments/*) because
  # we need the ucb_ldap plugin to be loaded, which happens after
  # environments are loaded.
  UCB::LDAP.host = case Rails.env
    when 'production'
      UCB::LDAP::HOST_PRODUCTION
    else
      UCB::LDAP::HOST_TEST
  end

  unless Rails.env == 'test'
    # 1) Try using env vars
    username, password = ENV['LDAP_USERNAME'], ENV['LDAP_PASSWORD']
    if username && password
      UCB::LDAP::authenticate(username, password)

    # 2) Use config/ldap.yml
    else
      UCB::LDAP.bind_for_rails

    end
  end

rescue UCB::LDAP::BindFailedException => e
  $stderr.puts "WARNING: Failed to bind: #{e.inspect}"

rescue RuntimeError => e  # UCB::LDAP throws this for missing file
  $stderr.puts "WARNING: Missing file: #{e.inspect}"

end
