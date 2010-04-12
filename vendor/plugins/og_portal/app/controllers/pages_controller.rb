class PagesController < ApplicationController

  available_application("Page listing", {:controller => "pages", :action => "index"})

  # GET /pages
  # GET /pages.xml
  def index
    @pages = Page.all(:order => "position")
  end

  # GET /pages/1
  # GET /pages/1.xml
  def show
    @page = params[:id].blank? ? get_first_public_page : Page.find(params[:id])
  end

  # GET /pages/new
  def new
    @page = Page.new
    @page.site_id = params[:og_site].id
    @page.parent_id = params[:parent_id] unless params[:parent_id].blank?
    @templates = params[:og_site].templates
  end

  # GET /pages/1;edit
  def edit
    @page = Page.find(params[:id])
        @templates = params[:og_site].templates
  end

  # POST /pages
  # POST /pages.xml
  def create
    @page = Page.new(params[:page])

      if @page.save
        flash[:notice] = 'Page was successfully created.'
        redirect_to :controller => "pages", :action => "index"
      else
        @templates = params[:og_site].templates
        render :action => "new"
      end
  end

  # PUT /pages/1
  # PUT /pages/1.xml
  def update
    @page = Page.find(params[:id])

      if @page.update_attributes(params[:page])
        flash[:notice] = 'Page was successfully updated.'
        redirect_to :controller => "pages", :action => "index"
      else
        @templates = params[:og_site].templates
        render :action => "edit"
      end
  end

  # DELETE /pages/1
  # DELETE /pages/1.xml
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

        redirect_to :controller => "pages", :action => "index"
  end


    def page_up
        page = Page.find(params[:id])
        page.move_higher
        redirect_to :controller => "pages", :action => "index"
    end

    def page_down
        page = Page.find(params[:id])
        page.move_lower
        redirect_to :controller => "pages", :action => "index"
    end

    def show_in_menu
        page = Page.find(params[:id])
        page.in_menu = true
        page.save
        redirect_to :controller => "pages", :action => "index"
    end

    def hide_in_menu
        page = Page.find(params[:id])
        page.in_menu = false  
        page.save
        redirect_to :controller => "pages", :action => "index"
    end

    def publish
        page = Page.find(params[:id])
        page.published = true
        page.save
        redirect_to :controller => "pages", :action => "index"
    end

    def unpublish
        page = Page.find(params[:id])
        page.published = false
        page.save
        redirect_to :controller => "pages", :action => "index"
    end
end
