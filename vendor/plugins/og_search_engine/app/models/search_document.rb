class SearchDocument

  include MongoMapper::Document

  key :doc_id, String
  key :doc_type, String

  many :search_terms
  
end