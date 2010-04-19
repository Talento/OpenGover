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
      load_index_data()
    end

    def click_object
#      begin
      @type = params[:id].gsub(/^(.*?)_.*/){$1}.downcase
      object_id = params[:id].gsub(/^(.*?)_/,"")
      type_class = @type.camelize.constantize
        @object = type_class.find object_id
        render :update do |page|
          page['preview'].html(render(:partial => 'click_object'))
        end
#      rescue
#        render :text => ''
#      end
    end

    def click
      @folder = Folder.find params[:id]
      @type = params[:type]
      unless @folder
        @folder = Folder.new
        @folder.id = 0
      end
      @permisos = [[I18n.t("folder.owner"), 0],[I18n.t("folder.all"), -1]]
      if params[:type]
        t = render_to_string(:action => "click_#{@type}") 
         render :update do |page|
          page['preview'].html(t)
        end
      end
    end

    def update
      f = Folder.find params[:id]
      f.name = params[:name]
      f.role = params[:role]
      f.save
      f.update_descendants_role if params[:recursive]=='true'
      render :update do |page|
        page.call('folder_name_modified',params[:id], params[:name]);
      end
    end

    def create
      folder = Folder.new(params[:folder])
      if folder.name==''
        folder.name = t('organizable.new_folder')
      end
      
      unless params[:pfolder][:id].blank? || params[:pfolder][:id]=="0"
        folder.parent_id = params[:pfolder][:id]
        folder.role = Folder.find(folder.parent_id).role
      end

      folder.user_id = current_user.id
      folder.save
      load_index_data()
      html = render_to_string(:partial => 'tree')
      render :update do |page|
         page.call('reload_tree',html);
      end
    end

    def create_object

#      imagen = false
#      created = false
#      ok = true
      # Carpeta a la que moveremos los objetos
#      f=nil
#      folder_id = params[:folder][:id]
      folder_type = params[:folder][:id].gsub(/^(.*?)_.*/){$1}.downcase
      folder_id = params[:folder][:id].gsub(/^(.*?)_/,"")
      type = params[:type]
      type_class = type.camelize.constantize

#      if params[:folder][:id] != ''
        if folder_type == 'folder'
          f = Folder.find folder_id
        else
          f = Folder.all( :"#{folder_type.pluralize}.id" => folder_id) #get_parent_folder params[:folder][:id].split('_')[0], params[:folder][:id].split('_')[1]
#          if f
#            folder_id = "Folder_#{f.id}"
#          else
#            folder_id=0
#          end
        end
#      end
      ext = params[type][:file].original_filename.split('.').last.downcase unless params[type][:file].blank?
      if ext.blank?
        @object = type_class.new
        @object.errors.add :object, t('main.invalid_file')
      elsif ext.eql?('zip')
#        title = params[:image][:title]
#        name = params[:image][:name]
        params[type].delete(:title)
        params[type].delete(:name)
        @zip = ZipObject.new(params[type])
        @zip.save
        @zip.save_objects_with_folders f,current_user
        @zip.destroy
        @object = type_class.new
      elsif type_class.valid_formats.include?ext
#        begin
          @object = type_class.new(params[type])
#          @object.user = current_user
#        rescue
#
#          ok = false
#        end
#        if ok
#            unless @image.image_valid?
#              @image.destroy
#              @image.errors.add :image, t('image.invalid_file')
#            else

        f.send(type.pluralize) << @object
              if f.save
#                @image.move_to_folder f if (f && created)
              else
                @object = type_class.new
                @object.errors.add :object, t('main.invalid_file')
              end
#            end
#          end
    end


      if ext.blank?
                @object = type_class.new
                @object.errors.add :object, t('main.invalid_file')
#          imagen = true
#          ok = false
      else
        if !@object || @object.new?
        load_index_data
        html = render_to_string(:partial => 'tree')
      else
        node = render_to_string(:partial => 'object_node', :locals => { :object_node => @object }) #if created
      end
      end
      errores = render_to_string(:partial => 'errors_js')
      responds_to_parent do
        render :update do |page|
          page.call("$.alerts._hide");
          if @object.new?
            page.call('reload_tree',html);
          else
#            if created
#              folder_id=0 if folder_id==''
              page.call('add_object_to_tree', @object.id, f.id,node)
              page.call('show_preview_image',@object.id)
#            end
          end
          page.call("jAlert",errores,t('main.errors')) if (errores.length>0)
        end
      end
    end
    
    
    def new
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
    

  private

    def load_index_data
      if params[:id]
        f=Folder.find params[:id]
        @folders = f.children_for_user(current_user)
        @objects = f.send(params[:type].pluralize.to_sym)
        render :partial => 'folders'
      else
        if current_user && current_user.is?("admin")
          @folders = Folder.roots_for_admin
        else
          @folders = Folder.roots_for_user(current_user)
        end
        @objects = [] #Image.orphans
        @image = Image.new
        @destino = params[:destino]
        @type = params[:type]
      end
    end
  
end