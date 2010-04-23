module OgPerformanceController

  def self.included(base)

    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
    base.class_eval do

      before_filter :og_set_performance_params

    end

  end

  module InstanceMethods

    def user_root_path
      url_for({:controller => 'pages', :action => 'show', :og_user_login => current_user.id})
    end
              
    private

    def og_set_performance_params

#      params[:og_resources_log] = []
      ResourceLog.resources = []
      ResourceLog.perform_caching = true
      ResourceLog.perform_caching = false if request.request_uri =~ /\/signups\//
      ResourceLog.perform_caching = false if user_signed_in? && !(request.request_uri =~ /\/private\//)
      ResourceLog.perform_caching = false unless request.get? #if params[:method].to_s!="get"

    end

  end
  module ClassMethods

  end

end

ActionController::Base.send(:include, OgPerformanceController)
