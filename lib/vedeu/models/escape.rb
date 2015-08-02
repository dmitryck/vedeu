module Vedeu

  # Represents an invisible escape character sequence.
  #
  class Escape

    # @!attribute [r] value
    # @return [String]
    attr_reader :value

    # Returns a new instance of Vedeu::Escape.
    #
    # @param attributes [String]
    # @option attributes position [Vedeu::Position|Array<Fixnum>]
    # @option attributes value [String]
    # @return [Vedeu::Escape]
    def initialize(attributes = {})
      @attributes = defaults.merge!(attributes)

      @attributes.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    # @return [String]
    def colour
      ''
    end

    # An object is equal when its values are the same.
    #
    # @param other [Vedeu::Views::Char]
    # @return [Boolean]
    def eql?(other)
      self.class == other.class && value == other.value
    end
    alias_method :==, :eql?

    # Override Ruby's Object#inspect method to provide a more helpful output.
    #
    # @return [String]
    def inspect
      "<Vedeu::Escape '#{Vedeu::Esc.escape(to_s)}'>"
    end

    # @return [String]
    def position
      Vedeu::Position.coerce(@position)
    end

    # @return [String]
    def style
      ''
    end

    # @return [String]
    def to_s
      "#{position}#{value}"
    end
    alias_method :to_str, :to_s

    private

    # @return [Hash]
    def defaults
      {
        position: [1, 1],
        value:    '',
      }
    end

  end # Escape

end # Vedeu
