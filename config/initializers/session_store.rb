# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_open_talent_cms_session',
  :secret => 'e3b17ed77a7765b7b05a0a2aa21a4054d2e36eeaea2cad0ed106ca446e46723b8fe3161837e408ee5e27d4cd827e0a75e69d43b877bacd1b80817cd50912e08e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
