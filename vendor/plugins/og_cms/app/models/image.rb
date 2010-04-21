#require 'RMagick'
#require 'image_science'

class Image
  include MongoMapper::Document
  plugin Joint
  include Slug

  key :title, String
  key :name, String
  key :user_id, String
#  key :site_id, ObjectId
#  key :width, Integer
#  key :height, Integer
  timestamps!
  #mount_uploader :file, ImageUploader
  image_attachment(:file, {:thumb => "c200X200", :thumbnail => "c50x50", :tree => "c24x24", :gallery => "476x357", :gallery_thumb => "98x74"})

  slug :title

  belongs_to :user
  belongs_to :folder
#  belongs_to :site

  #after_save :set_size


  validates_presence_of :title #, :file




#  image_column :image, :store_dir => proc{|record, file| "image/#{record.id}"}, :versions => { :thumbnail => "200x150", :tree => "c24x24", :gallery => "476x357", :gallery_thumb => "98x74"}
#
  def self.valid_formats
    ['jpg','jpeg','gif','png']
  end

  def self.find_by_url(url)
      key = ""
      url.gsub(/\?.*/,"").gsub(/\/c?(\d*)x(\d*)_v(.*?)_(.*?)\.(.*?)$/){
        key =   $4
      }
    Image.first(:file_id => key)
  end

  def url_for_size(w,h)
    
  end


##  def valid_format?
##    self.image && Image.valid_formats.include?(self.image.file_name.split(".").last.downcase)
##  end
#
#  def self.new_with_folder fname, folder, user, site
#    image = Image.new({ :image => File.open(fname), :title => fname.split("/").last, :user_id => user, :site_id => site})
#    image.save
#    image.folder = folder if folder
#    image
#  end
#
#  def add_thumbnail(file)
#    self.image = File.open(file)
#    unless self.save
#      errors.add(:image, I18n.t('organizable.invalid_file', :file => file))
#    end
#  end
#
#  def alt
#    self.title || self.image.to_s || ''
#  end
#
#def set_size
#  #if self.file
#    img = ::Magick::Image.from_blob(self.file.read).first
#    if self.width != img.columns || self.height != img.rows
##      self.width = img.columns
#      self.height = img.rows
#      self.save
#    end
#  #end
#end
##
##  # Antes de destruir comprobamos que no esté asociada a nada
##  def before_destroy
##    self.image = nil unless File.exists? self.image.path
###      FileUtils.remove_dir(self.image.store_dir, true) if File.exists? self.image.path
##  end
#
#  def scale(sizes)
#        if image and File.file?(RAILS_ROOT+"/public" + image.url)
#                for name in sizes.keys
#                        size = sizes[name]
#                        rescale_to size
#                end
#        end
#  end
#
#  def scale_to(width, height)
#        if image and File.file?(RAILS_ROOT+"/public" + image.url)
#                size = "#{width}x#{height}"
#                rescale_to size
#        end
#  end
#
##  def image_valid?
##    if valid_format?
##      true
##    else
##      errors.add :image, I18n.t('organizable.invalid_file', :file => self.image)
##      false
##    end
##  end
#
#  def create_thumbnail
#    img = ::Magick::Image.read(self.image.path).first
#    self.cols = img.columns
#    self.rows = img.rows
#    crop_image = img.crop_resized(50,50)
#    crop_image.strip!
#    crop_image.write(self.image.thumbnail.path){self.image.thumbnail.path.split(".").last.downcase.eql?"gif" ?  self.quality=100 :  self.quality=80}
#  end
#
  def crop(x,y,width,height)
     imag = ::Magick::Image.from_blob(file.read).first #::Magick::Image.read(RAILS_ROOT+"/public" + image.url).first
     self.file = imag.crop(x.to_f, y.to_f, width.to_f, height.to_f, true)
     self.save
     #crop_image = imag.crop(x.to_f, y.to_f, width.to_f, height.to_f, true)

     #crop_image.write(RAILS_ROOT+"/public" + image.url)
     #self.image = File.open(self.image.path)
     #self.save
     #Dir.entries(path_image).each do |f|
     #  size = f.split("_").first.gsub("c","").split("x")
     #  if (size.length == 2)
     #    # Hay que redimensionar nuevamente
     #    rescale_to "#{size[0]}x#{size[1]}"
     #  end
     #end
  end
#
#
#  def rescale
#        sizes = { :portada => "c617x266", :detalle => "c617x266",  :portadilla => "c282x122", :subseccion => "c169x73", :especial => "c185x120" }
#        if image and File.file?(RAILS_ROOT+"/public" + image.url)
#                img = ::Magick::Image.read(RAILS_ROOT+"/public" + image.url).first
#                for name in sizes.keys
#                        size = sizes[name]
#                                crop = size.starts_with?("c")
#                                width = size.gsub("c","").split("x").first.to_i
#                                height = size.gsub("c","").split("x").last.to_i
#                                if crop
#                                        crop_image = img.crop_resized(width,height)
#                                else
#                                        crop_image = img.resize_to_fit(width,height)
#                                end
#                                crop_image.strip!
#                                crop_image.write(image.dir + "/" + size + "_" +image.to_s){self.image.thumbnail.path.split(".").last.downcase.eql?"gif" ?  self.quality=100 :  self.quality=80}
#             end
#        end
#  end
#
  def rotate angle
    imag = ::Magick::Image.from_blob(file.read).first #::Magick::Image.read(RAILS_ROOT+"/public" + image.url).first
    self.file = imag.rotate(angle)
    se  lf.save
#    imag.rotate(angle).write(RAILS_ROOT+"/public" + image.url)
#    self.image = File.open(self.image.path)
#    self.save
#    Dir.entries(path_image).each do |f|
#      size = f.split("_").first.gsub("c","").split("x")
#      if (size.length == 2)
#        # Hay que rotar nuevamente
#        imag = ::Magick::Image.read(path_image + f).first
#        imag.rotate(angle).write(path_image + f)
#      end
#    end
  end
#
#  def clone_with_files
#    i = clone
#    i.image = nil
#    i.title = i.title + " (copy)" unless i.title.include?"(copy)"
#    i.save false
#    s = path_image
#    FileUtils.cp_r path_image, "#{s[0...(s.length-s.reverse.index("/",2))]}#{i.id}/"
#    i.image = image
#    i.save
#    i
#  end
#
#
#  def crop_recortable(x,y,width,height,sizes,imagen_recortable)
#
#
#             imag = ::Magick::Image.read(RAILS_ROOT+"/public" + image.url).first
#             orig_width = imag.base_columns
#             orig_height = imag.base_rows
#
#             imag_crop = ::Magick::Image.read(RAILS_ROOT+"/public" + imagen_recortable).first
#             preview_width = imag_crop.base_columns
#             preview_height = imag_crop.base_rows
#
#             factor_x = orig_width.to_f / preview_width.to_f
#             factor_y = orig_height.to_f / preview_height.to_f
#
#             x_mod = x.to_f * factor_x
#             y_mod = y.to_f * factor_y
#             width_mod = width.to_f * factor_x
#             height_mod = height.to_f * factor_y
#
#             #g = ::Magick::Geometry.new(width,height,x,y,Magick::AspectGeometry)
#             crop_image = imag.crop(x_mod, y_mod, width_mod, height_mod, true)
#
#             #crop_image.write((RAILS_ROOT+"/public" + image.url).gsub(image.image,"") + "final_" + image.image)
#
#          for name in sizes.keys
#              if name.to_s!="recortable"
#                        size = sizes[name]
#                                crop = size.starts_with?("c")
#                                width = size.gsub("c","").split("x").first.to_i
#                                height = size.gsub("c","").split("x").last.to_i
#                                if crop
#                                        cropped_image = crop_image.crop_resized(width,height)
#                                else
#                                        cropped_image = crop_image.resize_to_fit(width,height)
#                                end
#                                cropped_image.strip!
#                                cropped_image.write(image.dir + "/" + size + "_" +image.to_s){self.image.thumbnail.path.split(".").last.downcase.eql?"gif" ?  self.quality=100 :  self.quality=80}
#              end
#             end
#
#
#    end
#
#    def path_url
#      s=image.url
#      s[0...(s.length-s.reverse.index("/"))]
#    end
#
#    def path_image
#      s=image.path
#      s[0...(s.length-s.reverse.index("/"))]
#    end
#
#    def image_name
#      image.url.split("/").last
#    end
#
#    def width
#      if self.cols
#        self.cols
#      else
#        img = Magick::Image::read(self.image.path).first
#        self.cols = img.columns
#        self.save
#        self.cols
#      end
#    end
#
#    def height
#      if self.rows
#        self.rows
#      else
#        img = Magick::Image::read(self.image.path).first
#        self.rows = img.rows
#        self.save
#        self.rows
#      end
#    end
#
#
#
#
#        def move_to_folder folder, pos=0
#          if folder
#            folder.images << self
#            folder.save
#
#            self._parent_document.images.delete(self)
#            self._parent_document.save
##
##            fo=nil
##            begin
##              fo = FolderObject.find :first, :conditions => ['object_id=? AND object_type=?',self.id, self.class.to_s]
##              fo.shift_to(folder.id, pos)
##              self.user = folder.user
##              self.save
##            rescue
##              FolderObject.new(:object_id => self.id, :folder_id => folder.id, :object_type => self.class.to_s).save
##            end
#          end
#        end
#
##        def move_to_root
##          fo = FolderObject.find :first, :conditions => ['object_id=? AND object_type=?',self.id, self.class.to_s]
##          fo.destroy if fo
##        end
#
#
#      protected
#
##      def validate
##      end
#
#      private
#
#      def rescale_to(size)
#        unless File.exists?(image.dir + "/" + size + "_" +image.url.split("/").last)
#          img = ::Magick::Image.read(RAILS_ROOT+"/public" + image.url).first
#          crop = size.starts_with?("c")
#          width = size.gsub("c","").split("x").first.to_i
#          height = size.gsub("c","").split("x").last.to_i
#          if crop
#                  crop_image = img.crop_resized(width,height)
#          else
#                  crop_image = img.resize_to_fit(width,height)
#          end
#          crop_image.strip!
#          crop_image.write(image.dir + "/" + size + "_" +image.url.split("/").last){self.quality=85}
#        end
#      end

end
