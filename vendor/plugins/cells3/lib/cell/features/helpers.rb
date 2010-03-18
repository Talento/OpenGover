module Cell
  module Features
    module Helpers
      extend ActiveSupport::Concern

      included do
        include AbstractController::Helpers
        helper ApplicationHelper 

        delegate :request_forgery_protection_token, :allow_forgery_protection, 
          :form_authenticity_token, :protect_against_forgery?, :to => :parent_controller
        helper_method :protect_against_forgery?, :form_authenticity_token
      end

    end
  end
end
