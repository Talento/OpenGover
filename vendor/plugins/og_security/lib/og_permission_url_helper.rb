module OgPermissionUrlHelper

  def self.included(base)
        base.alias_method_chain :link_to, :permissions
    end

    # Determina si el usuario actual tiene permiso para ver un enlace o no
    # y no lo pinta en caso de que no lo tenga.
    def link_to_with_permissions(name, options = {}, html_options = {})
        url = case options
        when String
            options
        when :back
            @controller.request.env["HTTP_REFERER"] || 'javascript:history.back()'
        else
            self.url_for(options)
        end

        method = if html_options.is_a?(Hash) && html_options[:method]
            html_options[:method]
        else
            :get
        end

        # Por si salta una excepción al reconocer una ruta que no tiene controller
        action_hash = options
        begin
            action_hash = ActionController::Routing::Routes.recognize_path(url.gsub(/\?(.*)/,""), :method => method)
        rescue
        end

        controller = action_hash[:controller] || request.path_parameters[:controller]
        controller = request.path_parameters[:controller] if controller.blank?
        action = action_hash[:action]
        id = action_hash[:id]

#        user = current_user
#        user = nil
#        begin
#          user = current_user
#        rescue
#        end


      if id.blank?
        permission = @controller.can?(action.to_sym,controller.to_s.singularize.camelize.constantize) #Permission.for(user, action, controller ,'', id)
logger.fatal "---------------------- #{action.to_sym} #{controller.to_s.singularize.camelize} -> #{permission}"
      else
        permission = @controller.can?(action.to_sym,controller.to_s.singularize.camelize.constantize.find(id))
logger.fatal "---------------------- #{action.to_sym} id(#{id}) -> #{permission}"
logger.fatal "----------------------******* #{@controller.can?(:new, Registration)}"
      end

        if permission
            ante_link = ""
            post_link = ""
            if html_options[:before]
                ante_link = html_options[:before]
                html_options.delete(:before)
            end
            if html_options[:after]
                post_link = html_options[:after]
                html_options.delete(:after)
            end
#            if user
#                if options.instance_of?(String)
#                        options = ("/private/#{user.login}/" + options).gsub("//","/") unless options.include? "/private/#{user.login}/"
#                else
#                        options[:user_login]=user.login
#                end
#            end
            return ante_link + link_to_without_permissions(name, options, html_options) + post_link
        else
            ""
        end
    end


end


ActionView::Helpers::UrlHelper.send(:include,  OgPermissionUrlHelper)