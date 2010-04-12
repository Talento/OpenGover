class MenuCell < Cell::Base


  embedded_application(:name => "Main menu", :cell_name => "menu", :cell_state => "main", :cell_params => {})
  embedded_application(:name => "Secondary menu", :cell_name => "menu", :cell_state => "secondary", :cell_params => {})

  def main
    #@page_id ||= params[:og_page].id
    site_id = params[:og_site].id
    #page = nil
    # page = Page.find(@page_id) if @page_id!=0
    # @family_ids = page ? page.family_ids : []
     @pages = Page.all(:order =>"position", :site_id => site_id, :parent_id => "")
      render
  end
      def secondary
        #@page_id ||= get_page request
        # Si no estamos viendo una página, no muestra nada el menú
        if params[:og_page].blank?
            render :text => ""
        else

                # Si estamos en una página, el menú muestra las hijas de la página que es la página raíz
                # antecesora de la página actual.
                #page = Page.find(@page_id)
                #@family_ids = page.family_ids
                @pages = params[:og_page].published_in_menu_children #page.root_page.children
            render
        end
    end
end
