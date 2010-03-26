require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PageSpecHelper
  def valid_page_attributes
    {
      :name => "page example",
      :content => "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div>",
      :site_id => "1"
    }
  end
end

describe Page do

  include PageSpecHelper

  before(:all) do
    Page.delete_all
  end

  before(:each) do
    @page = Page.new(:name => "page example", :application => {:controller => :templates, :action => :index})

    template = Template.create(:name => "template example",:content => "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div>",:site_id => "1")
    @page.template = template

    site = Site.new(:name => "Sample site")
    site.languages.create(:name => I18n.default_locale, :locale => I18n.default_locale)
    site.templates << template
    @page.site = site

  end

  it "should be valid" do
    @page.should be_valid
  end
  
  it "should require a name" do
    @page.name = ""
    @page.should_not be_valid
  end

  it "should require a template" do
    @page.template = nil
    @page.should_not be_valid
  end

  it "should require an application" do
    @page.application = nil
    @page.should_not be_valid
  end

  it "should require a site" do
    @page.site = nil
    @page.should_not be_valid
  end
  
end