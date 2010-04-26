class SIndexedDocument

  include MongoMapper::Document

  key :doc_id, String
  key :doc_type, String
  key :title, String

  many :s_documents

end