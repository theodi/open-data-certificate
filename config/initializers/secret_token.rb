# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.


if Rails.env.production?
  raise "Session secret not set!" unless ENV['SESSION_SECRET_CERTIFICATE']
  OpenDataCertificate::Application.config.secret_token = ENV['SESSION_SECRET_CERTIFICATE']
else
  OpenDataCertificate::Application.config.secret_token = '2da17efb8c0932028001e92cfb3b2da01cfc351f95f7628cac4e20e1bb19df2c6b9416ece51e947b784cb57edd6b65a4cef2e49a6f8e8ff9d0b7fcb736800bb4'
end