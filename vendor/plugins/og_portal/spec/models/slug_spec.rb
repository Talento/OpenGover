require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


class ExampleClass
  include Mongoid::Document
  include Slug
  field :name
  slug :name
end

describe "Slug" do

  before(:all) do
    ExampleClass.delete_all
  end

  before(:each) do
    @example = ExampleClass.new(:name => "exaple")
  end

  it "should require a name" do
    @example.name = ""
    @example.should_not be_valid
  end

  it "should generate a slug on saving" do
    @example.name = "example generate slug"
    @example.save
    @example.slug.should == "example-generate-slug"
  end

  it "should generate a unique slug" do
    @example.name = "example generate unique slug"
    @example.save
    lambda {
      example2 = ExampleClass.new
      example2.name = "example generate unique slug"
      example2.save
      example2.slug.should == "example-generate-unique-slug-2"
    }.should change(ExampleClass, :count).by(1)
  end

end