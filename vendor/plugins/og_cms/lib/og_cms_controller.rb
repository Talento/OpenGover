module OgCmsController

def self.included(base)

  base.send :extend, ClassMethods
  base.send :include, InstanceMethods
  base.class_eval do

    before_filter :og_update_texts

  end
  
end

 module InstanceMethods

   private

   def og_update_texts
    for param in params.keys
      if param.starts_with?("show_contenido_")
        id = param.gsub("show_contenido_","")
        texto = Texto.find(id)
        texto_alt = params[param]
        texto.texto = texto_alt
        texto.editing_host = request.host_with_port
        texto.save

        flash[:notice] = "Content has successfully been updated"
      end
    end
   end

 end
 module ClassMethods

   
 end

end

ActionController::Base.send(:include, OgCmsController)
