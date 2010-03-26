class Site

  include Mongoid::Document
  field :name
  field :domain
  field :alias, :type => Array, :default => []

  has_many_related :templates
  has_many_related :pages
  has_many :languages

  validates_presence_of :name, :languages, :templates

  def first_public_page
    Page.where(:site_id => self.id, :public => true).first
  end

  def page_for_action(controller_name, action_name = "index")
    self.where("application.controller" => controller_name, "application.action" => action_name, :site_id => self.id).first
  end

end