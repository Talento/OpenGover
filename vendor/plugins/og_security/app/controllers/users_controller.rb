
class UsersController < ApplicationController

  def index

    @users = User.paginate :page => params[:page], :per_page => 10

  end


  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    begin
      @user.destroy
      flash[:message] = "User destroyed succesfully"
    rescue 
      flash[:errors] = t("users.error_borrando")
    end
    redirect_to :controller => :users, :action => :index
  end

def edit_roles
    @user = User.find(params[:id])
  @roles = User::ROLES
end

def update_roles
    @user = User.find(params[:id])
  @user.roles = params[:user][:roles]
  @user.save
      flash[:message] = "Roles assigned succesfully"
    redirect_to :controller => :users, :action => :index

end

  def enable_ip
    user = User.find( params[:id] )
    if user.encrypt( params[:ip] ) == params[:token]
      unless user.enabledips.collect{ |i| i.value }.include?( params[:ip] )
        user.enabledips << Enabledip.new( :value => params[:ip] )
        user.save
      end
      reset_session
      self.current_user = user
      flash[:notice] = I18n.t("users.ip_autorizada")
    else
      flash[:errors] = I18n.t("users.invalid_ip_token")
    end
    redirect_to "/"
  end

  def add_enabled_ip
    user = User.find( params[:id] )
    unless user.enabledips.collect{ |i| i.value }.include?( params[:enabledip][:value] )
      user.enabledips << Enabledip.new( :value => params[:enabledip][:value] )
      user.save
    end
    flash[:notice] = I18n.t("users.ip_autorizada")
    redirect_to :action => :edit, :id => user.id
  end
    
end
