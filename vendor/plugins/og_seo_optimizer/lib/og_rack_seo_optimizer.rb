class OgRackSeoOptimizer
  
  def initialize(app)
    @app = app
  end

  def call(env)
    if !env["HTTP_X_FORWARDED_HOST"].blank?
      host = env["HTTP_X_FORWARDED_HOST"].split(':').first
    else
      host = env["HTTP_HOST"].split(':').first
    end
    path = env['PATH_INFO']
    begin
      action_hash = ActionController::Routing::Routes.recognize_path(path, :method => :get)
      unless action_hash[:og_site_id].blank?
        site = Site.find(action_hash[:og_site_id]) || Site.first
      else
        site = Site.all.select{|site| site.domain==host || site.alias.include?(host)}.first || Site.first
      end
      unless action_hash[:og_locale].blank?
        lang = site.languages.collect{|item| item if item.locale==action_hash[:og_locale]}.first || site.languages.first
      else
        lang = site.languages.first
      end
      locale = lang.locale
      if OgSeoOptimizer.og_redirections["site_#{site.to_param}"] && OgSeoOptimizer.og_redirections["site_#{site.to_param}"][locale] && (OgSeoOptimizer.og_redirections["site_#{site.to_param}"][locale]["enabled"]=="1")
        p = path
        p.gsub! %r(%2F), '/'
        p.sub!(%r(/(.*?))){"#{$1}"} if p.starts_with?("/")
        p.sub!(%r((.*?)/)){"#{$1}"} if p.ends_with?("/")
        unless OgSeoOptimizer.og_redirections["site_#{site.to_param}"][locale].invert[p].blank?
          path.gsub!(p,OgSeoOptimizer.og_redirections["site_#{site.to_param}"][locale].invert[p])
        else
          OgSeoOptimizer.og_redirections["site_#{site.to_param}"][locale].invert.each do |key, value|
            if key.to_s.include?("*")
              re_from = key.gsub("*","(.*?)")
              re_from.gsub!("/","\/")
              if p.match(%r(^#{re_from}))
                v = p.gsub(%r(^#{re_from}), $1)
                path.sub!(p, value.gsub("*",v))
              end
            end
          end
        end
        env['REQUEST_URI'] = "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}/#{path}"
      end
    rescue
    end
    @app.call(env)
  end
end