class Site

  include MongoMapper::Document
  key :name, String, :required => true
  key :domain, String
  key :alias, Array, :default => []
#  key :template_id, ObjectId, :required => true
#  key :page_id, ObjectId, :required => true

#  has_many_related :templates
#  has_many_related :pages
#  has_many :languages
  
  many :languages
  many :templates
  many :pages

  validates_presence_of :languages, :templates

  def first_public_page
    Page.first(:site_id => self.id, :public => true)
  end

  def page_for_action(controller_name, action_name = "index")
    Page.first("application.controller" => controller_name, "application.action" => action_name, :site_id => self.id)
  end

end