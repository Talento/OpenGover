class Block

  include MongoMapper::EmbeddedDocument

  key :name, String, :required => true
#  key :template_id, ObjectId

#  belongs_to :template, :inverse_of => :blocks
#  has_many :embedded_applications
  
  many :embedded_applications


end