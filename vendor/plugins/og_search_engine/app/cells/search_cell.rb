class SearchCell < Cell::Base

  include Devise::Controllers::Helpers

  embedded_application(:name => "Search form", :cell_name => "search", :cell_state => "form", :cell_params => {})

  def form
      render
  end

end
