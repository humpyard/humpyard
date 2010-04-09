# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.

# deprecated with rails 3 - but the new way seem not to work, either
#ActionController::Base.session = {
#  :key    => '_testhumpyard_session',
#  :secret => 'e4dc8c63aeac04f817a144771482323f3f7e268d98333efb18a0b4eea3b9fa91ad6e9995038c59c649525f714aebf2b8e0543cde6c43dbd7ce9317dad6a45539'
#}

TestHumpyard::Application.configure do
  config.session_store :cookie_store, :key => "_testhumpyard_session"
end

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
