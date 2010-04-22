class PrivateCache
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/private\/(.+)$/
      user_login = env["PATH_INFO"].gsub(/\?.*/,"").gsub(/^\/private\/(.*?)\/?/){$1}
      if env["warden"].authenticated? && env["warden"].user.id==user_login
        begin
          file = Mongo::GridFileSystem.new(MongoMapper.database).open(page_cache_file(env["PATH_INFO"].gsub(/\?.*/,"")),'r')
              [200, {"Content-Type" => file.content_type}, [file.read]]
        rescue
          @app.call(env)
        end
      else
        @app.call(env)
      end
    else
       @app.call(env)
    end
  end

  private

          def page_cache_file(path)
            name = (path.empty? || path == "/") ? "/index" : URI.unescape(path.chomp('/'))
            name << '.html' unless (name.split('/').last || name).include? '.'
            return name
          end

end
