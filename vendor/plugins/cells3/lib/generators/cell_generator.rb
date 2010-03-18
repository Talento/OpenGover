class CellGenerator < Rails::Generators::NamedBase
  argument :actions, :type => :array, :default => [], :banner => "action action"

  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end

  check_class_collision :suffix => "Cell"
  
  def create_cell_files
    template 'cell.rb', File.join( 'app/cells', class_path, "#{file_name}_cell.rb" )
  end

  hook_for :template_engine
end
