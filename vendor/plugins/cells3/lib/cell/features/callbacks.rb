module Cell
  module Features
    module Callbacks
      extend ActiveSupport::Concern

      include AbstractController::Callbacks
    end
  end
end
