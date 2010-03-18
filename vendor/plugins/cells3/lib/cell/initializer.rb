module Cell
  # With initializer you can customize cells to use only chosen features.
  # Ie. you may want cells with support to filters and layouts but without
  # Caching.
  #
  # Cell::Initializer.run do |cell|
  #   cell.use_filters = true
  #   cell.use_layouts = true
  #   cell.use_caching = false
  # end
  #
  # TODO: Per cell initializers
  module Initializer 

    class << self
      
      def cells_dir
        File.join( 'app', 'cells' )
      end

      def cells_layouts_dir
        File.join( cells_dir, 'layouts' )
      end

      def run
        yield self
      end

      def use_layouts=(enable)
        use_feature(Cell::Features::Layouts, enable)
      end

      def use_helpers=(enable)
        use_feature(Cell::Features::Helpers, enable)
      end

      def use_filters=(enable)
        use_feature(Cell::Features::Callbacks, enable)
      end

      def use_caching=(enable)
        use_feature(Cell::Features::Caching, enable)
      end

      private
      def use_feature(klass, enable)
        Cell::Base.send(:include, klass) if enable
      end

    end

  end

end
