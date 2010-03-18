module Cell
  class View < ::ActionView::Base

    alias :cell :controller
    delegate :render, :to => :cell

  end
end
