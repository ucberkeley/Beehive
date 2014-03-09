Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, :path => '/cas', :host => 'auth-test.berkeley.edu' if Rails.env.development?
  provider :cas, :path => '/cas', :host => 'auth-test.berkeley.edu' if  Rails.env.test?
  provider :cas, :path => '/cas', :host => 'auth.berkeley.edu' if Rails.env.production?

  #provider :developer unless Rails.env.production?
end

ResearchMatch::Application.config.auth_providers = { :cas => {:auth_field => :login, :auth_value => :uid} }
