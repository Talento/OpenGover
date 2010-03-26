require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SiteSpecHelper

end

describe Site do

  include SiteSpecHelper

  before(:all) do
    Site.delete_all
  end

  before(:each) do
    @site = Site.new(:name => "Sample site")
    @site.languages.build(:name => I18n.default_locale, :locale => I18n.default_locale)
    @site.templates.build(:name => I18n.default_locale)
  end

  it "should be valid" do
    @site.should be_valid
  end

  it "should require a name" do
    @site.name = ""
    @site.should_not be_valid
  end

  it "should require at lesast one language" do
    @site.languages = []
    @site.should_not be_valid
  end

  it "should require at lesast one template" do
    @site.templates = []
    @site.should_not be_valid
  end

end