module Vedeu
  class JSONParser
    class << self
      def parse(json = '')
        new(json).parse
      end
    end

    def initialize(json = '')
      @json = json || ''
    end

    def parse
      Buffer::Composition.new(as_hash)
    end

    private

    attr_reader :json

    def as_hash
      Oj.load(json)
    end
  end
end