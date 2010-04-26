# coding: iso-8859-1

class Demotext
  include MongoMapper::Document
  include Searchable

  key :title, String
  key :texto, String
  key :summary, String

  searchable :title, {:title => 50, :summary => 25}

  def roles
    %w[none admin moderator author banned]
  end

end
