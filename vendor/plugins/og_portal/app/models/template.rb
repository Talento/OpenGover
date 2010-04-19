# coding: iso-8859-1

class Template

  include MongoMapper::Document
  include Slug
  key :name, String, :required => true
  key :header, String
  key :content, String, :required => true
  key :main, Boolean, :default => false
  key :hidden, Boolean, :default => false
  key :site_id, ObjectId, :required => true

#  has_many :blocks
#  belongs_to_related :site

  many :blocks
  belongs_to :site

  slug :name

#  validates_presence_of :site_id
#  validates_format_of :content, :with => /.*?\@\@main\@\@.*?/

#  before_create :create_slug
  before_save :get_blocks
  before_save :check_main
  #after_save :generate_layout
  #after_destroy :destroy_layout

  def base_path
    Rails.root.to_path
  end

  def layout_name
    "#{self.site_id}_#{self.id.parameterize}"
  end

  def set_as_main
    self.main = true
    self.save
  end

  def self.main_for_site(site_id)
    Template.first(:main => true, :site_id => site_id)
  end

  def self.named_for_site(name,site_id)
    Template.first(:name => name, :site_id => site_id)
  end

  private

  def check_main
    old_main = Template.main_for_site(self.site_id)
    if self.main
      if old_main.id != self.id
        old_main.update_attributes(:main => false)
      end
    elsif old_main.blank?
      self.main = true
    end
  end

  def get_blocks
#    new_blocks = content.scan(/\<\%\=.*?yield(.*?)\%\>/).flatten.collect{|b| b.strip.gsub(":", "") unless b.blank?}.compact
    new_blocks = content.scan(/@@(.*?)@@/).flatten.compact
    for block in self.blocks
      self.blocks.delete(block) unless new_blocks.include?(block.name)
    end
    current_blocks = self.blocks.collect(&:name)
    for new_block in new_blocks
      self.blocks << Block.new(:name => new_block) unless current_blocks.include?(new_block)
    end
  end

  def generate_layout
    f = File.open("#{Rails.root.to_path}/app/views/layouts/#{self.layout_name}.html.erb", "w") do |file|

      file << %{
        <% for block in params[:og_template].blocks %>
            <% content_for block.name.to_sym do %>
                <% for embedded_application in block.embedded_applications %>
                    <%= render_cell(embedded_application.cell_name.to_sym, embedded_application.cell_state.to_sym, embedded_application.cell_params) %>
                <% end %>
            <% end %>
        <% end %>
      }
      f_base = File.open("#{Rails.root.to_path}/app/views/layouts/application.html.erb", "r")
      f_base.each_line do |line|
        file << line.gsub(/\<\%\= *?yield *?\%\>/, self.content)
      end

    end
  end

  def destroy_layout
    File.delete("#{Rails.root.to_path}/app/views/layouts/#{self.layout_name}.html.erb")
  end
end