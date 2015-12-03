require 'test_helper'

module Vedeu

  module Geometries

    describe Area do

      let(:described) { Vedeu::Geometries::Area }
      let(:instance)  { described.new(name: _name, y: y, yn: yn, x: x, xn: xn) }
      let(:_name)     { 'Vedeu::Geometries::Area' }
      let(:y)         { 4 }
      let(:yn)        { 9 }
      let(:x)         { 6 }
      let(:xn)        { 21 }
      let(:offset)    { 1 }

      let(:border_attributes) {
        {
          bottom_left:  'C',
          bottom_right: 'D',
          enabled:      enabled,
          horizontal:   'H',
          name:         _name,
          show_top:     top,
          show_bottom:  bottom,
          show_left:    left,
          show_right:   right,
          top_left:     'A',
          top_right:    'B',
          vertical:     'V'
        }
      }
      let(:enabled) { false }
      let(:top)     { false }
      let(:bottom)  { false }
      let(:left)    { false }
      let(:right)   { false }
      let(:border)  { Vedeu::Borders::Border.new(border_attributes) }
      let(:border_attributes) {
        {
          enabled: enabled
        }
      }

      before do
        Vedeu.borders.stubs(:by_name).returns(border)
      end

      describe 'accessors' do
        it do
          instance.must_respond_to(:y)
          instance.must_respond_to(:yn)
          instance.must_respond_to(:x)
          instance.must_respond_to(:xn)
          instance.must_respond_to(:top)
          instance.must_respond_to(:bottom)
          instance.must_respond_to(:left)
          instance.must_respond_to(:right)
        end
      end

      describe '#initialize' do
        it { instance.must_be_instance_of(described) }
        it { instance.instance_variable_get('@name').must_equal(_name) }
        it { instance.instance_variable_get('@y').must_equal(y) }
        it { instance.instance_variable_get('@yn').must_equal(yn) }
        it { instance.instance_variable_get('@x').must_equal(x) }
        it { instance.instance_variable_get('@xn').must_equal(xn) }
      end

      describe '.from_attributes' do
        let(:attributes) {
          {
            y:                    y,
            yn:                   yn,
            y_yn:                 y_yn,
            y_default:            y_default,
            x:                    x,
            xn:                   xn,
            x_xn:                 x_xn,
            x_default:            x_default,
            maximised:            maximised,
            name:                 _name,
            horizontal_alignment: horizontal_alignment,
            vertical_alignment:   vertical_alignment,
          }
        }
        let(:y)                    {}
        let(:yn)                   {}
        let(:y_yn)                 {}
        let(:y_default)            {}
        let(:x)                    {}
        let(:xn)                   {}
        let(:x_xn)                 {}
        let(:x_default)            {}
        let(:maximised)            {}
        let(:horizontal_alignment) {}
        let(:vertical_alignment)   {}

        subject { described.from_attributes(attributes) }

        it { subject.must_be_instance_of(described) }
      end

      describe '#bordered_width' do
        subject { instance.bordered_width }

        context 'when the border is not enabled' do
          let(:enabled) { false }

          it 'returns the interface width' do
            subject.must_equal(16)
          end
        end

        context 'when the border is enabled' do
          context 'when both left and right borders are shown' do
            let(:border_attributes) {
              {
                enabled: true,
                name:    _name,
              }
            }

            it { subject.must_equal(14) }
          end

          context 'when either the left or right border is shown' do
            let(:border_attributes) {
              {
                enabled:   true,
                name:      _name,
                show_left: false
              }
            }

            it { subject.must_equal(15) }
          end

          context 'when neither left nor right borders are shown' do
            let(:border_attributes) {
              {
                enabled:    true,
                name:       _name,
                show_left:  false,
                show_right: false
              }
            }

            it { subject.must_equal(16) }
          end
        end
      end

      describe '#bordered_height' do
        subject { instance.bordered_height }

        context 'when the border is not enabled' do
          it 'returns the interface height' do
            subject.must_equal(6)
          end
        end

        context 'when the border is enabled' do
          context 'when both top and bottom borders are shown' do
            let(:border_attributes) {
              {
                enabled: true,
                name:    _name,
              }
            }

            it { subject.must_equal(4) }
          end

          context 'when either the top or bottom border is shown' do
            let(:border_attributes) {
              {
                enabled:  true,
                name:     _name,
                show_top: false
              }
            }

            it { subject.must_equal(5) }
          end

          context 'when neither top nor bottom borders are shown' do
            let(:border_attributes) {
              {
                enabled:     true,
                name:        _name,
                show_top:    false,
                show_bottom: false
              }
            }

            it { subject.must_equal(6) }
          end
        end
      end

      describe '#bx' do
        subject { instance.bx }

        context 'when enabled' do
          let(:enabled) { true }
          let(:left) { true }

          it { subject.must_equal(7) }
        end

        context 'when not enabled or without left' do
          it { subject.must_equal(6) }
        end
      end

      describe '#bxn' do
        subject { instance.bxn }

        context 'when enabled' do
          let(:enabled) { true }
          let(:right) { true }

          it { subject.must_equal(20) }
        end

        context 'when not enabled or without right' do
          it { subject.must_equal(21) }
        end
      end

      describe '#by' do
        subject { instance.by }

        context 'when enabled' do
          let(:enabled) { true }
          let(:top) { true }

          it { subject.must_equal(5) }
        end

        context 'when not enabled or without top' do
          it { subject.must_equal(4) }
        end
      end

      describe '#byn' do
        subject { instance.byn }

        context 'when enabled' do
          let(:enabled) { true }
          let(:bottom) { true }

          it { subject.must_equal(8) }
        end

        context 'when not enabled or without bottom' do
          it { subject.must_equal(9) }
        end
      end

      describe '#eql?' do
        let(:other) { described.new(name: _name, y: 4, yn: 9, x: 6, xn: 21) }

        subject { instance.eql?(other) }

        it { subject.must_equal(true) }

        context 'when different to other' do
          let(:other) { described.new(name: _name, y: 1, yn: 25, x: 1, xn: 40) }

          it { subject.must_equal(false) }
        end
      end

      describe '#centre' do
        subject { instance.centre }

        it { subject.must_be_instance_of(Array) }
        it { subject.must_equal([7, 14]) }
      end

      describe '#centre_y' do
        subject { instance.centre_y }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(7) }
      end

      describe '#centre_x' do
        subject { instance.centre_x }

        it { subject.must_be_instance_of(Fixnum) }
        it { subject.must_equal(14) }
      end

      describe '#north' do
        subject { instance.north(offset) }

        it { subject.must_be_instance_of(Fixnum) }

        context 'with the default offset' do
          it { subject.must_equal(3) }
        end

        context 'with a negative offset' do
          let(:offset) { -2 }

          it { subject.must_equal(6) }
        end

        context 'with a positive offset' do
          let(:offset) { 2 }

          it { subject.must_equal(2) }
        end
      end

      describe '#east' do
        subject { instance.east(offset) }

        it { subject.must_be_instance_of(Fixnum) }

        context 'with the default offset' do
          it { subject.must_equal(22) }
        end

        context 'with a negative offset' do
          let(:offset) { -2 }

          it { subject.must_equal(19) }
        end

        context 'with a positive offset' do
          let(:offset) { 2 }

          it { subject.must_equal(23) }
        end
      end

      describe '#south' do
        subject { instance.south(offset) }

        it { subject.must_be_instance_of(Fixnum) }

        context 'with the default offset' do
          it { subject.must_equal(10) }
        end

        context 'with a negative offset' do
          let(:offset) { -2 }

          it { subject.must_equal(7) }
        end

        context 'with a positive offset' do
          let(:offset) { 2 }

          it { subject.must_equal(11) }
        end
      end

      describe '#west' do
        subject { instance.west(offset) }

        it { subject.must_be_instance_of(Fixnum) }

        context 'with the default offset' do
          it { subject.must_equal(5) }
        end

        context 'with a negative offset' do
          let(:offset) { -2 }

          it { subject.must_equal(8) }
        end

        context 'with a positive offset' do
          let(:offset) { 2 }

          it { subject.must_equal(4) }
        end
      end

    end # Area

  end # Geometries

end # Vedeu
