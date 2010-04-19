class NiceditController < ApplicationController

  def table
    
  end

  def link
    
  end

  def mapa_web
    @pages = Page.find(:all, :order =>"position", :conditions => ["site_id = ? and parent_id=0", Cms.site.id])
    txt = render_to_string
    render :update do |page|
      page.call("jInfo",txt,t('main.mapa_web'))
    end
  end

end
