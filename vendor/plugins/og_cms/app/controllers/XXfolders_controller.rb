class FoldersController < ApplicationController

    def index
      pi = request.env['PATH_INFO'].split("/")
      @private_path = ""
      i=0
      while i<pi.length
        if (pi[i]=='site' || pi[i]=='private')
          @private_path += "/" + pi[i] + "/" + pi[i+1]
          i=i+1
        end
        i=i+1
      end
      if params[:id]
        f=Folder.find params[:id]
        @folders = f.children_for_user(current_user)
        @objects = f.send(params[:type].pluralize.to_sym)
        render :partial => 'folders'
      else
        if current_user && current_user.is?("admin")
          @folders = Folder.roots_with_owner_for_admin
        else
          @folders = Folder.roots_with_owner_for_user(current_user)
        end
        @objects = [] #Image.orphans
        @image = Image.new
        @destino = params[:destino]
        @type = params[:type]
      end
    end

    def move_object
      begin
        obj = params[:source].split('_')[0].constantize.find_by_id params[:source].split('_')[1]
        if params[:destination].split('_')[0] == 'Folder'
          f=Folder.find_by_id params[:destination].split('_')[1]
          f ? obj.move_to_folder(f,params[:pos] || 0) : obj.move_to_root
        else
          if params[:destination] == 'tree_root'
            obj.move_to_root
          else
            f = Folder.get_parent_folder params[:destination].split('_')[0], params[:destination].split('_')[1]
            obj.move_to_folder(f,params[:pos] || 0) if f
          end
        end
      rescue
      end
      render :text => ''
    end

    def click_object
      begin
        @image = Image.find_by_id params[:id]

        controller = params[:id].split('_')[0].pluralize
        t = embed_action_as_string :controller => controller, :action => 'click', :id => params[:id].split('_')[1], :type => params[:type]
        render :update do |page|
          page['preview'].html(t)
        end
      rescue
        render :text => ''
      end
    end

    def click
      @folder = Folder.find_by_id params[:id].to_i
      unless @folder
        @folder = Folder.new
        @folder.id = 0
      end
      @permisos = [[I18n.t("folder.owner"), 0],[I18n.t("folder.all"), -1]]
      if CMS_CONFIG['folder_permissions_level'] == 0
        @permisos.concat User.all.map{|r| [I18n.t('folder.user') + ": " + (r.nombre_completo || r.login),r.id]}
      else
        @permisos.concat Role.all.map{|r| [I18n.t('folder.group') + " " + r.name,r.id]}
      end
      @galeriatipos = Galeriatipo.all.map{|g| [g.nombre,g.id]}
      if params[:type]
        render :action => "click_#{params[:type]}"
      end
    end
    
    def new
    end

    def edit
      @image = Image.find_by_id(params[:id])
    end

    def update_title
      id = params[:id]
      title = params[:title]
      name = params[:name]
      i = Image.find_by_id id
      i.title = title
      i.name = name
      i.save
      render :update do |page|
        page.call('object_title_modified',id, title);
      end
    end

    def crop
      id = params[:id]
      x = params[:x]
      y = params[:y]
      width = params[:width]
      height = params[:height]
      i = Image.find_by_id id
      i.crop_all x,y,width,height
      render :update do |page|
        page.call('image_cropped',id);
      end
    end

    def rotate
      id = params[:id]
      angle = params[:angle]
      i = Image.find_by_id id
      i.rotate angle.to_i
      render :update do |page|
        page.call('image_rotated',id);
      end
    end

    def create
      imagen = false
      created = false
      ok = true
      # Carpeta a la que moveremos los objetos
      f=nil
      folder_id = params[:folder][:id]
      if params[:folder][:id] != ''
        if params[:folder][:id].split('_')[0] == 'Folder'
          f = Folder.find_by_id params[:folder][:id].split('_')[1]
        else
          f = Folder.get_parent_folder params[:folder][:id].split('_')[0], params[:folder][:id].split('_')[1]
          if f
            folder_id = "Folder_#{f.id}"
          else
            folder_id=0
          end
        end
      end
      unless params[:image][:image].blank?
        ext = params[:image][:image].path.split('.').last.downcase
      if ext.eql?('zip')
        title = params[:image][:title]
        name = params[:image][:name]
        params[:image].delete(:title)
        params[:image].delete(:name)
        @zip = ZipObject.new(params[:image])
        @zip.save
        @zip.save_objects_with_folders f,session[:user_id], session[:site_id]
        @zip.destroy
        @image = Image.new
      elsif Image.valid_formats.include?ext
        imagen = true
        begin
          @image = Image.new(params[:image])
          @image.site_id = session[:site_id]
          @image.user_id = session[:user_id]
        rescue
          @image = Image.new
          @image.errors.add :image, t('image.invalid_file')
          ok = false
        end
        if ok
            unless @image.image_valid?
              @image.destroy
              @image.errors.add :image, t('image.invalid_file')
            else
              @image.save
              created = (@image.errors.length == 0)
              @image.move_to_folder f if (f && created)
            end
          end
      else
        @image = Image.new
        @image.errors.add :image, t('main.invalid_file')
      end
      unless imagen
        @folders = Folder.roots_with_owner
        @objects = Image.orphans
        html = render_to_string(:partial => 'tree')
      else
        node = render_to_string(:partial => 'object_node', :locals => { :object_node => @image }) if created
      end
      else
          @image = Image.new
          @image.errors.add :image, t('image.invalid_file')
          imagen = true
          ok = false
      end
      errores = render_to_string(:partial => 'errors_js')
      responds_to_parent do
        render :update do |page|
          page.call("$.alerts._hide");
          if imagen
            if created
              folder_id=0 if folder_id==''
              page.call('add_object_to_tree', @image.id, folder_id,node)
              page.call('show_preview_image',@image.id)
            end
          else
            page.call('reload_tree',html);
          end
          page.call("jAlert",errores,t('main.errors')) if (errores.length>0)
        end
      end
    end

    def create_folder
      folder = Folder.new(params[:folder])
      if folder.name==''
        folder.name = t('organizable.new_folder')
      end
      parent = 0
      if params[:pfolder][:id] != ''
        f = Folder.find_by_id params[:pfolder][:id]
        parent = f ? f.id : 0
      end
      folder.parent_id = parent
      folder.user_id = session[:user_id]
      folder.site_id = session[:site_id]
      folder.save
      @folders = Folder.roots_with_owner
      @objects = Image.orphans
      html = render_to_string(:partial => 'tree')
      render :update do |page|
         page.call('reload_tree',html);
      end
    end
    
    def show
      @image = Image.find_by_id params[:idimage]
    end

    def download
      send_file RAILS_ROOT + "/public" + params[:image]
    end

    def clone
      id = params[:id]
      destino = params[:destino].split("_")[1].to_i
      @image = Image.find(id).clone_with_files
      @image.folder = Folder.find_by_id(destino) unless destino == 0
      @image.save
      node = render_to_string(:partial => 'object_node', :locals => { :object_node => @image })
      render :update do |page|
        page.call('add_object_to_tree', @image.id, "Folder_#{destino}",node)
        page.call('show_preview_image',@image.id)
      end
    end

    def delete
      # Solo borraremos la imagen si no está asociada a ningún objecto
      image = Image.find_by_id params[:id]
      image_id = image.id
      if !image.attached?
        begin
          image.destroy
        rescue
          # Si no hay imagen físicamente en el disco, falla
          image.image = nil
          image.destroy
        end
        if request.xhr?
          render :update do |page|
            page.call('delete_node_from_tree',"Image_#{image_id}")
          end
        end
      else
        if request.xhr?
          render :update do |page|
            page.call("jAlert",'<p>' + t('organizable.error_delete_object') + '</p>',t('main.error'))
          end
        end
      end
    end



    def destroy
    end
    
    # Establece permisos genéricos para las acciones de los controladores
    # Cada controlador puede sobreescribir este método para determinar
    # los permisos de acceso a sus diferentes acciones.
    def self.default_access(action_name, user, objeto)
      if user
        return true
      else
        ["download","click"].include?(action_name) ? (return true) : (return false)
      end

    end 
  
end