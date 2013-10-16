# Be sure to restart your server when you modify this file.

PhishingFramework::Application.config.session_store :cookie_store, key: '_phishing-framework_session', :expire_after => 120.minutes

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# PhishingFramework::Application.config.session_store :active_record_store
