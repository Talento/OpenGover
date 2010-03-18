require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module PagesControllerSpecHelper
  def valid_page_attributes
    {
      :name => "page example",
      :application => {:controller => :templates, :action => :index}
    }
  end
end
#
#describe PagesController, "handling /new" do
#
#  include PagesControllerSpecHelper
#
#
#  before do
#    @page = mock_model(Page, :to_param => "1", :update_attributes => true)
#    Page.stub!(:find).and_return(@page)
#  end
#
#  def do_post
#    post :create, :page => @params
#  end
#
#
#  before(:each) do
#    @page = mock_model(Page, :to_param => "1", :update_attributes => true)
#    Page.stub!(:find).and_return(@page)
#  end
#
#  def do_update
#    put :update, :id => "1"
#  end
#
#  it "should find the page requested" do
#    Page.should_receive(:find).with("1").and_return(@page)
#    do_update
#  end
#
#  it "should update the found page" do
#    @page.should_receive(:update_attributes)
#    do_update
#    assigns(:page).should equal(@page)
#  end
#
#  it "should assign the found page for the view" do
#    do_update
#    assigns(:page).should equal(@page)
#  end
#
#  it "should redirect to the page" do
#    do_update
#    response.should redirect_to(page_url("1"))
#  end
#end
#
#describe PagesController,  "handling /create" do
#
#  include PagesControllerSpecHelper
#
#  before do
#    @page = mock_model(Page, :to_param => "1", :save => true)
#    #Page.stub!(:fetch_for_zipcode).and_return(@page)
#    @params = valid_page_attributes
#  end
#
#  def do_post
#    post :create, :page => @params
#  end
#
#  it "should create a new page" do
#    Page.should_receive(:find).with(@params).and_return(@page)
#    do_post
#  end
#
#  it "should redirect to the pages list" do
#    do_post
#    response.should redirect_to({:controller => :pages, :action => :index})
#  end
#end
#
#describe "otro" do
#
#  it "should be valid" do
#    @page.attributes = valid_page_attributes
#    @page.should be_valid
#  end
#
#  it "should require a name" do
#    @page.attributes = valid_page_attributes.except(:name)
#    @page.should_not be_valid
#  end
#
#  it "should require a content" do
#    @page.attributes = valid_page_attributes.except(:content)
#    @page.should_not be_valid
#  end
#
#  it "should have yield into content" do
#    @page.attributes = valid_page_attributes
#    @page.content = "<div></div>"
#    @page.should_not be_valid
#  end
#
#  it "should belong to site" do
#    @page.attributes = valid_page_attributes
#    @page.site = nil
#    @page.should_not be_valid
#  end
#
#  it "should generate a layout name" do
#    @page.attributes = valid_page_attributes
#    @page.save
#    @page.layout_name.should == "1_#{@page.slug}"
#  end
#
#  it "should generate a layout" do
#    @page.attributes = valid_page_attributes
#    @page.save
#    file = "#{@page.base_path}/app/views/layouts/#{@page.layout_name}.html.erb"
#    File.exist?(file).should be_true
#  end
#
#  it "should have many blocks" do
#    @page.blocks << Block.new
#    @page.blocks.length.should == 1
#  end
#
#  it "should identify blocks" do
#    @page.attributes = valid_page_attributes
#    @page.save
#    @page.blocks.length.should == 1
#  end
#
#  it "should maintain existing blocks when updating" do
#    @page.attributes = valid_page_attributes
#    @page.save
#    id = @page.blocks.first.id
#    @page.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
#    @page.save
#    @page.blocks.collect(&:id).include?(id).should be_true
#  end
#
#  it "should add new blocks when updating" do
#    @page.attributes = valid_page_attributes
#    @page.save
#    @page.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
#    @page.save
#    @page.blocks.length.should == 2
#  end
#
#  it "should remove deleted blocks when updating" do
#    @page.attributes = valid_page_attributes
#    @page.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
#    @page.save
#    @page.attributes = valid_page_attributes
#    @page.save
#    @page.blocks.length.should == 1
#  end
#
#end

describe PagesController, :type => :controller do
#
#  it "should map { :controller => 'pages', :action => 'index' } to /pages" do
#    route_for(:controller => "pages", :action => "index").should == "/pages"
#  end
#
#  it "should map { :controller => 'pages', :action => 'new' } to /pages/new" do
#    route_for(:controller => "pages", :action => "new").should == "/pages/new"
#  end
#
#  it "should map { :controller => 'pages', :action => 'show', :id => 1 } to /pages/1" do
#    route_for(:controller => "pages", :action => "show", :id => 1).should == "/pages/1"
#  end
#
#  it "should map { :controller => 'pages', :action => 'edit', :id => 1 } to /pages/1;edit" do
#    route_for(:controller => "pages", :action => "edit", :id => 1).should == "/pages/1;edit"
#  end
#
#  it "should map { :controller => 'pages', :action => 'update', :id => 1} to /pages/1" do
#    route_for(:controller => "pages", :action => "update", :id => 1).should == "/pages/1"
#  end
#
#  it "should map { :controller => 'pages', :action => 'destroy', :id => 1} to /pages/1" do
#    route_for(:controller => "pages", :action => "destroy", :id => 1).should == "/pages/1"
#  end
#  
end

describe PagesController, " handling GET /pages", :type => :controller do

  before do
    @page = mock_model(Page, :name => "page example", :id => 1)
    Page.stub!(:all).and_return([@page])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

#  it "should render index page" do
#    do_get
#    response.should render_page('index')
#  end
  
  it "should find all pages" do
    Page.should_receive(:all).and_return([@page])
    do_get
  end
  
  it "should assign the found pages for the view" do
    do_get
    response.body.should include(@page.name)
    #assigns[:pages].should == [@page]
  end
end
#
#describe PagesController, " handling GET /pages.xml", :type => :controller do
#
#  before do
#    @page = mock_model(Page, :to_xml => "XML")
#    Page.stub!(:find).and_return(@page)
#  end
#
#  def do_get
#    @request.env["HTTP_ACCEPT"] = "application/xml"
#    get :index
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#
#  it "should find all pages" do
#    Page.should_receive(:find).with(:all).and_return([@page])
#    do_get
#  end
#
#  it "should render the found pages as xml" do
#    @page.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

describe PagesController, " handling GET /pages/1", :type => :controller do

  before do
    @page = mock_model(Page, :name => "page example", :id => 1, :content => "<div></div>")
    Page.stub!(:find).with("1").and_return(@page)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
#  it "should render show page" do
#    do_get
#    response.should render_page('show')
#  end
  
  it "should find the page requested" do
    Page.should_receive(:find).with("1").and_return(@page)
    do_get  
  end
  
  it "should assign the found page for the view" do
    do_get
    response.body.should include(@page.name)
    #assigns[:page].should equal(@page)
  end
end
#
#describe PagesController, " handling GET /pages/1.xml", :type => :controller do
#
#  before do
#    @page = mock_model(Page, :to_xml => "XML")
#    Page.stub!(:find).and_return(@page)
#  end
#
#  def do_get
#    @request.env["HTTP_ACCEPT"] = "application/xml"
#    get :show, :id => "1"
#  end
#
#  it "should be successful" do
#    do_get
#    response.should be_success
#  end
#
#  it "should find the page requested" do
#    Page.should_receive(:find).with("1").and_return(@page)
#    do_get
#  end
#
#  it "should render the found page as xml" do
#    @page.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

describe PagesController, " handling GET /pages/new", :type => :controller do

  before do
    @page = mock_model(Page, :name => "page example", :id => 1, :content => "<div></div>")
    Page.stub!(:new).and_return(@page)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
#  it "should render new page" do
#    do_get
#    response.should render_page('new')
#  end
  
  it "should create an new page" do
    Page.should_receive(:new).and_return(@page)
    do_get
  end
  
  it "should not save the new page" do
    @page.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new page for the view" do
    do_get
    response.body.should include(@page.name)
    #assigns[:page].should equal(@page)
  end
end

describe PagesController, " handling GET /pages/1/edit", :type => :controller do

  before do
    @page = mock_model(Page, :name => "page example", :id => 1, :content => "<div></div>")
    Page.stub!(:find).with("1").and_return(@page)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
#  it "should render edit page" do
#    do_get
#    response.should render_page('edit')
#  end
  
  it "should find the page requested" do
    Page.should_receive(:find).and_return(@page)
    do_get
  end
  
  it "should assign the found Page for the view" do
    do_get
    response.body.should include(@page.name)
    #assigns[:page].should equal(@page)
  end
end

describe PagesController, " handling POST /pages", :type => :controller do

  include PagesControllerSpecHelper

  before do
    @page = mock_model(Page, :to_param => "1", :save => true, :name => "page example", :id => 1, :content => "<div></div>")
    Page.stub!(:new).and_return(@page)
    @params = valid_page_attributes
  end
  
  def do_post
    post :create, :page => @params
  end
  
  it "should create a new page" do
    @page.should_receive(:save).and_return(true)
    do_post
  end

  it "should redirect to the index" do
    do_post
    response.should redirect_to(pages_url)
  end
end

describe PagesController, " handling PUT /pages/1", :type => :controller do

  before do
    @page = mock_model(Page, :to_param => "1", :update_attributes => true, :name => "page example", :id => 1, :content => "<div></div>")
    Page.stub!(:find).with("1").and_return(@page)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the page requested" do
    Page.should_receive(:find).with("1").and_return(@page)
    do_update
  end

  it "should redirect to the index" do
    do_update
    response.should redirect_to(pages_url)
  end
end

describe PagesController, " handling DELETE /pages/1", :type => :controller do

  before do
    @page = mock_model(Page, :destroy => true, :name => "page example", :id => 1, :content => "<div></div>")
    Page.stub!(:find).with("1").and_return(@page)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the page requested" do
    Page.should_receive(:find).with("1").and_return(@page)
    do_delete
  end
  
  it "should call destroy on the found page" do
    @page.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the pages list" do
    do_delete
    response.should redirect_to(pages_url)
  end
end