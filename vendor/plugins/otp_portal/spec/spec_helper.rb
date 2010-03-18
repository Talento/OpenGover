  #require File.dirname(__FILE__) + '/../../../../spec/spec_helper'

# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = 'test'
require File.dirname(__FILE__) + "/../../../../config/environment" #unless defined?(RAILS_ROOT)
Dir["#{File.dirname(__FILE__)}/../../../../config/initializers/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../../../../app/*/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/../config/*.rb"].each {|f| require f}
require File.dirname(__FILE__) + "/../init"

require 'rspec/rails'
#require "sluggerize"

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end
