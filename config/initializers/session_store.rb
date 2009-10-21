# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_research_session',
  :secret      => '2b012fa41fee4b212f851c749590d9e3198032513234afb54055c2489eebf3c978af9efefbb1a1e1079a35af76cea455d854729b78969cb8afdc3b1b683eaff1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
