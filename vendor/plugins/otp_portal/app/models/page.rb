class Page

  include Mongoid::Document
  include Slug
  field :name
  field :application, :type => Hash
  field :parent_id
  field :description
  field :position, :type => Integer
  field :in_menu, :type => Boolean, :default => false
  field :public, :type => Boolean, :default => true
  field :link, :default => ""
  
  slug :name

  belongs_to_related :template
  belongs_to_related :site

  validates_presence_of :name, :application, :template, :site

  def parent
    self.find(self.parent_id)
  end

  def children
    self.where(:parent_id => self.id)
  end
end