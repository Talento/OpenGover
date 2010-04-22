# Include hook code here

require "og_performance"
require "og_performance_controller"
require "og_resources_log"


module Devise
  module Controllers
    autoload :Helpers, 'og_redirect_after_login'
  end
end