# coding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe "Sluggerize" do

  it "should be an instance method of string" do
    "string".should be_respond_to(:sluggerize)
  end

  it "should remove blanks" do
    "slug example".sluggerize.should == "slug-example"
  end

  it "should remove symbols" do
    "slúg exámple".sluggerize.should == "slug-example"
  end

  it "should be lowercase" do
    "Slug EXAMPLE".sluggerize.should == "slug-example"
  end

end