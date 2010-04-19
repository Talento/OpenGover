# encoding: utf-8

#require 'slug/acts_as_slug'

#  module Slug
#    def self.included(base)
#      base.class_eval do
#        field :slug
#        key :slug
#        has_many :versions, :class_name => self.name
#        before_save :revise
#        include InstanceMethods
#      end
#    end
#    module InstanceMethods
#      # Create a new version of the +Document+. This will load the previous
#      # document from the database and set it as the next version before saving
#      # the current document. It then increments the version number.
#      def revise
#        last_version = self.class.first(:conditions => { :_id => id, :version => version })
#        if last_version
#          self.versions << last_version.clone
#          self.version = version + 1
#        end
#      end
#    end
#  end

module Slug
  def self.included(base)
    base.send :extend, ClassMethods
    base.class_eval do
    end
  end

  module ClassMethods
    def slug(field_for_slug)
      cattr_accessor :slug_field
      self.slug_field = field_for_slug

#      validates_presence_of field_for_slug
      #key :slug, String
      key :_id, String, :index => true
      before_create :create_slug

      send :include, InstanceMethods
    end
  end

  module InstanceMethods

#    private
    
    def create_slug
#      if self.id.blank?
        self.id = self.send(slug_field).sluggerize
        if self.class.all(:id => self.id).count > 0
          n = 1
          for t in self.class.all(:id => "/" + self.id + "-([0-9]*)/")
            template_number = t.slug.scan(Regexp.new(self.id + "-([0-9]*)/")).flatten.first.to_i
            n = template_number if template_number > n
          end
          n+=1
          self.id += "-#{n}"
        end
#        self._id = self.id
#      end
    end

  end
end
