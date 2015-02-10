module Vedeu

  module DSL

    # DSL for creating collections of interfaces.
    #
    class Composition

      include Vedeu::DSL

      # Returns an instance of DSL::Composition.
      #
      # @param model [Composition]
      def initialize(model, client = nil)
        @model  = model
        @client = client
      end

      # Define a view.
      #
      # A view is just an Interface object.
      #
      # @todo More documentation required.
      # @param name [String] The name of the interface you are targetting for
      #   this view.
      # @param block [Proc] The directives you wish to send to this interface.
      #
      # @example
      #   view 'my_interface' do
      #     ...
      #
      # @raise [InvalidSyntax] The required block was not given.
      # @return [Vedeu::Model::Collection<Vedeu::Interface>]
      def view(name = '', &block)
        fail InvalidSyntax, 'block not given' unless block_given?

        child_model = if Vedeu.interfaces.registered?(name)
          interface = Vedeu.interfaces.find(name)
          child.build(attributes.merge(interface.attributes), &block)

        else
          child.build(attributes.merge({ name: name }), &block)

        end

        model.add(child_model)
      end

      private

      attr_reader :client, :model

      # @return [Hash]
      def attributes
        {
          client: client,
          parent: model,
        }
      end

      # Return the class name for the children on this model.
      #
      # @return [Class]
      def child
        Vedeu::Interface
      end

    end # Composition

  end # DSL

end # Vedeu
