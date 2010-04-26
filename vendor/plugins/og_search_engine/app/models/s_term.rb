class STerm

  include MongoMapper::Document

  key :_id, String, :required => true
  key :rarity, Float

  many :s_documents

end