# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_opengover_session',
  :secret      => '6f2b4ecb82c60870e39f5968468a4e9b17ed1ae28098be8ee88ee08dd3185d51fb27c7baadde71ee7140f57f6a8320b4cf24f9b59dea644bf49538ea46ae4982'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
