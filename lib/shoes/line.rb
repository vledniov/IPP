class Shoes
  class Line
    include CommonMethods
    include Common::Stroke
    include Common::Style
    include Common::Clickable
    include DimensionsDelegations

    attr_reader :app, :point_a, :point_b, :angle, :dimensions, :gui, :parent


    def initialize(app, parent, point_a, point_b, opts = {})
      @app                 = app
      @style               = Shoes::Common::Stroke::DEFAULTS.merge(opts)
      @style[:strokewidth] ||= 1
      @angle               = opts[:angle] || 0
      @point_a             = point_a
      @point_b             = point_b
      @parent              = parent

      enclosing_box_of_line

      gui_opts = @style.clone
      @parent.add_child self

      @gui = Shoes.backend_for(self, gui_opts)

      clickable_options(opts)
    end

    def enclosing_box_of_line
      @dimensions = AbsoluteDimensions.new left:   @point_a.left(@point_b),
                                           top:    @point_a.top(@point_b),
                                           width:  @point_a.width(@point_b),
                                           height: @point_a.height(@point_b)
    end
  end
end
