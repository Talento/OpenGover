  class Activity

    include MongoMapper::Document

    key :user_id, String
    key :url, String
    key :params, String
    timestamps!

  end