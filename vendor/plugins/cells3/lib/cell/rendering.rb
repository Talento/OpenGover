module Cell
  module Rendering
    extend ActiveSupport::Concern

    include AbstractController::Rendering
    included do
      # We should use respond_to instead of that
      class_inheritable_accessor :default_template_format
      self.default_template_format = :html
    end

    module InstanceMethods

      # Render the given state.  You can pass the name as either a symbol or
      # a string.
      def render_state(state)
        ### DISCUSS: are these vars really needed in state views?
        @cell       = self
        @state_name = state

        output = process(state)
        if output.is_a?(String)
          self.response_body = output
        elsif output.nil?
          self.response_body = render.chomp #TODO: why \n is appended?
        else
          raise CellError.new( "#{cell_name}/#{state} must call explicit render" )
        end
      end

      # Render the view for the current state. Usually called at the end of a state method.
      #
      # ==== Cells-specific Options
      # * <tt>:view</tt> - Specifies the name of the view file to render. Defaults to the current state name.
      # * <tt>:template_format</tt> - Allows using a format different to <tt>:html</tt>.
      # * <tt>:layout</tt> - If set to a valid filename inside your cell's view_paths, the current state view will be rendered inside the layout (as known from controller actions). Layouts should reside in <tt>app/cells/layouts</tt>.
      #
      # Example:
      #  class MyCell < Cell::Base
      #    def my_first_state
      #      # ... do something
      #      render 
      #    end
      #
      # will just render the view <tt>my_first_state.html</tt>.
      # 
      #    def my_first_state
      #      # ... do something
      #      render :view => :my_first_state, :layout => "metal"
      #    end
      #
      # will also use the view <tt>my_first_state.html.erb</tt> as template and even put it in the layout
      # <tt>metal</tt> that's located at <tt>$RAILS_ROOT/app/cells/layouts/metal.html.erb</tt>.
      #
      # === Render options
      # You can use usual render options as weel
      #
      # Example:
      #   render :view => 'foo'
      #   render :state => 'bar'
      #   render :text => 'Hello Cells'
      #   render :inline => 'Welcome <%= @text %>'
      #   render :file => 'another_cell/foo'
      #
      def render(options = {})
        normalize_render_options(options)
        render_to_body(options)
      end

      # Normalize the passed options from #render.
      def normalize_render_options(options, prefix_lookup = true)
        options[:formats] ||= Array(options.delete(:template_format) || self.class.default_template_format)
        if (options.keys & [:file, :text, :inline, :nothing, :template]).empty?
          determine_view_path(options, prefix_lookup) 
        end
        options
      end

      def determine_view_path(options, prefix_lookup = true)
        if options.has_key?(:partial)
          wanted_path = options[:partial]
          prefix_lookup = false if wanted_path =~ %r{/}
          partial = true
        else
          wanted_path = options.delete(:view) || options.delete(:state) || state_name
          options[:template] = wanted_path
        end
        options[:_prefix] = find_template_prefix(wanted_path, options, partial) if prefix_lookup
      end

      # overridden to use Cell::View instead of ActionView::Base
      def view_context
        @_view_context ||= Cell::View.for_controller(self)
      end

      # Climbs up the inheritance hierarchy of the Cell, looking for a view 
      # for the current <tt>state</tt> in each level.
      def find_template_prefix(state, details, partial = false)
        returning inheritance_path.detect { |path| view_paths.exists?( state.to_s, details, path, partial ) } do |path|
          raise ::ActionView::MissingTemplate.new(view_paths, state.to_s) unless path
        end
      end

      # Defines the instance variables that should <em>not</em> be copied to the 
      # View instance.
      def protected_instance_variables  
        ['@parent_controller'] 
      end

    end

  end
end
