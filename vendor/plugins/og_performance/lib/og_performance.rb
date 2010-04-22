#module OgPerformance
#  class Engine < ::Rails::Engine
##    config.devise = Devise
#
#    initializer "og_performance.add_middleware" do |app|
#
#      app.config.middleware.use 'OgPerformanceFilter'
#      app.config.middleware.insert_after 'Warden::Manager', 'PrivateCache'
##
##      app.config.middleware.use Warden::Manager do |config|
##        Devise.warden_config = config
##        config.failure_app   = Devise::FailureApp
##        config.default_scope = Devise.default_scope
##      end
#    end
#
##    initializer "devise.add_url_helpers" do |app|
##      Devise::FailureApp.send :include, app.routes.url_helpers
##      ActionController::Base.send :include, Devise::Controllers::UrlHelpers
##      ActionView::Base.send :include, Devise::Controllers::UrlHelpers
##    end
#
##    config.after_initialize do
##      I18n.available_locales
##      flash = [:unauthenticated, :unconfirmed, :invalid, :invalid_token, :timeout, :inactive, :locked]
##
##      I18n.backend.send(:translations).each do |locale, translations|
##        keys = flash & (translations[:devise][:sessions].keys) rescue []
##
##        if keys.any?
##          ActiveSupport::Deprecation.warn "The following I18n messages in 'devise.sessions' " <<
##            "for locale '#{locale}' are deprecated: #{keys.to_sentence}. Please move them to " <<
##            "'devise.failure' instead."
##        end
##      end
##    end
#  end
#end

Rails.configuration.after_initialize do
  #require "devise/orm/#{Devise.orm}"

  # Adds Warden Manager to Rails middleware stack, configuring default devise
  # strategy and also the failure app.
#  Rails.configuration.middleware.use Warden::Manager do |config|
#    Devise.configure_warden(config)
#  end

      Rails.configuration.middleware.use 'OgPerformanceFilter'
      Rails.configuration.middleware.insert_after 'Warden::Manager', 'PrivateCache'

  #I18n.load_path.unshift File.expand_path(File.join(File.dirname(__FILE__), 'locales', 'en.yml'))
end