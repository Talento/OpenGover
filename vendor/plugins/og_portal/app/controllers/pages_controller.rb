class PagesController < ApplicationController

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all
                                    
    respond_to do |format|
      format.html # index.rhtml
      #format.xml  { render :xml => @pages.to_xml }
    end
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      #format.xml  { render :xml => @page.to_xml }
    end
  end

  # GET /pages/new
  def new
    @page = Page.new
    @page.site_id = params[:site].id
    @templates = params[:site].templates
  end

  # GET /pages/1;edit
  def edit
    @page = Page.find(params[:id])
        @templates = params[:site].templates
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        flash[:notice] = 'Page was successfully created.'
        format.html { redirect_to "pages#index" }
        #format.xml  { head :created, :location => page_url(@page) }
      else
        @templates = params[:site].templates
        format.html { render :action => "new" }
        #format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        format.html { redirect_to "pages#index" }
        #format.xml  { head :ok }
      else
        @templates = params[:site].templates
        format.html { render :action => "edit" }
        #format.xml  { render :xml => @page.errors.to_xml }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to "pages#index" }
      #format.xml  { head :ok }
    end
  end
end
