UCB::LDAP.bind_for_rails unless Rails.env.eql? 'test'
