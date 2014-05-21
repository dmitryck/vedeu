module Vedeu
  class Esc
    class << self
      def bold
        [esc, '1m'].join
      end

      def clear
        [esc, '2J'].join
      end

      def esc
        [27.chr, '['].join
      end

      def hide_cursor
        [esc, '?25l'].join
      end

      def inverse
        [esc, '7m'].join
      end

      def reset
        [esc, '0m'].join
      end

      def show_cursor
        [esc, '?25h'].join
      end

      def underline
        [esc, '4m'].join
      end
    end
  end
end