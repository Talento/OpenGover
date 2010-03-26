require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module TemplateSpecHelper
  def valid_template_attributes
    {
      :name => "template example",
      :content => "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div>",
      :site_id => "1"
    }
  end
end

describe Template do

  include TemplateSpecHelper

  before(:all) do
    Template.delete_all
  end

  before(:each) do
    @template = Template.new
  end

  it "should be valid" do
    @template.attributes = valid_template_attributes
    @template.should be_valid
  end

  it "should require a name" do
    @template.attributes = valid_template_attributes.except(:name)
    @template.should_not be_valid
  end

  it "should require a content" do
    @template.attributes = valid_template_attributes.except(:content)
    @template.should_not be_valid
  end
  
  it "should have yield into content" do
    @template.attributes = valid_template_attributes
    @template.content = "<div></div>"
    @template.should_not be_valid
  end

  it "should belong to site" do
    @template.attributes = valid_template_attributes
    @template.site = nil
    @template.should_not be_valid
  end
                                
  it "should generate a layout name" do
    @template.attributes = valid_template_attributes
    @template.save
    @template.layout_name.should == "1_#{@template.slug}"
  end

  it "should generate a layout" do
    @template.attributes = valid_template_attributes
    @template.save
    file = "#{@template.base_path}/app/views/layouts/#{@template.layout_name}.html.erb"
    File.exist?(file).should be_true
  end

  it "should have many blocks" do
    @template.blocks << Block.new
    @template.blocks.length.should == 1
  end

  it "should identify blocks" do
    @template.attributes = valid_template_attributes
    @template.save
    @template.blocks.length.should == 1
  end

  it "should maintain existing blocks when updating" do
    @template.attributes = valid_template_attributes
    @template.save
    id = @template.blocks.first.id
    @template.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
    @template.save
    @template.blocks.collect(&:id).include?(id).should be_true
  end

  it "should add new blocks when updating" do
    @template.attributes = valid_template_attributes
    @template.save
    @template.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
    @template.save
    @template.blocks.length.should == 2
  end
  
  it "should remove deleted blocks when updating" do
    @template.attributes = valid_template_attributes
    @template.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
    @template.save
    @template.attributes = valid_template_attributes
    @template.save
    @template.blocks.length.should == 1
  end

  it "should respond to set_as_main" do
    @template.attributes = valid_template_attributes
    @template.save
    @template.set_as_main
    @template.main.should == true
  end

  it "should have a unique main template per site" do
    @template.attributes = valid_template_attributes
    @template.save
    @template.set_as_main
    @template2 = Template.new
    @template2.attributes = valid_template_attributes
    @template2.save
    @template2.set_as_main

    Template.where(:main => true).count.should == 1
    @template2.reload.main.should == true
  end
end