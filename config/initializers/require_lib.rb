# Requires all .rb files in root/lib
# This is needed because, by default, Rails doesn't load
# lib files that don't contain matching classes.
# http://stackoverflow.com/questions/4074830/adding-lib-to-config-autoload-paths-in-rails-3-does-not-autoload-my-module

Dir.glob(File.join(Rails.root, 'lib', '*.rb')).each do |rb|
  require rb
end
