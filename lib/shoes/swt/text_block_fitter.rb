class Shoes
  module Swt
    class TextBlockFitter
      attr_reader :parent

      def initialize(text_block, current_position)
        @text_block = text_block
        @dsl = @text_block.dsl
        @parent = @dsl.parent
        @current_position = current_position
      end

      # Fitting text works by using either 1 or 2 layouts
      #
      # If the text fits in the height and width available, we use one layout.
      #
      # --------------------------
      # | button | text layout 1 |
      # --------------------------
      #
      # If if the text doesn't fit into that space, then we'll break it into
      # two different layouts.
      #
      # --------------------------
      # | button | text layout 1 |
      # --------------------------
      # | text layout 2 goes here|
      # | in space               |
      # --------------------------
      #           ^
      #
      # When flowing, the position for the next element gets set to the end of
      # the text in the second layout (shown as ^ in the diagram).
      #
      # Stacks properly move to the next whole line as you'd expect.
      #
      def fit_it_in
        width, height = available_space
        layout = generate_layout(width, @dsl.text)

        if fits_in_one_layout?(layout, height)
          fit_as_one_layout(layout)
        else
          fit_as_two_layouts(layout, height, width)
        end
      end

      def fits_in_one_layout?(layout, height)
        return true if height == :unbounded || layout.line_count == 1
        layout.get_bounds.height <= height
      end

      def fit_as_one_layout(layout)
        [FittedTextLayout.new(layout,
                              @dsl.absolute_left + @dsl.margin_left,
                              @dsl.absolute_top + @dsl.margin_top)]
      end

      def fit_as_two_layouts(layout, height, width)
        first_text, second_text = split_text(layout, height)
        first_layout = generate_layout(width, first_text)

        return fit_as_one_layout(first_layout) if second_text.empty?

        first_height = first_height(first_layout, first_text, height)
        second_layout = generate_second_layout(second_text)

        [
          FittedTextLayout.new(first_layout,
                               @dsl.absolute_left + @dsl.margin_left,
                               @dsl.absolute_top + @dsl.margin_top),
          FittedTextLayout.new(second_layout,
                                parent.absolute_left + @dsl.margin_left,
                                @dsl.absolute_top + @dsl.margin_top + first_height)
        ]
      end

      def generate_second_layout(second_text)
        second_layout = generate_layout(@dsl.containing_width, second_text)
      end

      def available_space
        width = @dsl.desired_width
        height = next_line_start - @dsl.absolute_top - 1
        height = :unbounded if on_new_line?
        [width, height]
      end

      def next_line_start
        @current_position.next_line_start
      end

      def on_new_line?
        next_line_start <= @dsl.absolute_top
      end

      def generate_layout(width, text)
        @text_block.generate_layout(width, text)
      end

      def split_text(layout, height)
        ending_offset = 0
        height_so_far = 0

        offsets = layout.line_offsets
        offsets[0...-1].each_with_index do |_, i|
          height_so_far += layout.line_metrics(i).height
          break if height_so_far > height

          ending_offset = offsets[i+1]
        end
        [layout.text[0...ending_offset], layout.text[ending_offset..-1]]
      end

      # If first text is empty, height may be smaller than an actual line in
      # the current font. Take our pre-existing allowed height instead.
      def first_height(first_layout, first_text, height)
        first_height = first_layout.get_bounds.height
        first_height = height if first_text.empty?
        first_height
      end
    end

    class FittedTextLayout
      attr_reader :layout, :left, :top

      def initialize(layout, left, top)
        @layout = layout
        @left = left
        @top = top
      end

      def get_location(cursor)
        @layout.get_location(cursor, false)
      end

      def text
        @layout.text
      end

      def draw(graphics_context)
        layout.draw(graphics_context, left, top)
      end
    end
  end
end
