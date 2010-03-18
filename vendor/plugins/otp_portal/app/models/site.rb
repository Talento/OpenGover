class Site

  include Mongoid::Document
  field :name

  has_many_related :templates
  has_many :languages

  validates_presence_of :name, :languages, :templates

end