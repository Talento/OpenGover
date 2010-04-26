class SetCookieDomain
 def initialize(app)
   @app = app
 end
 def call(env)
   if !env["HTTP_X_FORWARDED_HOST"].blank?
    host = env["HTTP_X_FORWARDED_HOST"].split(':').first
   else
    host = env["HTTP_HOST"].split(':').first
   end
   if !host =~ /^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})?$/
   if host.include?(".") && host.scan(/\./).size>=2
     env["rack.session.options"][:domain] = host.gsub(/.*\.(.*?)\.(.*?)/){".#{$1}.#{$2}"}
   elsif host.scan(/\./).size==1
     env["rack.session.options"][:domain] = ".#{host}"
   end
   end
   @app.call(env)
 end
end
