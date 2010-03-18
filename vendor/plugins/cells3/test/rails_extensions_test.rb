require File.dirname(__FILE__) + '/../../../../test/test_helper'
require File.dirname(__FILE__) + '/testing_helper'

class ACell < Cell::Base
  def existing_view
    @a = "a"
    render
  rescue Exception => e
    puts e.message
    puts e.backtrace.join("\n")
  end
end

### DISCUSS: rename file. just found out that rails automagically tries to load a file named
### after the test, which fails with RailsExtensions.

class RenderCellTest < ActionController::TestCase
  include CellsTestMethods
  
  def test_render_cell
    assert_equal "A/existing_view/a", @controller.render_cell(:a, :existing_view)
  end
  
  # #render_cell_to_string is just an alias of #render_cell
  def test_render_cell_to_string
    assert_equal @controller.render_cell_to_string(:a, :existing_view), @controller.render_cell(:a, :existing_view)
  end
end
