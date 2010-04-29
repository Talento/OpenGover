class ActivitiesController < ApplicationController

  def index
    conditions = {}
    conditions[:user_id] = params[:user] unless params[:user].blank?
    unless params[:date].blank? || params[:date]['from(1i)'].blank?
      @date_from = Time.gm(params[:date]["from(1i)"].to_i,params[:date]["from(2i)"],params[:date]["from(3i)"],params[:date]["from(4i)"],params[:date]["from(5i)"])
      conditions[:created_at.gte] = @date_from
      logger.fatal @date_from
      @date_until = Time.gm(params[:date]["until(1i)"].to_i,params[:date]["until(2i)"],params[:date]["until(3i)"],params[:date]["until(4i)"],params[:date]["until(5i)"])
      conditions[:created_at.lte] = @date_until 
    end
    conditions[:url] = Regexp.new(params[:url],Regexp::IGNORECASE) unless params[:url].blank?  
    @activities = Activity.paginate :conditions => conditions,:per_page => 20, :page => params[:page], :order => "created_at desc"
  end

end