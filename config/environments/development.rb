require 'openssl'
require 'net/smtp'

Dave::Application.configure do
  Net.instance_eval { remove_const :SMTPSession } if defined?(Net::SMTPSession)

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # ActionMailer Config
  #config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  #config.action_mailer.delivery_method = :sendmail
  ## change to true to allow email to be sent during development
  #config.action_mailer.perform_deliveries = true
  #config.action_mailer.raise_delivery_errors = true
  #config.action_mailer.default :charset => "utf-8"

  #Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,
    :address            => 'smtp.gmail.com',
    :port               => 587,
    :domain             => 'dave.com',
    :authentication     => :plain,
    :user_name          => 'colindao.2013@gmail.com',
    :password           => 'emailsupport', # for security reasons you can use a environment variable too. (ENV['INFO_MAIL_PASS'])
  }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin


  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

end
