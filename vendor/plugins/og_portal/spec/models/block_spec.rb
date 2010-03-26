require File.dirname(__FILE__) + '/../spec_helper'

module BlockSpecHelper
  
end

describe Block do

  include BlockSpecHelper

  before(:each) do
    v = Template.create(
      :name => "template example",
      :content => "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div>",
      :site_id => "1"
      )
    @block = v.blocks.first
  end

  it "should be valid" do
    @block.should be_valid
  end

  it "should require a name" do
    @block.name = ""
    @block.should_not be_valid
  end

end                                         