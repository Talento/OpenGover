# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
OpenTalentCms::Application.initialize!

# Desde aqu� sobrar�a, pero en modo test no coge los initializers ??????
#if Rails.env=="test"
#  File.open(File.expand_path('../database.mongo.yml',__FILE__), 'r') do |f|
#    @settings = YAML.load(f)[Rails.env]
#  end
#
#  Mongoid.configure do |config|
#    name = @settings["database"]
#    host = @settings["host"]
#    config.master = Mongo::Connection.new.db(name)
#    #config.slaves = [
#    #  Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#    #  Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#    #]
#  end
#end
#ActionController::Base.session = {
#  :key    => '_open_talent_cms_session',
#  :secret => 'e3b17ed77a7765b7b05a0a2aa21a4054d2e36eeaea2cad0ed106ca446e46723b8fe3161837e408ee5e27d4cd827e0a75e69d43b877bacd1b80817cd50912e08e'
#}
