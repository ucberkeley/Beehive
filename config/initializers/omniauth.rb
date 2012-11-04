Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas, :host => 'auth-test.berkeley.edu/cas' if Rails.env.development?
  provider :cas, :host => 'auth-test.berkeley.edu/cas' if Rails.env.test?
  provider :cas, :host => 'auth.berkeley.edu/cas' if Rails.env.production?

  #provider :developer unless Rails.env.production?
end
