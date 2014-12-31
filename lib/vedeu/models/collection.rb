module Vedeu

  module Model

    attr_reader :repository

    # @return [void] The model instance stored in the repository.
    def store
      repository.store(self)
    end

    class Collection

      include Enumerable

      attr_reader :parent

      def initialize(parent, collection = [])
        @parent     = parent
        @collection = collection || []
      end

      def add(*other)
        Collection.new(parent, @collection += other)
      end

      def all
        @collection
      end

      def each(&block)
        @collection.each do |element|
          if block_given?
            block.call(element)

          else
            yield element

          end
        end
      end

      def empty?
        @collection.empty?
      end

      def size
        @collection.size
      end

      def to_s
        @collection.map(&:to_s).join
      end

    end # Collection

    Interfaces = Class.new(Collection)
    Lines      = Class.new(Collection)
    Streams    = Class.new(Collection)

  end # Model

end # Vedeu
