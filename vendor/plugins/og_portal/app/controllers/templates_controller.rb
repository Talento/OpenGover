class TemplatesController < ApplicationController


  # GET /templates
  # GET /templates.xml
  def index
    @templates = Template.all
                                    
    respond_to do |format|
      format.html # index.rhtml
      #format.xml  { render :xml => @templates.to_xml }
    end
  end

  # GET /templates/1
  # GET /templates/1.xml
  def show
    @template = Template.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      #format.xml  { render :xml => @template.to_xml }
    end
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1;edit
  def edit
    @template = Template.find(params[:id])
  end

  # POST /templates
  # POST /templates.xml
  def create
    @template = Template.new(params[:template])

    respond_to do |format|
      if @template.save
        flash[:notice] = 'Template was successfully created.'
        format.html { redirect_to "templates#index" }
        #format.xml  { head :created, :location => template_url(@template) }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @template.errors.to_xml }
      end
    end
  end

  # PUT /templates/1
  # PUT /templates/1.xml
  def update
    @template = Template.find(params[:id])

    respond_to do |format|
      if @template.update_attributes(params[:template])
        flash[:notice] = 'Template was successfully updated.'
        format.html { redirect_to "templates#index" }
        #format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @template.errors.to_xml }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.xml
  def destroy
    @template = Template.find(params[:id])
    @template.destroy

    respond_to do |format|
      format.html { redirect_to "templates#index" }
      #format.xml  { head :ok }
    end
  end
end
