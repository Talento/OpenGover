class TextosCell < Cell::Base

  include Devise::Controllers::Helpers
  include CanCan::ControllerAdditions

  embedded_application(:name => "Editable content", :cell_name => "textos", :cell_state => "show_text", :cell_params => {})
  embedded_application(:name => "Editable static content", :cell_name => "textos", :cell_state => "show_text_static", :cell_params => {})
  embedded_application(:name => "Page title", :cell_name => "textos", :cell_state => "show_page_title", :cell_params => {})


	def show_text
		@text = ""
        block_name = @opts[:block_name]
		c_name = @opts[:controller_name]
		if !params[:og_page].blank?
			@texto = Texto.find_by_page_and_block_name(params[:og_page],block_name)
			if @texto
				@text = @texto.texto
			else
				@texto = Texto.create(:page_id => params[:og_page].id, :block_name => block_name, :texto => "", :site_id => params[:og_site].id, :locale => I18n.locale)
			end
		else
			@texto = Texto.find_by_application_and_block_name({:controller => c_name, :action => request.parameters[:action]},block_name)
			if @texto
				@text = @texto.texto
			else
				@texto = Texto.create(:block_name => block_name, :application =>  {:controller => c_name, :action => request.parameters[:action]}, :texto => "", :site_id => params[:og_site].id, :locale => I18n.locale)
			end
		end
#    id = "galeria_show_contenido_#{@texto.id}"
#    @galeria = Galeria.first(:conditions => ["div_id=?", id])
#    @texto_galeria = self.send(:embed_action_as_string, :controller => "galerias", :action => "show", :div_id => id)
#
#    # Google Maps
#    id = "gmap_show_contenido_#{@texto.id}"
#    @mapa = Gmap.first(:conditions => ["div_id=?", id])
#    @texto_gmap = self.send(:embed_action_as_string, :controller => "gmaps", :action => "show", :id => @mapa.id) if @mapa
#
#    unless @texto_gmap.blank?
#      Cms.load_gmap = true
#    end
#    if (logged_in? && Permission.for(Cms.user, "edit", "textos", "", @texto.id))
#      Cms.gmap_permissions = true
##      Cms.load_gmap = true
#    end

      @texto_galeria = ""
      @texto_gmap = ""

        render
	end

	def show_text_static
		block_name = @opts[:block_name]
		@text = ""
		@texto = Texto.find_by_application_and_block_name_and_site({:controller => "textos", :action => 'static'}, block_name, params[:og_site])
		if @texto
			@text = @texto.texto
		else
			@texto = Texto.create(:application => {:controller => "textos", :action => 'static'}, :block_name => block_name, :texto => "", :site_id => params[:og_site].id, :locale => I18n.locale)
        end

#    id = "galeria_show_contenido_#{@texto.id}"
#    @galeria = Galeria.first(:conditions => ["div_id=?", id])
#    @texto_galeria = self.send(:embed_action_as_string, :controller => "galerias", :action => "show", :div_id => id)
#
#    # Google Maps
#    id = "gmap_show_contenido_#{@texto.id}"
#    @mapa = Gmap.first(:conditions => ["div_id=?", id])
#    @texto_gmap = self.send(:embed_action_as_string, :controller => "gmaps", :action => "show", :id => @mapa.id) if @mapa
#		render :state => "show_text"
#
      @texto_galeria = ""
      @texto_gmap = ""

	end



	def show_page_title
		@text = ""
		block_name = @opts[:block_name]
		c_name = @opts[:controller_name]
		if session[:page] != 0
      page = Page.first :conditions => ["id=?",session[:page] ]
			@texto = Texto.find_by_page_id_and_block_name(session[:page],block_name)
			if @texto
				@text = @texto.texto
			else
        texto=""
        texto = page.title if page
				@texto = Texto.create(:page_id => session[:page], :block_name => block_name, :controller => c_name, :action => session[:action], :texto => texto)
				@text = @texto.texto
			end
		else
			@texto = Texto.find_by_controller_and_action_and_block_name(c_name,session[:action],block_name)
			if @texto
				@text = @texto.texto
			else
				@texto = Texto.create(:page_id => session[:page], :block_name => block_name, :controller => c_name, :action => session[:action], :texto => "")
			end
		end

		render
	end
end
