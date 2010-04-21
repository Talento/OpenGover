# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)
require(File.dirname(__FILE__) + "/../../config/initializers/mongomapper") unless defined?(Rails)

require 'mongo'
#require 'mongo/gridfs'
require "rmagick"
require 'fileutils'

include Mongo
#include GridFS

class MongoFiles
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/uploads\/images\/(.+)$/
      width = 0
      height = 0
      key = ""
      env["PATH_INFO"].gsub(/\?.*/,"").gsub(/^\/uploads\/images\/c?(\d*)x(\d*)_v(.*?)_(.*?)\.(.*?)$/){
        width = $1
        height = $2
        key =   $4
      }
      crop = true if env["PATH_INFO"] =~ /^\/uploads\/images\/c(.+)$/
      begin
        file = Mongo::Grid.new(MongoMapper.database).get(BSON::ObjectID.from_string(key))

     # if GridStore.exist?(MongoMapper.database,key)
     #     GridStore.open(MongoMapper.database, key, 'r') do |file|


#    img = ::Magick::Image.from_blob(file.read).first
#    resized = img.crop_resized(width,height)
        resized = file
                                                    #resized = nil
    ##ImageScience.with_image_from_memory(file.read) do |img_file|
    ##   resized = img_file.resize(width.to_i,height.to_i) do |f|
        ##FileUtils.mkdir_p(Rails.public_path + env["PATH_INFO"])
        ##f.save(Rails.public_path + env["PATH_INFO"])
    ##  end
    ##end
    ##resized_image = File.open(Rails.public_path + env["PATH_INFO"],'r')
    ##[200, {"Content-Type" => MIME::Types.type_for(resized_image.path).first.content_type}, [resized_image.read]]

              [200, {"Content-Type" => file.content_type}, [resized.read]]
            #end
      rescue
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
        end
    elsif env["PATH_INFO"] =~ /^\/uploads\/files\/v(.*?)_(.*?)\.(.*?)$/
      key=$2
      begin
        file = Mongo::Grid.new(MongoMapper.database).get(BSON::ObjectID.from_string(key))
      #if GridStore.exist?(MongoMapper.database,key)
      #    GridStore.open(MongoMapper.database, key, 'r') do |file|
              [200, {"Content-Type" => file.content_type}, [file.read]]
      #      end
      #else
      rescue
        [404, {"Content-Type" => "text/html"}, ["Not Found"]]
        end
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end


    private
    def connect!
      Timeout::timeout(5) do
        @db = Mongo::Connection.new(hostname).db(database)
      end
    rescue StandardError => e
      raise ConnectionError, "Timeout connecting to GridFS (#{e.to_s})"
    end
  
end
