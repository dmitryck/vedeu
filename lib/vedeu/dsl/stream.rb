module Vedeu

  module DSL

    # Provides methods to be used to define views.
    #
    class Stream

      include Vedeu::DSL
      include Vedeu::DSL::Presentation
      include Vedeu::DSL::Text

      # Returns an instance of Vedeu::DSL::Stream.
      #
      # @param model [Vedeu::Views::Stream]
      # @param client [Object]
      # @return [Vedeu::DSL::Stream]
      def initialize(model, client = nil)
        @model  = model
        @client = client
      end

      # @param block [Proc]
      # @raise [Vedeu::InvalidSyntax] The required block was not given.
      # @return [void]
      def stream(&block)
        fail Vedeu::InvalidSyntax, 'block not given' unless block_given?

        model.add(model.class.build(attributes, &block))
      end

      protected

      # @!attribute [r] client
      # @return [Object]
      attr_reader :client

      # @!attribute [r] model
      # @return [Vedeu::Views::Stream]
      attr_reader :model

      private

      # @return [Hash]
      def attributes
        {
          client: client,
          parent: model.parent,
        }
      end

    end # Stream

  end # DSL

end # Vedeu
