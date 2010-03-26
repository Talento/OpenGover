# coding: iso-8859-1

class Template

  include Mongoid::Document
  include Slug
  field :name
  field :header
  field :content
  field :main, :type => Boolean, :default => false
  field :hidden, :type => Boolean, :default => false

  has_many :blocks
  belongs_to_related :site

  slug :name

  validates_presence_of :name, :content, :site_id
  validates_format_of :content, :with => /\<\%\=.*?yield.*?\%\>/

#  before_create :create_slug
  before_save :parse_content
  before_save :check_main

  def base_path
    Rails.root.to_path
  end

  def layout_name
    "#{self.site_id}_#{self.slug.parameterize}"
  end

  def set_as_main
    self.main = true
    self.save
  end

  def self.main_for_site(site_id)
    Template.where(:main => true, :site_id => site_id).first
  end

  def self.named_for_site(name,site_id)
    Template.where(:name => name, :site_id => site_id).first
  end

  private

  def check_main
    if self.main
      old_main = Template.where(:id.ne => self.id, :site_id => self.site_id, :main => true).first
      if old_main
        old_main.update_attributes(:main => false)
      end
    end
  end

  def parse_content
    get_blocks
    generate_layout
  end

  def get_blocks
    new_blocks = content.scan(/\<\%\=.*?yield(.*?)\%\>/).flatten.collect{|b| b.strip.gsub(":", "") unless b.blank?}.compact
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
        <% for embedded_application in @og_embedded_applications %>
            <% content_for embedded_application.block.name.to_sym do %>
                 <%= render_cell(embedded_application.cell_name.to_sym, embedded_application.cell_state.to_sym, embedded_application.cell_params) %>
            <% end %>
        <% end %>
      }
      f_base = File.open("#{Rails.root.to_path}/app/views/layouts/application.html.erb", "r")
      f_base.each_line do |line|
        file << line.gsub(/\<\%\= *?yield *?\%\>/, self.content)
      end

    end
  end
end