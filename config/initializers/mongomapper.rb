#File.open(File.join(Rails.root, 'config/database.mongo.yml'), 'r') do |f|
  File.open(File.expand_path('../../database.mongo.yml',__FILE__), 'r') do |f|

  @settings = YAML.load(f)[Rails.env]
end

#Mongoid.configure do |config|
#  name = @settings["database"]
#  host = @settings["host"]
#  config.master = Mongo::Connection.new.db(name)
#  #config.slaves = [
#  #  Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#  #  Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#  #]
#end

MongoMapper.connection = Mongo::Connection.new(@settings["host"])
MongoMapper.database = @settings["database"]