module OgPerformanceController

  def self.included(base)

    base.send :extend, ClassMethods
    base.send :include, InstanceMethods
    #base.helper JumpLinksHelper
    base.class_eval do

      before_filter :og_set_performance_params
      #append_after_filter :og_write_cache
      #around_filter :og_send_params_to_resource_log

    end

  end

  module InstanceMethods

    private

  def og_send_params_to_resource_log
    klasses = [ResourceLog, ResourceLog.class]
    methods = ["params", "request"]

    methods.each do |shenanigan|
      oops = instance_variable_get(:"@_#{shenanigan}")

      klasses.each do |klass|
        klass.send(:define_method, shenanigan, proc { oops })
      end
    end

    yield

    methods.each do |shenanigan|
      klasses.each do |klass|
        klass.send :remove_method, shenanigan
      end
    end

  end

    def og_set_performance_params

      params[:og_resources_log] = []
      ResourceLog.resources = []

    end

    def og_write_cache

      if response.content_type.to_s=="text/html"

        pag = PageCache.new()
        #pag.resources = params[:og_resources_log]
        pag.resources = ResourceLog.resources
        path = request.url.gsub("http://","").gsub(request.host_with_port,"")
        pag.path = page_cache_file(page_cache_file(path))
        grid = Mongo::GridFileSystem.new(MongoMapper.database)
        grid.open(pag.path, 'w') do |f|
          f.write response.body
        end
        pag.save
        
      end
    end


          def page_cache_file(path)
            name = (path.empty? || path == "/") ? "/index" : URI.unescape(path.chomp('/'))
            name << page_cache_extension unless (name.split('/').last || name).include? '.'
            return name
          end

  end
  module ClassMethods

  end

end

ActionController::Base.send(:include, OgPerformanceController)
