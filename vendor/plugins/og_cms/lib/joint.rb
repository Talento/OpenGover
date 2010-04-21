require 'set'
require 'mime/types'
require 'wand'
require 'rmagick'

module Joint
  autoload :Version, 'joint/version'

  def self.configure(model)
    model.class_inheritable_accessor :file_attachment_names
    model.file_attachment_names = Set.new
    model.class_inheritable_accessor :image_attachment_names
    model.image_attachment_names = Set.new

    model.class_inheritable_accessor :file_base_url
    model.file_base_url = "/uploads/files/"
    model.class_inheritable_accessor :image_base_url
    model.image_base_url = "/uploads/images/"
  end

  module ClassMethods
    def file_attachment(name)
      self.file_attachment_names << name

      after_save     :save_attachments
      after_save     :destroy_nil_attachments
      before_destroy :destroy_all_attachments

      key "#{name}_id".to_sym,   ObjectId
      key "#{name}_name".to_sym, String
      key "#{name}_size".to_sym, Integer
      key "#{name}_type".to_sym, String
      key "#{name}_version".to_sym, Integer, :default => 0

      class_eval <<-EOC
        def #{name}
          @#{name} ||= FileAttachmentProxy.new(self, :#{name})
        end

        def #{name}?
          self.send(:#{name}_id?)
        end

        def #{name}=(file)
          if file.nil?
            nil_attachments << :#{name}
          else
            self["#{name}_id"]             = BSON::ObjectID.new if self["#{name}_id"].nil?
            self["#{name}_size"]           = File.size(file)
            self["#{name}_type"]           = Wand.wave(file.path)
            self["#{name}_version"] += 1
            self["#{name}_original_name"]  = Joint.file_name(file)
            self["#{name}_name"]           = self["#{name}_id"].to_s + File.extname(self["#{name}_original_name"])
            assigned_attachments[:#{name}] = file
          end
        end
      EOC
    end
    def image_attachment(name, sizes={})
      self.image_attachment_names << name

      after_save     :save_attachments
      after_save     :destroy_nil_attachments
      before_destroy :destroy_all_attachments

      key "#{name}_id".to_sym,   ObjectId
      key "#{name}_name".to_sym, String
      key "#{name}_size".to_sym, Integer
      key "#{name}_type".to_sym, String
      key "#{name}_width".to_sym, Integer
      key "#{name}_height".to_sym, Integer
      key "#{name}_version".to_sym, Integer, :default => 0

      class_eval <<-EOC
        def #{name}
          @#{name} ||= ImageAttachmentProxy.new(self, :#{name})
        end

        def #{name}?
          self.send(:#{name}_id?)
        end

        def #{name}=(file)
          if file.nil?
            nil_attachments << :#{name}
          else
            self["#{name}_id"]             = BSON::ObjectID.new if self["#{name}_id"].nil?
            self["#{name}_size"]           = File.size(file)
            self["#{name}_type"]           = Wand.wave(file.path)
            self["#{name}_version"] = 1

#            begin
#              img = ::Magick::Image.from_blob(file.read).first
#              self["#{name}_width"] = img.columns
#              self["#{name}_height"] = img.rows
#            rescue
              self["#{name}_width"] = 0
              self["#{name}_height"] = 0
#             end

            self["#{name}_original_name"]  = Joint.file_name(file)
            self["#{name}_name"]           = self["#{name}_id"].to_s + File.extname(self["#{name}_original_name"])

            assigned_attachments[:#{name}] = file
          end
        end

        def sizes
          #{sizes.to_s}
        end
      EOC

      sizes.each_pair do |size_name, size|
        class_eval <<-EOC
          def #{name}_#{size_name}
             "#{size}_\#\{#{name}_name\}"
          end
        EOC
      end

    end
  end

  module InstanceMethods
    def grid
      @grid ||= Mongo::Grid.new(database)
    end

    private
      def assigned_attachments
        @assigned_attachments ||= {}
      end

      def nil_attachments
        @nil_attachments ||= Set.new
      end

      # IO must respond to read and rewind
      def save_attachments
        assigned_attachments.each_pair do |name, io|
          next unless io.respond_to?(:read)
          io.rewind if io.respond_to?(:rewind)
          grid.delete(send(name).name)
          grid.put(io.read, send(name).name, {
            :_id          => send(name).id,
            :content_type => send(name).type,
          })
          #grid.put(io.read, send(name).id, {
          #  :_id          => send(name).id,
          #  :content_type => send(name).type,
          #})

        end
        assigned_attachments.clear
      end

      def destroy_nil_attachments
        nil_attachments.each { |name| grid.delete(send(name).id) }
        nil_attachments.clear
      end

      def destroy_all_attachments
        self.class.attachment_names.map { |name| grid.delete(send(name).id) }
      end
  end

  class FileAttachmentProxy
    def initialize(instance, name)
      @instance, @name = instance, name
    end

    def id
      @instance.send("#{@name}_id")
    end

    def name
      @instance.send("#{@name}_name")
    end

    def size
      @instance.send("#{@name}_size")
    end

    def type
      @instance.send("#{@name}_type")
    end

    def version
      @instance.send("#{@name}_version")
    end

    def extension
      File.extname(name)
    end

    def url
      "#{@instance.file_base_url}v#{version}_#{name}"
    end

    def grid_io
      @grid_io ||= @instance.grid.get(id)
    end

    def method_missing(method, *args, &block)
      grid_io.send(method, *args, &block)
    end
  end


  class ImageAttachmentProxy
    def initialize(instance, name)
      @instance, @name = instance, name
    end

    def id
      @instance.send("#{@name}_id")
    end

    def name
      @instance.send("#{@name}_name")
      #"#{width}x#{height}_v#{version}_#{id}#{extension}"
    end

    def size
      @instance.send("#{@name}_size")
    end

    def width
      @instance.send("#{@name}_width")
    end

    def height
      @instance.send("#{@name}_height")
    end

    def type
      @instance.send("#{@name}_type")
    end

    def version
      @instance.send("#{@name}_version")
    end

    def extension
      File.extname(name)
    end

    def url
      "#{@instance.image_base_url}#{width}x#{height}_v#{version}_#{name}"
    end

    def url_for_size(w,h)
      "#{@instance.image_base_url}#{w}x#{h}_v#{version}_#{name}"
    end

    def grid_io
      @grid_io ||= @instance.grid.get(id)
    end

    def method_missing(method, *args, &block)
      if @instance.sizes.keys.include?(method)
         ImageVersionAttachmentProxy.new(self, name.to_sym, @instance.sizes[method.to_sym], @instance.image_base_url)
      else
        grid_io.send(method, *args, &block)
      end
    end
  end

  class ImageVersionAttachmentProxy
    def initialize(instance, name, version, base_url)
      @instance, @name, @version, @base_url = instance, name, version, base_url
    end

    def id
      @instance.id
    end

    def name
      "#{width}x#{height}_v#{version}_#{id}#{extension}"
    end

    def width
      @version.gsub(/^c?(.*?)x(.*?)$/){$1}
    end

    def height
      @version.gsub(/^c?(.*?)x(.*?)$/){$2}
    end

    def type
      @instance.type
    end

    def version
      @instance.version
    end

    def extension
      @instance.extension
    end

    def url
      "#{@base_url}#{name}"
    end

    def grid_io
      @grid_io ||= @instance.grid_io
    end

    def method_missing(method, *args, &block)
      grid_io.send(method, *args, &block)
    end
  end

  def self.file_name(file)
    file.respond_to?(:original_filename) ? file.original_filename : File.basename(file.path)
  end
end
