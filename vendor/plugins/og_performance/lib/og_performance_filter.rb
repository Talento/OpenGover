class OgPerformanceFilter
  def initialize(app)
    @app = app
  end

  def call(env)
    @status, @headers, @response = @app.call(env)

    #Perform the cache


      if !@headers["Content-Type"].blank? && @headers["Content-Type"].include?("text/html")

        pag = PageCache.new()
        #pag.resources = params[:og_resources_log]
        pag.resources = ResourceLog.resources
        @path = env["PATH_INFO"]
        @path = @path.gsub("http://","")
        @path = @path.gsub(/^(.*?)\//,"") unless @path.starts_with?("/")
        pag.path = page_cache_file(@path)
        grid = Mongo::GridFileSystem.new(MongoMapper.database)
        grid.open(pag.path, 'w') do |f|
          f.write @response.body
        end
        pag.save

      end


    [@status, @headers, self]
  end

  def each(&block)
    #block.call("--#{@path}--\n") if @headers["Content-Type"].include? "text/html"
    @response.each(&block)
  end

  private
  
          def page_cache_file(path)
            name = (path.empty? || path == "/") ? "/index" : URI.unescape(path.chomp('/'))
            name << '.html' unless (name.split('/').last || name).include? '.'
            return name
          end
end
