module Vedeu
  class Process
    class << self
      def main_sequence(interfaces = nil)
        new(interfaces).main_sequence
      end
    end

    def initialize(interfaces = nil)
      @interfaces = interfaces
    end

    def main_sequence
      initial_state

      event_loop
    end

    private

    def event_loop
      interfaces.event_loop
    end

    def initial_state
      interfaces.initial_state
    end

    def interfaces
      @interfaces ||= Interfaces.default
    end
  end
end