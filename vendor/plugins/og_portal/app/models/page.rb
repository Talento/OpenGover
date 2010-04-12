class Page

  include MongoMapper::Document
  include Slug
  include Sortable

  key :name, String, :required => true
  key :application, Hash, :default => {}, :required => true
  key :parent_id, String
  key :description, String
#  key :position, Integer
  key :in_menu, Boolean, :default => false
  key :published, Boolean, :default => false
  key :public, Boolean, :default => true
  key :link, String, :default => ""
  key :template_id, ObjectId, :required => true
  key :site_id, ObjectId, :required => true

  slug :name
  sortable :parent_id

#  belongs_to_related :template
#  belongs_to_related :site

  belongs_to :template
  belongs_to :site


  @@available_application = []

    cattr_accessor :available_application

#  validates_presence_of :template, :site

  def parent
    self.find(self.parent_id)
  end

  def children
    Page.all(:parent_id => self.id)
  end
  def published_children
    Page.all(:parent_id => self.id, :published => true)
  end
  def published_in_menu_children
    Page.all(:parent_id => self.id, :in_menu => true, :published => true)
  end

  def application_text
    self.application.inspect
  end

  def application_text=(value)
    self.application = eval(value)
  end

#  def move_higher
#    p = Page.first(:position => self.position-1, :parent_id => self.parent_id)
#    p.position += 1
#    p.save
#
#    self.position -= 1
#    self.save
#  end
#
#  def move_lower
#    p = Page.first(:position => self.position+1, :parent_id => self.parent_id)
#    p.position -= 1
#    p.save
#
#    self.position += 1
#    self.save
#  end
#
#  def before_create
#    self.position = Page.count(:parent_id => self.parent_id)
#  end
#
#  def before_destroy
#    hash = {}
#    Page.where(:position.gt => self.position).and(:parent_id => self.parent_id).each_with_index do |p, index|
#      hash[p.id] = {:position => p.position - 1}
#    end
#    Page.update(hash)
#  end

    def url
    if !self.application.blank?
      return url_for_first_children if application[:controller]=="pages" && application[:action]=="first_children"
      return application
    elsif !self.link.blank?
         enlace = self.link
            if !enlace.starts_with?("/")
                enlace = 'http://' + enlace unless (enlace.starts_with?('http://') || enlace.starts_with?('/'))
            end
      return enlace
    else
      return {:controller => :pages, :action => :index, :id => self.to_param}
    end
  end

  def url_for_first_children
    if self.published_children && self.published_children.size > 0
      for page in self.published_children
        #if Cms.user
        #  return page.url if page.permission_for_user?(Cms.user)
        #else
          return page.url #if page.publico
        #end
      end
    end
    return {:controller => :pages, :action => :index, :id => self.to_param}
  end

end