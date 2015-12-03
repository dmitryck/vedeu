module Vedeu

  module Cells

    # Provides the character/escape sequence to draw one cell of a
    # with a custom value, colour and style.
    #
    # The Vedeu::Cells::Char object represents an alpha-numeric
    # character.
    #
    # @api private
    #
    class Char < Vedeu::Cells::Empty

      # @return [Boolean]
      def cell?
        false
      end

    end # Char

  end # Cells

end # Vedeu
