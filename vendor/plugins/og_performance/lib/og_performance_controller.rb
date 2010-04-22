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

    end

  end
  module ClassMethods

  end

end

ActionController::Base.send(:include, OgPerformanceController)
