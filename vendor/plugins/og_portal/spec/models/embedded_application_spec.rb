require File.dirname(__FILE__) + '/../spec_helper'

module EmbeddedApplicationSpecHelper
  
end

describe EmbeddedApplication do

  include EmbeddedApplicationSpecHelper

  before(:each) do
    v = Template.create(
      :name => "template example",
      :content => "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div>",
      :site_id => "1"
      )
    @block = v.blocks.first
    @block.embedded_applications.build(:name => "Embedded Application Example", :cell_name => 'menu', :cell_state => 'main')
    @ea = @block.embedded_applications.first
  end

  it "should be valid" do
    @ea.should be_valid
  end

  it "should require a name" do
    @ea.name = ""
    @ea.should_not be_valid
  end

  it "should require a cell name" do
    @ea.cell_name = ""
    @ea.should_not be_valid
  end

  it "should require a cell state" do
    @ea.cell_state = ""
    @ea.should_not be_valid
  end

end                                         