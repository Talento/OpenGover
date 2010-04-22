class PageCache
  include MongoMapper::Document
  plugin Joint

  key :resources, Array
  key :path, String


  belongs_to :user

  after_destroy :delete_file

  def delete_file

        grid = Mongo::GridFileSystem.new(MongoMapper.database)
        grid.delete(self.path)
    
  end

end
