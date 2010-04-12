class EmbeddedApplication

  include MongoMapper::EmbeddedDocument
  key :name, String, :required => true
  key :cell_name, String, :required => true
  key :cell_state, String, :required => true
  key :cell_params, Hash, :default => {}
#  key :block_id, ObjectId

#  belongs_to :block, :inverse_of => :embedded_applications


  @@available = []
  
    cattr_accessor :available

  def block
    self._parent_document
  end

end