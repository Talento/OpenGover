class PageCache
  include MongoMapper::Document
  plugin Joint

  key :resources, Array
  key :path, String


  belongs_to :user

end
