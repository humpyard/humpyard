# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
#ActionController::Base.cookie_verifier_secret = '8e743e8fedd1ff85477e68a8e37ba244b09ed4a14c50219eba5a98c966db199d74c0e436983220d907eda8d7a3c14981d66a6dc04b1c97156ea618a10c7905f1'

TestHumpyard::Application.configure do
  config.secret_token = '8e743e8fedd1ff85477e68a8e37ba244b09ed4a14c50219eba5a98c966db199d74c0e436983220d907eda8d7a3c14981d66a6dc04b1c97156ea618a10c7905f1'
end