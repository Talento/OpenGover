module OgUserActivityController

  def self.included(base)

    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
    base.class_eval do
      before_filter :og_user_activity
    end

  end

  module InstanceMethods

    private

    def og_user_activity
      unless params[:og_user].blank?
        params_activity = params.clone
        params_activity.delete_if {|key| key=~/^og_/}
        Activity.new(:user_id => params[:og_user].id, :url => request.path, :params => params_activity.inspect).save
      end
    end

  end
  module ClassMethods

  end
end

ActionController::Base.send(:include, OgUserActivityController)
