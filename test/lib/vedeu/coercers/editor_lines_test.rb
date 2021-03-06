# frozen_string_literal: true

require 'test_helper'

module Vedeu

  module Coercers

    describe EditorLines do

      let(:described) { Vedeu::Coercers::EditorLines }
      let(:instance)  { described.new(_value) }
      let(:_value)    {}
      let(:klass)     { Vedeu::Editor::Lines }

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
        it { instance.instance_variable_get('@value').must_equal(_value) }
      end

      describe '.coerce' do
        it { described.must_respond_to(:coerce) }
      end

      describe '#coerce' do
        subject { instance.coerce }

        context 'when the value is already the target class' do
          let(:_value) { klass.new }

          it { subject.must_be_instance_of(klass) }
          it { subject.must_equal(_value) }
        end

        context 'when the value is an Array' do
          context 'when the value is empty' do
            let(:_value) { [] }

            it { subject.collection.must_equal([]) }
          end

          context 'when the value is not empty' do
            let(:_value) {
              [
                Vedeu::Editor::Line.new('Some text...'),
                :more_text,
                'Other text...',
              ]
            }
            let(:expected) {
              [
                Vedeu::Editor::Line.new('Some text...'),
                Vedeu::Editor::Line.new(''),
                Vedeu::Editor::Line.new('Other text...'),
              ]
            }

            it { subject.collection.must_equal(expected) }
          end
        end

        context 'when the value is a String' do
          let(:_value) { "Some text...\nMore text..." }

          context 'but it is empty' do
            let(:_value) { '' }

            it { subject.must_equal(Vedeu::Editor::Lines.new) }
          end

          context 'but it has no line breaks' do
            # @todo Add more tests.
          end
        end
      end

    end # EditorLines

  end # Coercers

end # Vedeu
