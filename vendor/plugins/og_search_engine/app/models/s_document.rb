class SDocument

  include MongoMapper::EmbeddedDocument

  key :s_indexed_document_id, ObjectId
  key :weight, Integer, :default => 50
  key :roles, Array, :default => %w[all]

  belongs_to :s_indexed_documents

end