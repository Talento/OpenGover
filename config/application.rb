require File.expand_path('../boot', __FILE__)

#require 'rails/all'
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "rails/test_unit/railtie"

#require "vendor/plugins/otp_portal/lib/otp_portal"

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module OpenTalentCms
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Add additional load paths for your own custom dirs
    # config.load_paths += %W( #{config.root}/extras )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
    # config.i18n.default_locale = :de

    # Configure generators values. Many other options are available, be sure to check the documentation.
     config.generators do |g|
       g.orm             :mongoid #:active_record
       g.template_engine :erb
       g.test_framework  :rspec #:test_unit, :fixture => true
     end

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password

    #Esta l’nea sobra, pero la necesito para los tests porque no coge los initializers
    if Rails.env=="test"
      config.action_controller.session = { :key => "_myapp_session", :secret => 'e3b17ed77a7765b7b05a0a2aa21a4054d2e36eeaea2cad0ed106ca446e46723b8fe3161837e408ee5e27d4cd827e0a75e69d43b877bacd1b80817cd50912e08e' }
    end
  end
end
