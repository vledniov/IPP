class Shoes
  module Swt
    class TextBlockCursorPainter
      def initialize(dsl, fitted_layouts)
        @dsl = dsl
        @fitted_layouts = fitted_layouts
      end

      def draw
        if @dsl.cursor
          draw_textcursor
        else
          remove_textcursor
        end
      end

      def draw_textcursor
        layout = choose_layout
        x, y = new_position(layout)

        # It's important to only move when necessary to avoid constant redraws
        unless textcursor.left == x && textcursor.top == y
          move_textcursor(x, y)
        end
      end

      def new_position(layout)
        position = layout.get_location(relative_cursor)
        [layout.left + position.x, layout.top + position.y]
      end

      def move_textcursor(x, y)
        textcursor.move(x, y)
        textcursor.show
      end

      def first_layout
        @fitted_layouts.first
      end

      def last_layout
        @fitted_layouts.last
      end

      # Only works with one or two layouts, but that's what we've got
      # -1 positions us at the very end, regardless text length
      def choose_layout
        if cursor_fits_in_first_layout?
          first_layout
        else
          last_layout
        end
      end

      # Again, assumes one or two layout system
      def relative_cursor
        if cursor_at_end?
          relative_cursor_at_end
        elsif cursor_fits_in_first_layout?
          relative_cursor_in_first_layout
        else
          relative_cursor_in_last_layout
        end
      end

      def cursor_fits_in_first_layout?
        @dsl.cursor <= first_layout.text.length && @dsl.cursor >= 0
      end

      def cursor_at_end?
        cursor_negative? || cursor_past_all_text?
      end

      def cursor_negative?
        @dsl.cursor < 0
      end

      def cursor_past_all_text?
        @dsl.cursor > @dsl.text.length
      end

      def relative_cursor_at_end
        last_layout.text.length
      end

      def relative_cursor_in_first_layout
        @dsl.cursor
      end

      def relative_cursor_in_last_layout
        @dsl.cursor - first_layout.text.length
      end

      def textcursor
        @dsl.textcursor cursor_height
      end

      # This could be smarter, basing height on the actual line the cursor's
      # in. For now, just use the first line's height.
      def cursor_height
        first_layout.layout.get_line_bounds(0).height
      end

      def remove_textcursor
        return unless @dsl.has_textcursor?

        @dsl.textcursor.remove
        @dsl.textcursor = nil
      end
    end
  end
end
