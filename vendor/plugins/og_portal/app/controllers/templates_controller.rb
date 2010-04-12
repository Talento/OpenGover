class TemplatesController < ApplicationController


  # GET /templates
  # GET /templates.xml
  def index
    @og_templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.xml
  def show
    @og_template = Template.find(params[:id])
  end

  # GET /templates/new
  def new
    @edit_template = Template.new
    @edit_template.site_id = params[:og_site].id
  end

  # GET /templates/1;edit
  def edit
    @edit_template = Template.find(params[:id])
  end

  # POST /templates
  # POST /templates.xml
  def create
    @edit_template = Template.new(params[:edit_template])

      if @edit_template.save
        flash[:notice] = 'Template was successfully created.'
        redirect_to :controller => :templates, :action => :index
      else
        render :action => "new"
      end
  end

  # PUT /templates/1
  # PUT /templates/1.xml
  def update
    @edit_template = Template.find(params[:id])

      if @edit_template.update_attributes(params[:edit_template])
        flash[:notice] = 'Template was successfully updated.'
        redirect_to :controller => :templates, :action => :index
      else
        render :action => "edit"
      end
  end

  # DELETE /templates/1
  # DELETE /templates/1.xml
  def destroy
    @og_template = Template.find(params[:id])
    @og_template.destroy
      redirect_to :controller => :templates, :action => :index
  end

  def manage_blocks
    load_embedded_applications
    @og_template = Template.find(params[:id])
    @blocks = @og_template.blocks
    @embedded_applications = EmbeddedApplication.available
  end

  def add_embedded_application
    load_embedded_applications
    @og_template = Template.find(params[:id])
    unless params[:embedded_application_id].blank?
    for block in @og_template.blocks
      if block.id.to_s == params[:block_id]
        embedded_app = EmbeddedApplication.available.select{|ea| ea if ea.name.sluggerize == params[:embedded_application_id]}.first
        block.embedded_applications << embedded_app
      end
    end
    @og_template.save
    end
      redirect_to :controller => :templates, :action => :manage_blocks, :id => @og_template
  end

  def destroy_embedded_application
    load_embedded_applications
    @og_template = Template.find(params[:id])
    unless params[:embedded_application_id].blank?
    for block in @og_template.blocks
      if block.id.to_s == params[:block_id]
        for embedded_app in block.embedded_applications
          block.embedded_applications.delete(embedded_app) if embedded_app.id.to_s == params[:embedded_application_id]
          end
      end
    end
    @og_template.save
    end
      redirect_to :controller => :templates, :action => :manage_blocks, :id => @og_template
  end

  def set_as_main
    @og_template = Template.find(params[:id])
    @og_template.set_as_main
      redirect_to :controller => :templates, :action => :index
  end

  private

  def load_embedded_applications
    if EmbeddedApplication.available.blank?
      Dir["#{Rails.root}/app/cells/*.rb"].each {|f|
        require f
      }
      Dir["#{Rails.root}/vendor/plugins/*/app/cells/*.rb"].each {|f|
        require f
    }
      end
  end
end
