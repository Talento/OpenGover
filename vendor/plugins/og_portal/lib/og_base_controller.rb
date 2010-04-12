module OgBaseController

def self.included(base)

  base.send :extend, ClassMethods
  base.send :include, InstanceMethods
  #base.helper JumpLinksHelper
  base.class_eval do

    cattr_accessor :og_sites

    before_filter :og_set_params
    after_filter :og_add_layout

  end
  
end

 module InstanceMethods

   private

   def og_add_layout

     if response.content_type.to_s=="text/html" && !params[:og_template].blank?

#       final_response = response.body

       template_content = params[:og_template].content
       for block in params[:og_template].blocks
            texto_block = ""
                 for embedded_application in block.embedded_applications
                   texto_block += render_cell(embedded_application.cell_name.to_sym, embedded_application.cell_state.to_sym, embedded_application.cell_params)
                 end
            template_content = template_content.gsub("@@#{block.name}@@", texto_block)
       end

#       action_response = response.body.gsub(/(.*?)<body(.*?)>(.*?)<\/body>(.*?)/im){$3}
#
#       template_content.gsub!("@@main@@", action_response)
#       response.body.gsub!(/(.*?)<body(.*?)>(.*?)<\/body>(.*?)/im){"#{$1}<body#{$2}>#{template_content}</body>#{$4}"}

       response.body.gsub!(/(.*?)<body(.*?)>(.*?)<\/body>(.*?)/im){"#{$1}<body#{$2}>#{template_content.gsub("@@main@@", response.body.gsub(/(.*?)<body(.*?)>(.*?)<\/body>(.*?)/im){$3})}</body>#{$4}"}


       template_header = params[:og_template].header || ""
       response.body.gsub!(/<\/head>/im,template_header+"</head>")

#       response.body = final_response
     end
   end

   def og_set_params(template_name=nil)


    params[:og_site] = og_get_site

    #default_url_options[:og_site_id] = params[:og_site_id] unless params[:og_site_id].blank?
    #default_url_options[:og_locale] = params[:og_locale] unless params[:og_locale].blank?
    
    if !params[:og_locale].blank?
      I18n.locale = params[:og_locale]
    elsif params[:og_site].languages && params[:og_site].languages.size>0
      I18n.locale = params[:og_site].languages.first.locale
    end


      og_template = nil

      if template_name
        og_template = get_template template_name
      end

      @page = get_page_for_this_action
      if @page
        if og_template.blank?
          og_template = @page.template #unless layout
        end
        params[:og_page_title] = @page.name
        params[:og_page] = @page
        # Obtenemos el mapa de Google Maps
        # Esta variable sólo se sobreescribe cuando visitamos una página
        # que esté en la tabla pages
        session[:last_menu_page_id] = @page.id
      else
        params[:og_page_title] = ""
        params[:og_page] = nil  # importante para show_title y show_text
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
#     @og_embedded_applications = []
     if og_template # && og_template.blocks
     #for block in og_template.blocks
     #  @og_embedded_applications = @og_embedded_applications + block.embedded_applications
 #      for embedded_application in block.embedded_applications
 #        aux = render_cell(:page, :main_menu)

 #         eval("@content_for_" + block.name + " = render_cell(:menu, :main)")
 #      end
     #end
     params[:og_template] = og_template
      else
     end
                 #self.class.layout(og_select_layout)
   end

#   def og_select_layout
#     params[:og_template].blank? ? "application" : params[:og_template].layout_name
#   end

   def og_get_site
      og_load_sites unless self.og_sites

      if params[:og_site_id]
         params[:og_site] ||= self.og_sites.select {|site| site.id==params[:og_site_id]}.first || self.og_sites.first
      else
         params[:og_site] ||= self.og_sites.select {|site| site.domain==request.host || site.alias.include?(request.host)}.first || self.og_sites.first
      end
      params[:og_site]
   end

    def og_load_sites
        self.og_sites = Site.all
    end

  def get_template template_name
    template = Template.named_for_site(template_name, params[:og_site].id)
    template ? template : get_default_template
  end

  def get_default_template
    Template.main_for_site(params[:og_site].id) || Template.first
  end

  def get_page_for_this_action
    if controller?("pages") && action?("show")
      if params[:id]
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
      return params[:og_site].page_for_action(self.controller_name, request.path_parameters[:action])
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
    params[:og_site].first_public_page
  end

 end
 module ClassMethods

   def available_application(name, value)
     Page.available_application << {:name => name, :value => value} unless Page.available_application.include?({:name => name, :value => value}) 
   end
   
 end

end

ActionController::Base.send(:include, OgBaseController)
