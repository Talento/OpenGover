module OgBaseSeoOptimizerController

  def self.included(base)

    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
    base.class_eval do
      after_filter :og_metas
      after_filter :og_conversions
    end

  end

  module InstanceMethods

    private

    def og_metas
      if response.content_type.to_s=="text/html" && !params[:og_template].blank? && !request.xhr?
        action_hash = ActionController::Routing::Routes.recognize_path(request.request_uri , :method => :get)
        metas = OgSeoOptimizer.og_metas
        if metas["site_#{params[:og_site].id}"] && metas["site_#{params[:og_site].id}"][params[:og_locale]] && metas["site_#{params[:og_site].id}"][params[:og_locale]]["enabled"]=="1"
          p = [action_hash[:controller], action_hash[:action],action_hash[:id]].compact.join("/")
          p="(blank)" if p.blank? || p=="pages/index"
          @meta = metas["site_#{params[:og_site].id}"][params[:og_locale]][p]
          unless @meta.blank?
            @meta.gsub!("@n@","\n") unless @meta.blank?
            @meta.gsub!("@2p@",":") unless @meta.blank?
          end
        end
        response.body.gsub!(/<\/head>/im, @meta+"</head>") unless @meta.blank?
      end
    end

    def og_conversions
      if response.content_type.to_s=="text/html" && !params[:og_template].blank? && !request.xhr?
        action_hash = ActionController::Routing::Routes.recognize_path(request.request_uri , :method => :get)
        conversions = OgSeoOptimizer.og_conversions
        if conversions["site_#{params[:og_site].id}"] && conversions["site_#{params[:og_site].id}"][params[:og_locale]] && conversions["site_#{params[:og_site].id}"][params[:og_locale]]["enabled"]=="1"
          p = [action_hash[:controller], action_hash[:action],action_hash[:id]].compact.join("/")
          p="(blank)" if p.blank? || p=="pages/index"
          @conversion = conversions["site_#{params[:og_site].id}"][params[:og_locale]][p]
          unless @conversion.blank?
            @conversion.gsub!("@n@","\n") unless @conversion.blank?
            @conversion.gsub!("@2p@",":") unless @conversion.blank?
          end
        end
        response.body.gsub!(/<\/body>/im, "<script type=\"text/javascript\">" + @conversion+"</script></body>") unless @conversion.blank?
      end
    end

  end
  module ClassMethods

  end
end

ActionController::Base.send(:include, OgBaseSeoOptimizerController)
