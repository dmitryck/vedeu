require 'test_helper'

module Vedeu

  NastyException = Class.new(StandardError)

  describe Trigger do

    let(:described) { Vedeu::Trigger }

    describe '#trigger' do
      let(:event_name) { :_testing_event_ }

      before { Vedeu.event(:_nasty_exception_) { fail NastyException } }
      # after  { Vedeu.unevent(:_nasty_exception_) }

      subject { described.trigger(event_name) }

      it 'returns the result of triggering the event' do
        proc { described.trigger(:_nasty_exception_) }.must_raise(NastyException)
      end

      it 'returns an empty collection when the event has not been registered' do
        described.trigger(:_not_found_).must_be_empty
      end
    end

  end # Trigger

end # Vedeu
