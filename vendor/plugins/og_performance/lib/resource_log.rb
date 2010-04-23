  class ResourceLog

    @@resources = []
    @@perform_caching = true

    cattr_accessor :resources
    cattr_accessor :perform_caching

    #def self.resources
    #  @@resources
    #end
    #def self.resources=(value)
    #  @@resources = value
    #end

    def self.add_resource(model,id)
      unless model=="PageCache"
      txt = "#{model}\##{id.to_s}"
      txt_all = "#{model}\#all"
      if id==:all
        #params[:og_resources_log].delete_if{|resource| resource.ends_with?("#{model}\#")}
        @@resources.delete_if{|resource| resource.starts_with?("#{model}\#")}
      end
      #params[:og_resources_log] << txt unless params[:og_resources_log].include?(txt)
      @@resources << txt unless @@resources.include?(txt) || @@resources.include?(txt_all)
        end
    end

    def self.clear_cache_for(model,id)

      unless model=="PageCache"
      txt = "#{model}\##{id.to_s}"
      txt_all = "#{model}\#all"
        for pc in PageCache.all(:resources.in => [txt, txt_all])
          pc.destroy
        end
      end
    end

  end