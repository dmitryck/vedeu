# frozen_string_literal: true

module Vedeu

  module Views

    # A collection of {Vedeu::Views::Line} instances.
    #
    # @api private
    #
    class Lines < Vedeu::Repositories::Collection

      class << self

        include Vedeu::Common

        # @param (see Vedeu::Repositories::Collection#initialize)
        # @macro raise_invalid_syntax
        # @return [Vedeu::Views::Lines]
        def coerce(collection = [], parent = nil, name = nil)
          if collection.is_a?(Vedeu::Views::Lines)
            collection

          elsif collection.is_a?(Vedeu::Views::Streams)
            if collection.empty?
              # @todo Investigate whether this is being used.
            end

          elsif array?(collection)
            return new(collection, parent, name) if collection.empty?

            coerced_collection = []
            collection.each do |element|
              coerced_collection << element if element.is_a?(Vedeu::Views::Line)
            end

            new(coerced_collection, parent, name)

          elsif collection.is_a?(Vedeu::Views::Line)
            new([collection], parent, name)

          else
            raise Vedeu::Error::InvalidSyntax,
                  'Cannot coerce for Vedeu::View::Lines, as collection ' \
                  'unrecognised.'

          end
        end

      end # Eigenclass

      alias lines value

    end # Lines

  end # Views

end # Vedeu
