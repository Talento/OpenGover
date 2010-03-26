module OgBaseController

def self.included(base)

  base.extend ClassMethods
  base.send :include, InstanceMethods
  #base.helper JumpLinksHelper
  base.class_eval do

    cattr_accessor :og_sites

    before_filter :og_layout
    layout :og_select_layout
  end
  
end

 module InstanceMethods

   private

   def og_layout
    params[:site] = og_get_site

   end

   def og_select_layout(template_name=nil)

     og_template = nil

      if template_name
        og_template = get_template template_name
      end

      @page = get_page_for_this_action
      if @page
        if og_template.blank?
          og_template = @page.template #unless layout
        end
        params[:page_title] = @page.name
        params[:page] = @page
        # Obtenemos el mapa de Google Maps
        # Esta variable sólo se sobreescribe cuando visitamos una página
        # que esté en la tabla pages
        session[:last_menu_page_id] = @page.id
      else
        params[:page_title] = ""
        params[:page] = 0  # importante para show_title y show_text
        og_template = get_default_template unless og_template
      end

#      session[:action] = request.parameters[:action]
#      session[:layout_name] = "#{session[:site_id]}_" + layout.name
#      session[:controller_name] = request.parameters[:controller]
#      session[:object_id] = params[:id]

#      @layout = layout
#      #Guaramos en sesion el ultimo layout usado. Es necesario para la tienda. El if hace falta pq en IE chifla...
#      session[:last_layout_id] = layout.id if request.path_parameters[:controller] != "search" and request.path_parameters[:action] !=  "opensearch"
#
#
#      #Obtengo los bloques que tengo que rellenar en el layout
#      #Para cada bloque obtengo el código generado
#      @blocks = @layout.blocks


     #site = Site.first
     #@template = site.templates.first
     #og_template = Template.main_for_site(params[:site].id)
     @og_embedded_applications = []
     for block in og_template.blocks
       @og_embedded_applications = @og_embedded_applications + block.embedded_applications
 #      for embedded_application in block.embedded_applications
 #        aux = render_cell(:page, :main_menu)

 #         eval("@content_for_" + block.name + " = render_cell(:menu, :main)")
 #      end
     end
     og_template.layout_name
   end

   def og_get_site
      og_load_sites unless self.og_sites

      if params[:site_id]
         params[:site] ||= self.og_sites.select {|site| site.id==params[:site_id]}.first || self.og_sites.first
      else
         params[:site] ||= self.og_sites.select {|site| site.domain==request.host || site.alias.include?(request.host)}.first || self.og_sites.first
      end
      params[:site]
   end

    def og_load_sites
        self.og_sites = Site.find :all
    end

  def get_template template_name
    template = Template.named_for_site(template_name, params[:site].id)
    template ? template : get_default_template
  end

  def get_default_template
    Template.main_for_site(params[:site].id)
  end

  def get_page_for_this_action
    if controller? "pages"
      if params[:id] && action?("index")
        return get_page(params[:id])
      else
        return get_first_public_page
      end
#    elsif self.controller_name=="contents" && !request.path_parameters[:content_slug].blank?
#      action = request.path_parameters[:content_slug]
#    elsif self.controller_name=="formcontacts"
#      if request.path_parameters[:id].blank?
#        action = request.path_parameters[:action]
#      else
#        action = request.path_parameters[:action] + "/" + request.path_parameters[:id]
#      end
    else
      #busco si existe una página asociada a ese controller#action
      return params[:site].page_for_action(self.controller_name, request.path_parameters[:action])
    end
  end

   def controller? name
    self.controller_name == name
  end

  def action? name
    request.path_parameters[:action] == name
  end

  def get_page id
    Page.find(id)
  end

  def get_first_public_page
#    site_id = session[:site_id] || get_site #Site.find(:first).id
    #Page.find(:first, :conditions => "pages.site_id = #{site_id} and parent_id = 0 and lang = '#{lang}' and publico = 1", :order => "pages.position", :include =>  {:layout => {:blocks => :blockelements}})
#    Cms.find_first_public_page_by_site_id(site_id)
    params[:site].first_public_page
  end

 end
 module ClassMethods
 end

end

ApplicationController.send(:include, OgBaseController)
