# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_what_column_session',
  :secret      => '6fb3213f8a881caf9feb0464d7da850f311df92b333bdf891399a1e85cd0dd84fae4e2a359fe46cdcb1467fc60ffca095f5cc6c6d642908264f9b1c716e499e7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
