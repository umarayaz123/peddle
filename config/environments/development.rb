Peddle::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  #config.action_dispatch.best_standards_support = :builtin
  #config.session_store = {:domain => '.lvh.me'} # for localhost
  config.action_dispatch.best_standards_support = :builtin
  config.session_store                          = {:domain => '.ilsainteractive.com'}

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

#  config.action_mailer.default_url_options = { :host => 'lvh.me' }
  TIME_ZONE = "UTC"
  config.time_zone = TIME_ZONE
#  config.action_mailer.default_url_options = { :host => 'ilsainteractive.com:3003' }
#  config.register_javascript 'ckeditor/config.js'
  config.assets.paths << File.join(Rails.root, 'public', 'javascripts')
  config.assets.initialize_on_precompile = false

  #config.action_mailer.default_url_options = {:host => 'lvh.me:3000'}
config.action_mailer.default_url_options = {:host => 'ilsainteractive.com:3003'}
  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => "587",
      :domain               => "gmail.com",
      :enable_starttls_auto => true,
      :authentication       => :login,
      :user_name            => "test.account.rac@gmail.com",
      :password             => "racpakistan22"
  }


  #config.after_initialize do
  #  ActiveMerchant::Billing::Base.mode = :test
  #  ::GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(
  #      #:login => "seller_1229899173_biz_api1.railscasts.com",
  #      #:password => "FXWU58S7KXFC6HBE",
  #      #:signature => "AGjv6SW.mTiKxtkm6L9DcSUCUgePAUDQ3L-kTdszkPG8mRfjaRZDYtSu"
  #      :login => "adnan._1321870730_biz_api1.ilsainteractive.com",
  #      :password => "1321870755",
  #      :signature => "ACpd97qaQ5oE.P.scwB6okRJRN5lAsYWPxa66NQ9IuHmbkVyDKfKIctv"
  #  )
  #end

  #------------------------------------------------------------------------
  config.after_initialize do
    #SslRequirement.disable_ssl_check = false
    ActiveMerchant::Billing::Base.mode = :test
    ActiveMerchant::Billing::PaypalExpressGateway.default_currency = 'USD'
  end

  paypal_options = {
      :login => "seller_1229899173_biz_api1.railscasts.com",
      :password => "FXWU58S7KXFC6HBE",
      :signature => "AGjv6SW.mTiKxtkm6L9DcSUCUgePAUDQ3L-kTdszkPG8mRfjaRZDYtSu"
  }

  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
  ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)

#-------------------------------------------------------------------------


end
