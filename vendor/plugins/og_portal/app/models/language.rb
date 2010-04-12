class Language

  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
  key :locale, String, :required => true
#  key :site_id, ObjectId, :required => true

#  belongs_to :site, :inverse_of => :languages

#  validates_presence_of :site
#  validates_inclusion_of :locale, :in => I18n.available_locales.collect(&:to_s)
  validate :valid_locale

   private
     def valid_locale
       errors.add(:locale, "Invalid locale") unless I18n.available_locales.collect(&:to_s).include?(self.locale) 
     end
end