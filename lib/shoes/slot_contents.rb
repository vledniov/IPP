class Shoes
  class SlotContents
    extend Forwardable

    def_delegators :@contents, :[], :size, :empty?, :first, :each, :clear,
                               :include?, :delete

    def initialize
      @contents         = []
      @prepending       = false
      @prepending_index = 0
    end

    def add_element(element)
      if @prepending
        prepend_element element
      else
        append_element element
      end
    end

    def prepend(&blk)
      @prepending_index = 0
      @prepending = true
      blk.call
      @prepending = false
    end

    def to_ary
      @contents
    end

    def clear
      # reverse_each is important as otherwise we always miss to delete one
      # one element
      @contents.reverse_each do |element|
        element.is_a?(Shoes::Slot) ? element.clear : element.remove
      end
      @contents.clear
    end

    private
    def append_element(element)
      @contents << element
    end

    def prepend_element(element)
      @contents.insert @prepending_index, element
      @prepending_index += 1
    end
  end
end