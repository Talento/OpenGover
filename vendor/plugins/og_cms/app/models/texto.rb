# coding: iso-8859-1

class Texto
  include MongoMapper::Document

  key :texto, String
  key :page_id, String
  key :site_id, ObjectId
  key :block_name, String
  key :locale, String
  key :application, Hash
  key :editing_host, String


  #acts_as_audited
  #acts_as_indexable
  belongs_to :page
  belongs_to :site

  before_save :sanitize_text


#  def after_save
#    page.save if page
#  end

  def title
    if self.page
      return self.page.title
    else
      return ""
    end
  end

  def self.find_by_page_and_block_name(page, block_name)
    #Search the content in the correct locale. If it does not exist, create a copy form the original locale
    t = self.first(:page_id => page.id, :block_name => block_name, :locale => I18n.locale)
    return t if t

    t1 = self.first(:page_id => page.id, :block_name => block_name)
    return nil if t1.blank?

    t = t1.clone
    t.locale = I18n.locale
    t.save
    return t
  end

  def self.find_by_application_and_block_name(app, block_name)
    t = self.first(:application => app, :block_name => block_name, :locale => I18n.locale)
    return t if t

    t1 = self.first(:application => app, :block_name => block_name)
    return nil if t1.blank?

    t = t1.clone
    t.locale = I18n.locale
    t.save
    return t
  end
  def self.find_by_application_and_block_name_and_site(app, block_name, site)
    t = self.first(:application => app, :block_name => block_name, :site_id => site.id, :locale => I18n.locale)
    return t if t

    t1 = self.first(:application => app, :block_name => block_name, :site_id => site.id)
    return nil if t1.blank?

    t = t1.clone
    t.locale = I18n.locale
    t.save
    return t
  end

  # Realiza un tratamiento de todos los textos a guardar:
  #  - Imágenes: redimensiona y comprime
  #  - Vídeos: Quita el object e introduce un snapshot para la carga
  #  - Flash: Quita el object
  def sanitize_text
    attributes = %w(id href align src width height alt cite datetime title class oid style target data wmode  type value name)
    # Para IE8, metemos entre "" todos los atributos de las etiquetas, ya que el IE8 las quita
    self.texto = self.texto.gsub( /(\w+)=((\w|-)+)/m ) do | element |
      attr = $1.downcase
      valu = $2
      if attributes.include?attr
        " #{attr}=\"#{valu}\" "
      else
        "#{attr}=#{valu}"
      end
    end
    # Tratamos las imágenes
    t = texto
    # Obtenemos todas las imágenes
    r = Regexp.new("<img([^>]*?)>",Regexp::MULTILINE | Regexp::IGNORECASE)
    r_src = Regexp.new("src=\"/([^>]*?)\"")
    r_style = Regexp.new("style=\"width: ([^>]*?)px; height: ([^>]*?)px;\"")
    imagenes = t.scan r
    for imagen in imagenes
      # Para cada imagen obtenemos sus nuevas dimensiones, en caso de que las tenga
#      begin
        url = imagen[0].scan r_src
        if !url.blank?
          url = url[0][0]
          image = Image.find_by_url url
          size = imagen[0].scan r_style
          # Si nos meten dimensiones, redimensionamos
          unless size.blank?
            #image.scale_to size[0][0], size[0][1]
            nuevo = image.file.url_for_size(size[0][0],size[0][1])
            r_image = Regexp.new("<img([^>]*?)src=\"/#{url}\"([^>]*?)>",Regexp::MULTILINE | Regexp::IGNORECASE)
            res = texto.scan r_image
#            texto.gsub!(r_image,"<img src=\"#{image.path_url + nuevo}\" #{res[0][1]} alt=\"#{res[0][2]}\" class=\"#{res[0][3]}\" width=\"#{size[0][0]}\" height=\"#{size[0][1]}\"/>")
          self.texto.gsub!(r_image) do | element |
            pre = $1.clone
            post = $2.clone
            r_style_ = Regexp.new("style=\"([^>]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
            pre.gsub!(r_style_,"")
            post.gsub!(r_style_,"")
            pre.gsub!("width=\"([^\"]*?)\"","")
            post.gsub!("width=\"([^\"]*?)\"","")
            pre.gsub!("height=\"([^\"]*?)\"","")
            post.gsub!("height=\"([^\"]*?)\"","")
            "<img #{pre} src=\"#{nuevo}\" #{post} width=\"#{size[0][0]}\" height=\"#{size[0][1]}\"/>"
          end
          end
        end
#      rescue
#      end
    end

    # Quitamos el contenido de las etiquetas del videoplayer
    t = self.texto
    # Obtenemos todos los objetos de tipo videoplayer_playlist
    r = Regexp.new("<a([^>]*?)class([^>]*?)videoplayer_playlist([^>]*?)>(.*?)</a>",Regexp::MULTILINE | Regexp::IGNORECASE)
    r_oid = Regexp.new("id=\"videos_([^>]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    vplayers = t.scan r
    for vplayer in vplayers do
      # Para cada player insertamos el enlace con el snapshot
      begin
        oid = vplayer[1].scan r_oid
        if !oid.blank?
          oid = oid[0][0]
          video = Folder.find(oid.to_i).objects_without_permissions("Video").first
          s = Regexp.new("<a class([^>]*?)videoplayer_playlist([^>]*?)id=\"videos_#{oid}\">(.*?)</a>",Regexp::MULTILINE | Regexp::IGNORECASE)
          self.texto.gsub!(s,"<a class=\"videoplayer_playlist\" id=\"videos_#{oid}([^>]*?)\"><img src=\"#{video.screenshot}\" alt=\"#{I18n.t('video.play')}\"/></a>")
        else
          oid = vplayer[0].scan r_oid
          if !oid.blank?
            oid = oid[0][0]
            video = Folder.find(oid.to_i).objects_without_permissions("Video").first
            s = Regexp.new("<a([^>]*?)id=\"videos_#{oid}\"([^>]*?)>(.*?)</a>",Regexp::MULTILINE | Regexp::IGNORECASE)
            self.texto.gsub!(s,"<a class=\"videoplayer_playlist\" id=\"videos_#{oid}\"><img src=\"#{video.screenshot}\" alt=\"#{I18n.t('video.play')}\"/></a>")
          end
        end
      rescue
      end
    end
    # Quitamos el contenido de las etiquetas del videoplayer
    t = self.texto
    # Obtenemos todos los objetos de tipo videoplayer
    r = Regexp.new("<a([^>]*?)class([^>]*?)videoplayer([^>]*?)>(.*?)</a>",Regexp::MULTILINE | Regexp::IGNORECASE)
    r_oid = Regexp.new("id=\"video_([^>]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    vplayers = t.scan r
    for vplayer in vplayers do
      # Para cada player insertamos el enlace con el snapshot
      begin
        oid = vplayer[1].scan r_oid
        if !oid.blank?
          oid = oid[0][0]
          video = Video.find oid
          s = Regexp.new("<a class([^>]*?)videoplayer([^>]*?)id=\"video_#{oid}\"([^>]*?)>(.*?)</a>",Regexp::MULTILINE | Regexp::IGNORECASE)
          self.texto.gsub!(s,"<a class=\"videoplayer\" href=\"#{video.flv}\" id=\"video_#{oid}\"><img src=\"#{video.screenshot}\" alt=\"#{I18n.t('video.play')}\"/></a>")
        else
          oid = vplayer[0].scan r_oid
          if !oid.blank?
            oid = oid[0][0]
            video = Video.find oid
            s = Regexp.new("<a([^>]*?)id=\"video_#{oid}\"([^>]*?)>(.*?)</a>",Regexp::MULTILINE | Regexp::IGNORECASE)
            self.texto.gsub!(s,"<a class=\"videoplayer\" href=\"#{video.flv}\" id=\"video_#{oid}\"><img src=\"#{video.screenshot}\" alt=\"#{I18n.t('video.play')}\"/></a>")
          end
        end
      rescue Exception => e
        e
      end
    end

    # Quitamos el contenido del flash
    t = self.texto
    # Obtenemos todos los objetos de tipo flash
    r = Regexp.new("<div([^>]*?)class([^>]*?)flash_container([^>]*?)>(.*?)</div>",Regexp::MULTILINE | Regexp::IGNORECASE)
    r_oid = Regexp.new("id=\"flash_([^>]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    r_params = Regexp.new("height=\"([^>]*?)\"(.*?)width=\"([^>]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    r_params_r = Regexp.new("width=\"([^>]*?)\"(.*?)height=\"([^>]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    flashes = t.scan r
    for fl in flashes do
      # Para cada player insertamos el enlace con el snapshot
      begin
        oids = fl[2].scan r_oid
        oids = fl[0].scan r_oid if oids.blank?
        if !oids.blank?
          oid = oids[0][0]
          pars = fl[3].scan r_params
          unless pars.blank?
            width = pars[0][2]
            height = pars[0][0]
          else
            pars = fl[3].scan(r_params_r)
            width = pars[0][0]
            height = pars[0][2]
          end
          fo = Flashobject.find oid
          s = Regexp.new("<div([^>]*?)id=\"flash_#{oid}\"([^>]*?)>(.*?)</div>",Regexp::MULTILINE | Regexp::IGNORECASE)
          res = texto.scan s
          self.texto.gsub!(s,"<div class=\"flash_container\" id=\"flash_#{oid}\" file=\"#{fo.filename.url}\" width=\"" + width + "\" height=\"" + height + "\"><div id=\"flash_replace_#{fo.id}\"></div></div>") unless res.blank?
        end
      rescue
      end
    end
    # Los <br/> están sin cerrar, los cerramos
    s = Regexp.new("<br>",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"<br/>")
    
    # Los <hr/> están sin cerrar, los cerramos
    s = Regexp.new("<hr>",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"<hr/>")
    
    # Quitamos los imagefetcheropts="null" y los jqueryxxxxx="xxx"
    s = Regexp.new("imagefetcheropts=\"null\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")
    s = Regexp.new("unselectable=\"on\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")
    s = Regexp.new("jquery([0-9]*?)=\"([0-9]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")
    s = Regexp.new("done([0-9]*?)=\"([0-9]*?)\"",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")

    # Quitamos las marcar del nicedit
    s = Regexp.new("<!--aux_block_start-->",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")
    s = Regexp.new("<!--aux_block_end-->",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")
    s = Regexp.new("<!--aux_content-->",Regexp::MULTILINE | Regexp::IGNORECASE)
    self.texto.gsub!(s,"")

    # Eliminamos las etiquetas style vacías, que pueden ser generadas por el editor
    self.texto.gsub!("style=\"\"","")

    # Eliminamos todos los contenteditable, por si quedase alguno
    self.texto.gsub!("contenteditable=\"true\"","")

    # IE mete el request.host en enlaces e imágenes, lo quitamos
    self.texto.gsub!(Regexp.new("https?://#{self.editing_host}"),"")
    clear_tags
  end

  def clear_tags

          ok_tags = "img,h1,h2,h3,h4,h5,h6,hr,p,a,table,tr,td,th,ul,ol,li,sub,sup,span,div,strong,br,u,i,b,em"
    cerrar_lista = 0
    # tags que pueden ir sin contenido
    solo_tags = ["br","hr","img"]

    # Construimos el hash de tags permitidos
    tags = ok_tags.downcase().split(',').collect!{ |s| s.split(' ') }
    allowed = Hash.new
    tags.each do |s|
      key = s.shift
      allowed[key] = s
    end

    # Analizamos todos los elementos del tipo <>
    stack = Array.new
#    result = html.gsub( /(<.*?>)/m ) do | element |
    self.texto = self.texto.gsub( /(<([^<]*?)>)/m ) do | element |
      if element =~ /\A<\/(\w+)/ then
        # </tag>
        tag = $1.downcase
        if allowed.include?(tag) && stack.include?(tag) then
          out = ""
          if tag=="li"
            cerrar_lista += 1
          else
            if (tag=='ol' || tag=='ul') && cerrar_lista > 0
              cerrar_lista -= 1
              top = stack.pop
              out << "</#{top}>"
            end
            # Si está permitido y en la pila, lo sacamos
            top = stack.pop
            out << "</#{top}>"
            until top == tag do
              top = stack.pop
              out << "</#{top}>"
            end
          end
          out
        end
      elsif element =~ /\A<(\w+)\s*\/>/
        # <tag />
        tag = $1.downcase
        if allowed.include?(tag) then
            "<#{tag}/>"
        end
      elsif element =~ /\A<(\w+)/ then
        # <tag ...>
        tag = $1.downcase
        if allowed.include?(tag) then
          out = ""
          # Genera mal las listas anidadas. En caso de error, corregimos
          if (tag=='ol' || tag=='ul') && (stack.include?('ol') || stack.include?('ul'))
            cerrar_lista += 1
          else
            if tag=='li' && stack.last=='li'
              top = stack.pop
              out << "</#{top}>"
            end
          end
          if ! solo_tags.include?(tag) then
            stack.push(tag)
          end
#          if allowed[tag].length == 0 then
#            # no allowed attributes
#            "<#{tag}>"
#          else
            # allowed attributes?
            out << "<#{tag}"
            while ( $' =~ /(\w+)=("[^"]+")/ )
              attr = $1.downcase
              valu = $2
              if attr=="href" || attr=="src"
                valu = h_texto_attr valu
              end
#              if allowed[tag].include?(attr) then
                out << " #{attr}=#{valu}"
#              end
            end
            if ! solo_tags.include?(tag) then
              out << ">"
            else
              out << "/>"
            end
#          end
        end
      end
    end

    # eat up unmatched leading >
    while self.texto.sub!(/\A([^<]*)>/m) { $1 } do end

    # eat up unmatched trailing <
    while self.texto.sub!(/<([^>]*)\Z/m) { $1 } do end

    # clean up the stack
    if stack.length > 0 then
      self.texto << "</#{stack.reverse.join('></')}>"
    end

    # Limpiamos todo lo que está entre etiquetas
    self.texto = self.texto.gsub( /(>.*?<)/m ) do | element |
      ">" + h_texto(element[1..element.length - 2]) + "<"
    end

    # Limpiamos todo lo que está al principio
    self.texto = self.texto.gsub( /\A[^<>]*</m ) do | element |
      (element.length > 1) ? h_texto(element[0..element.length - 2]) + "<" : "<"
    end

    # Limpiamos todo lo que está al final
    self.texto = self.texto.gsub( />[^<>]+\Z/m ) do | element |
      ">" + h_texto(element[1..element.length - 1])
    end

#    result = result.gsub(/<p> <\/p>/mi) do |element|
#      '<br/>'
#    end

  end

  def h_texto s
    s.to_s.gsub(/&(?![a-z]+;)/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;").gsub(Regexp.new("€".force_encoding("ASCII-8BIT")),"&euro;")
  end

  def h_texto_attr s
    s.to_s.gsub(/&(?![a-z]+;)/, "&amp;")
  end
#  def lang
#      if self.page_id != 0
#                return self.page.lang
#      else
#          return "es"
#      end
#  end

#  def after_create
#      # Index the item for searching
#      url ="/pages/index/" + self.page_id.to_s + "?block=" + self.block_id.to_s
#      index_data = IndexableRecord::IndexData.new(:data => self.data, :uri => url, :title => title)
#      IndexableRecord.index_records(index_data)
#  end
#
#  def after_update
#      # Update the indexed search data
#      url ="/pages/index/" + self.page_id.to_s + "?block=" + self.block_id.to_s
#      index_data = IndexableRecord::IndexData.new(:data => self.data, :uri => url, :title => title)
#      IndexableRecord.update_index(index_data)
#  end
#
#  def after_destroy
#      # Remove the item from search index
#      url ="/pages/index/" + self.page_id.to_s + "?block=" + self.block_id.to_s
#      IndexableRecord.clear_index(url)
#      @item.destroy
#  end

end
