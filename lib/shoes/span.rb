class Shoes
  class Span < Text
    def initialize(texts, options={})
      @opts = options
      super texts
    end

    def opts
      if @parent && @parent.respond_to?(:opts)
        @parent.opts.merge(@opts)
      else
        @opts
      end
    end
  end
end
