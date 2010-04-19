class RolesController < ApplicationController
  
    before_filter :init_back, :except => [:create, :update, :destroy]
    before_filter :voranet_filter

    layout :def_lay

  private

  def init_back
      load_contents(Cms.layout_back)
  end

  public

    def index
        list
        render :action => 'list'
    end

    # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
    verify :method => :post, :only => [ :destroy, :create, :update ],
      :redirect_to => { :action => :list }

    def list
        @roles = Role.paginate :per_page => 20, :page => params[:page]
    end

    def show
        @role = Role.find(params[:id])
    end

    def new
        @role = Role.new
        #@users = User.find_no_administradores
        @users = User.find :all
        session[:users] = []
        @users_session = []
    end

    def create
        @role = Role.new(params[:role])
        @role.users << params[:user_ids].collect{|m| User.find(m)} if params[:user_ids]
        if @role.save
            flash[:notice] = t('main.flash_ok')
            redirect_to :action => 'list'
        else
            load_contents
            #@users = User.find_no_administradores
            @users = User.find :all
            @users_session = @role.users			
            render :action => 'new'
        end
    end

    def edit
        @role = Role.find(params[:id])    
        #@users = User.find_no_administradores
        @users = User.find :all
    end

    def update
        @role = Role.find(params[:id])
        #@role.users = []
        #@role.users << params[:user_ids].collect{|m| User.find(m)} if params[:user_ids]
        @role.user_ids = params[:user_ids]
        if @role.update_attributes(params[:role])
            flash[:notice] = t('main.flash_ok')
            redirect_to :action => 'list'
        else
            load_contents
            #@users = User.find_no_administradores
            @users = User.find :all
            @users_session = @role.users	
            if @role.es_grupo_admin? and !@role.users.any?
              @role.users = [Cms.user]
            end            
            render :action => 'edit'
        end
    end

    def edit_permissions
        @role = Role.find(params[:id])    
        #@users = User.find_no_administradores
        @actions = Action.find(:all, :order => "controller")
    end

    def update_permissions
        @role = Role.find(params[:id])
        @actions = Action.find :all
        for action in @actions
            per = Permission.find(:first, :conditions => ["role_id=? and action_id=?", @role.id, action.id]) || Permission.new(:role_id => @role.id, :action_id => action.id)
            per.permission = params["permission_action_" + action.id.to_s]
            per.save
        end
            flash[:notice] = t('main.flash_ok')
            redirect_to :action => 'list'
    end

    def destroy
        Role.find(params[:id]).destroy
        redirect_to :action => 'list'
    end
#  
#    def update_users
#        @users_session = User.find(session[:users])    
#        @modification = params[:per_page]   
#		
#        #Obtenemos los parámetros recibidos
#        params_sin_asignar = params[:user] 
#        params_asignado = params[:user_session]   
#		
#        if @modification.eql?("Anadir")
#            @users_session += User.find(params_sin_asignar) if params_sin_asignar
#        else
#            @users_session -= User.find(params_asignado) if params_asignado
#        end    
#		
#        session[:users] = @users_session.collect(&:id)
#        @users = User.find(:all) - @users_session    
#        #@users = User.find_no_administradores - @users_session    
#		
#        respond_to do |format|
#            format.js
#        end
#		
#    end
#  
    def self.default_access(action_name, user, objeto)
        false
    end 
    
  def self.migas(action_name, objeto)
    migas_found = []
    case action_name
      when "index"
        migas_found << Role.human_name.pluralize
      when "show"
        migas_found << Cms.link_to_migas(Role.human_name.pluralize, "/roles")
        migas_found << objeto.name
      when "edit","update"
        migas_found << Cms.link_to_migas(Role.human_name.pluralize, "/roles")
        migas_found << Cms.link_to_migas(objeto.name, "/roles/show/#{objeto.to_param}")
        migas_found << I18n.t("main.edit")
      when "new","create"
        migas_found << Cms.link_to_migas(Role.human_name.pluralize, "/roles")
        migas_found << I18n.t('main.heading_new', :object => Role.human_name.downcase)
      when "edit_permissions", "update_permissions"
        migas_found << Cms.link_to_migas(Role.human_name.pluralize, "/roles")
        migas_found << Cms.link_to_migas(objeto.name, "/roles/show/#{objeto.to_param}")
        migas_found << I18n.t('rol.edit_permissions')       
    end    
    return migas_found.join(" > ")
  end       
        
end
