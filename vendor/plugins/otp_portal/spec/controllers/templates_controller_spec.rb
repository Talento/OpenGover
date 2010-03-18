require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module TemplatesControllerSpecHelper
  def valid_template_attributes
    {
      :name => "template example",
      :content => "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div>",
      :site_id => "1"
    }
  end
end
#
#describe TemplatesController, "handling /new" do
#
#  include TemplatesControllerSpecHelper
#
#
#  before do
#    @template = mock_model(Template, :to_param => "1", :update_attributes => true)
#    Template.stub!(:find).and_return(@template)
#  end
#
#  def do_post
#    post :create, :template => @params
#  end
#
#
#  before(:each) do
#    @template = mock_model(Template, :to_param => "1", :update_attributes => true)
#    Template.stub!(:find).and_return(@template)
#  end
#
#  def do_update
#    put :update, :id => "1"
#  end
#
#  it "should find the template requested" do
#    Template.should_receive(:find).with("1").and_return(@template)
#    do_update
#  end
#
#  it "should update the found template" do
#    @template.should_receive(:update_attributes)
#    do_update
#    assigns(:template).should equal(@template)
#  end
#
#  it "should assign the found template for the view" do
#    do_update
#    assigns(:template).should equal(@template)
#  end
#
#  it "should redirect to the template" do
#    do_update
#    response.should redirect_to(template_url("1"))
#  end
#end
#
#describe TemplatesController,  "handling /create" do
#
#  include TemplatesControllerSpecHelper
#
#  before do
#    @template = mock_model(Template, :to_param => "1", :save => true)
#    #Template.stub!(:fetch_for_zipcode).and_return(@template)
#    @params = valid_template_attributes
#  end
#
#  def do_post
#    post :create, :template => @params
#  end
#
#  it "should create a new template" do
#    Template.should_receive(:find).with(@params).and_return(@template)
#    do_post
#  end
#
#  it "should redirect to the templates list" do
#    do_post
#    response.should redirect_to({:controller => :templates, :action => :index})
#  end
#end
#
#describe "otro" do
#
#  it "should be valid" do
#    @template.attributes = valid_template_attributes
#    @template.should be_valid
#  end
#
#  it "should require a name" do
#    @template.attributes = valid_template_attributes.except(:name)
#    @template.should_not be_valid
#  end
#
#  it "should require a content" do
#    @template.attributes = valid_template_attributes.except(:content)
#    @template.should_not be_valid
#  end
#
#  it "should have yield into content" do
#    @template.attributes = valid_template_attributes
#    @template.content = "<div></div>"
#    @template.should_not be_valid
#  end
#
#  it "should belong to site" do
#    @template.attributes = valid_template_attributes
#    @template.site = nil
#    @template.should_not be_valid
#  end
#
#  it "should generate a layout name" do
#    @template.attributes = valid_template_attributes
#    @template.save
#    @template.layout_name.should == "1_#{@template.slug}"
#  end
#
#  it "should generate a layout" do
#    @template.attributes = valid_template_attributes
#    @template.save
#    file = "#{@template.base_path}/app/views/layouts/#{@template.layout_name}.html.erb"
#    File.exist?(file).should be_true
#  end
#
#  it "should have many blocks" do
#    @template.blocks << Block.new
#    @template.blocks.length.should == 1
#  end
#
#  it "should identify blocks" do
#    @template.attributes = valid_template_attributes
#    @template.save
#    @template.blocks.length.should == 1
#  end
#
#  it "should maintain existing blocks when updating" do
#    @template.attributes = valid_template_attributes
#    @template.save
#    id = @template.blocks.first.id
#    @template.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
#    @template.save
#    @template.blocks.collect(&:id).include?(id).should be_true
#  end
#
#  it "should add new blocks when updating" do
#    @template.attributes = valid_template_attributes
#    @template.save
#    @template.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
#    @template.save
#    @template.blocks.length.should == 2
#  end
#
#  it "should remove deleted blocks when updating" do
#    @template.attributes = valid_template_attributes
#    @template.content = "<div id=\"header\"><%= yield :header %></div><div id=\"header\"><%= yield %></div><div id=\"footer\"><%= yield :footer %></div>"
#    @template.save
#    @template.attributes = valid_template_attributes
#    @template.save
#    @template.blocks.length.should == 1
#  end
#
#end

describe TemplatesController, :type => :controller do
#
#  it "should map { :controller => 'templates', :action => 'index' } to /templates" do
#    route_for(:controller => "templates", :action => "index").should == "/templates"
#  end
#
#  it "should map { :controller => 'templates', :action => 'new' } to /templates/new" do
#    route_for(:controller => "templates", :action => "new").should == "/templates/new"
#  end
#
#  it "should map { :controller => 'templates', :action => 'show', :id => 1 } to /templates/1" do
#    route_for(:controller => "templates", :action => "show", :id => 1).should == "/templates/1"
#  end
#
#  it "should map { :controller => 'templates', :action => 'edit', :id => 1 } to /templates/1;edit" do
#    route_for(:controller => "templates", :action => "edit", :id => 1).should == "/templates/1;edit"
#  end
#
#  it "should map { :controller => 'templates', :action => 'update', :id => 1} to /templates/1" do
#    route_for(:controller => "templates", :action => "update", :id => 1).should == "/templates/1"
#  end
#
#  it "should map { :controller => 'templates', :action => 'destroy', :id => 1} to /templates/1" do
#    route_for(:controller => "templates", :action => "destroy", :id => 1).should == "/templates/1"
#  end
#  
end

describe TemplatesController, " handling GET /templates", :type => :controller do

  before do
    @template = mock_model(Template, :name => "template example", :id => 1)
    Template.stub!(:all).and_return([@template])
  end
  
  def do_get
    get :index
  end
  
  it "should be successful" do
    do_get
    response.should be_success
  end

  it "should render index template" do
    do_get
    response.should render_template('index')
  end
  
  it "should find all templates" do
    Template.should_receive(:all).and_return([@template])
    do_get
  end
  
  it "should assign the found templates for the view" do
    do_get
    response.body.should include(@template.name)
    #assigns[:templates].should == [@template]
  end
end
#
#describe TemplatesController, " handling GET /templates.xml", :type => :controller do
#
#  before do
#    @template = mock_model(Template, :to_xml => "XML")
#    Template.stub!(:find).and_return(@template)
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
#  it "should find all templates" do
#    Template.should_receive(:find).with(:all).and_return([@template])
#    do_get
#  end
#
#  it "should render the found templates as xml" do
#    @template.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

describe TemplatesController, " handling GET /templates/1", :type => :controller do

  before do
    @template = mock_model(Template, :name => "template example", :id => 1, :content => "<div></div>")
    Template.stub!(:find).with("1").and_return(@template)
  end
  
  def do_get
    get :show, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
#  it "should render show template" do
#    do_get
#    response.should render_template('show')
#  end
  
  it "should find the template requested" do
    Template.should_receive(:find).with("1").and_return(@template)
    do_get
  end
  
  it "should assign the found template for the view" do
    do_get
    response.body.should include(@template.name)
    #assigns[:template].should equal(@template)
  end
end
#
#describe TemplatesController, " handling GET /templates/1.xml", :type => :controller do
#
#  before do
#    @template = mock_model(Template, :to_xml => "XML")
#    Template.stub!(:find).and_return(@template)
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
#  it "should find the template requested" do
#    Template.should_receive(:find).with("1").and_return(@template)
#    do_get
#  end
#
#  it "should render the found template as xml" do
#    @template.should_receive(:to_xml).and_return("XML")
#    do_get
#    response.body.should == "XML"
#  end
#end

describe TemplatesController, " handling GET /templates/new", :type => :controller do

  before do
    @template = mock_model(Template, :name => "template example", :id => 1, :content => "<div></div>")
    Template.stub!(:new).and_return(@template)
  end
  
  def do_get
    get :new
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
#  it "should render new template" do
#    do_get
#    response.should render_template('new')
#  end
  
  it "should create an new template" do
    Template.should_receive(:new).and_return(@template)
    do_get
  end
  
  it "should not save the new template" do
    @template.should_not_receive(:save)
    do_get
  end
  
  it "should assign the new template for the view" do
    do_get
    response.body.should include(@template.name)
    #assigns[:template].should equal(@template)
  end
end

describe TemplatesController, " handling GET /templates/1/edit", :type => :controller do

  before do
    @template = mock_model(Template, :name => "template example", :id => 1, :content => "<div></div>")
    Template.stub!(:find).with("1").and_return(@template)
  end
  
  def do_get
    get :edit, :id => "1"
  end

  it "should be successful" do
    do_get
    response.should be_success
  end
  
#  it "should render edit template" do
#    do_get
#    response.should render_template('edit')
#  end
  
  it "should find the template requested" do
    Template.should_receive(:find).and_return(@template)
    do_get
  end
  
  it "should assign the found Template for the view" do
    do_get
    response.body.should include(@template.name)
    #assigns[:template].should equal(@template)
  end
end

describe TemplatesController, " handling POST /templates", :type => :controller do

  include TemplatesControllerSpecHelper

  before do
    @template = mock_model(Template, :to_param => "1", :save => true, :name => "template example", :id => 1, :content => "<div></div>")
    Template.stub!(:new).and_return(@template)
    @params = valid_template_attributes
  end
  
  def do_post
    post :create, :template => @params
  end
  
  it "should create a new template" do
    @template.should_receive(:save).and_return(true)
    do_post
  end

  it "should redirect to the index" do
    do_post
    response.should redirect_to(templates_url)
  end
end

describe TemplatesController, " handling PUT /templates/1", :type => :controller do

  before do
    @template = mock_model(Template, :to_param => "1", :update_attributes => true, :name => "template example", :id => 1, :content => "<div></div>")
    Template.stub!(:find).with("1").and_return(@template)
  end
  
  def do_update
    put :update, :id => "1"
  end
  
  it "should find the template requested" do
    Template.should_receive(:find).with("1").and_return(@template)
    do_update
  end

  it "should redirect to the index" do
    do_update
    response.should redirect_to(templates_url)
  end
end

describe TemplatesController, " handling DELETE /templates/1", :type => :controller do

  before do
    @template = mock_model(Template, :destroy => true, :name => "template example", :id => 1, :content => "<div></div>")
    Template.stub!(:find).with("1").and_return(@template)
  end
  
  def do_delete
    delete :destroy, :id => "1"
  end

  it "should find the template requested" do
    Template.should_receive(:find).with("1").and_return(@template)
    do_delete
  end
  
  it "should call destroy on the found template" do
    @template.should_receive(:destroy)
    do_delete
  end
  
  it "should redirect to the templates list" do
    do_delete
    response.should redirect_to(templates_url)
  end
end