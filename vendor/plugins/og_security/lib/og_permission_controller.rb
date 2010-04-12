module OgPermissionController

def self.included(base)

  base.send :extend, ClassMethods
  base.send :include, InstanceMethods
  #base.helper JumpLinksHelper
  base.class_eval do

    load_and_authorize_resource

    rescue_from CanCan::AccessDenied do |exception|
      flash[:error] = "Access denied."
      redirect_to root_url
    end

  end
  
end

 module InstanceMethods

 end
 module ClassMethods

 end

end

ActionController::Base.send(:include, OgPermissionController)
