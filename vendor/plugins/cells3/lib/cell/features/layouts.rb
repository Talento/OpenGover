module Cell
  module Features
    module Layouts
      extend ActiveSupport::Concern

      include AbstractController::Layouts

      module ClassMethods
        def _implied_layout_name
          cell_name 
        end
      end

    end
  end
end
