  class ResourceLog

    @@resources = []

    cattr_accessor :resources

    #def self.resources
    #  @@resources
    #end
    #def self.resources=(value)
    #  @@resources = value
    #end

    def self.add_resource(model,id)
      txt = "#{model}\##{id.to_s}"
      txt_all = "#{model}\#all"
      if id==:all
        #params[:og_resources_log].delete_if{|resource| resource.ends_with?("#{model}\#")}
#        @@resources.delete_if{|resource| resource.ends_with?("#{model}\#")}
      end
      #params[:og_resources_log] << txt unless params[:og_resources_log].include?(txt)
      @@resources << txt #unless @@resources.include?(txt) || @@resources.include?(txt_all) 
    end

    def self.clear_cache_for(class_name,id)
      
    end

  end