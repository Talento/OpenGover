class Language

  include Mongoid::Document
  field :name
  field :locale

  belongs_to :site, :inverse_of => :languages

  validates_presence_of :name, :locale, :site
  validates_inclusion_of :locale, :in => I18n.available_locales.collect(&:to_s)
end