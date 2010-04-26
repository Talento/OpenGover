class SearchTerm

  include MongoMapper::EmbeddedDocument

  key :term, String, :required => true
  key :weight, Integer, :default => 50
  key :rarity, Float

end