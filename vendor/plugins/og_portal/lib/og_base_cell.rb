module OgBaseCell

def self.included(base)

  base.send :extend, ClassMethods
  base.send :include, InstanceMethods
  #base.helper JumpLinksHelper
  base.class_eval do

  end
  
end

 module InstanceMethods


 end
 module ClassMethods

   def embedded_application(value)
     EmbeddedApplication.available << EmbeddedApplication.new(value) unless EmbeddedApplication.available.collect(&:name).include?(value[:name])
   end
   
 end

end

Cell::Base.send(:include, OgBaseCell)
