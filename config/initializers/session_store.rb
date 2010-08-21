# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_itunes-control_session',
  :secret      => 'f37d95017fb6d04d465117ab907ffe2c42198960706c922ff69a6f859505ffb5b5c3136eee5085c0eaeac487dcfc2bf9b06ccdcb603a6de80ae61acab4812105'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
