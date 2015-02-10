require 'test_helper'

module Vedeu

  describe Terminal do

    let(:described) { Vedeu::Terminal }

    let(:console) { IO.console }

    before do
      IO.console.stubs(:winsize).returns([25, 80])
      IO.console.stubs(:print)
    end

    describe '.open' do
      context 'when a block was not given' do
        it { proc { Terminal.open }.must_raise(InvalidSyntax) }
      end

      it 'opens a new terminal console in raw mode' do
        Configuration.stub(:terminal_mode, :raw) do
          capture_io do
            Terminal.open do
              print "Hello from raw mode!"
            end
          end.must_equal(['Hello from raw mode!', ''])
        end
      end

      it 'opens a new terminal console in cooked mode' do
        Configuration.stub(:terminal_mode, :cooked) do
          capture_io do
            Terminal.open do
              print "Hello from cooked mode!"
            end
          end.must_equal(['Hello from cooked mode!', ''])
        end
      end
    end

    describe '.input' do
      context 'when the terminal is in cooked mode' do
        let(:mode)  { :cooked }
        let(:input) { "Some input\r\n" }

        before do
          Terminal.stubs(:mode).returns(mode)
          IO.console.stubs(:gets).returns(input)
        end

        subject { Terminal.input }

        it { subject.must_equal('Some input') }
      end

      context 'when the terminal is in raw mode' do
        let(:mode)  { :raw }
        let(:input) { "\e" }

        before do
          Terminal.stubs(:mode).returns(mode)
          IO.console.stubs(:getch).returns(input)
          input.stubs(:ord).returns(27)
          IO.console.stubs(:read_nonblock)
        end

        subject { Terminal.input }

        it { subject.must_be_instance_of(String) }
      end
    end

    describe '.output' do
      subject { described.output(*value) }

      context 'when the value is a String' do
        let(:value) { 'Some output...' }

        it { subject.must_equal(['Some output...']) }
      end
      context 'when there are multiple values' do
        let(:value) { ['Some output...', 'more output...', 'even more...'] }

        it { subject.must_equal(['Some output...', 'more output...', 'even more...']) }
      end
    end

    describe '.resize' do
      before { Vedeu.interfaces.reset }

      subject { Terminal.resize }

      it { subject.must_be_instance_of(TrueClass) }
    end

    describe '.clear' do
      subject { Terminal.clear }

      it 'clears the screen' do
        subject.must_equal(["\e[38;2;39m\e[48;2;49m\e[2J"])
      end
    end

    describe '.set_cursor_mode' do
      it 'shows the cursor in cooked mode' do
        Terminal.cooked_mode!
        Terminal.set_cursor_mode.must_equal(["\e[?25h"])
      end

      it 'hides the cursor in raw mode' do
        Terminal.raw_mode!
        Terminal.set_cursor_mode.must_equal(nil)
      end
    end

    describe '.raw_mode?' do
      it 'returns true if the terminal is in raw mode' do
        Terminal.raw_mode!
        Terminal.raw_mode?.must_equal(true)
      end

      it 'returns false if the terminal is not in raw mode' do
        Terminal.cooked_mode!
        Terminal.raw_mode?.must_equal(false)
      end
    end

    describe '.cooked_mode?' do
      it 'returns true if the terminal is in cooked mode' do
        Terminal.cooked_mode!
        Terminal.cooked_mode?.must_equal(true)
      end

      it 'returns false if the terminal is not in cooked mode' do
        Terminal.raw_mode!
        Terminal.cooked_mode?.must_equal(false)
      end
    end

    describe '.switch_mode!' do
      it 'returns a Symbol' do
        Terminal.switch_mode!.must_be_instance_of(Symbol)
      end

      it 'returns :cooked if previously :raw' do
        Terminal.raw_mode!
        Terminal.switch_mode!.must_equal(:cooked)
      end

      it 'returns :raw if previously :cooked' do
        Terminal.cooked_mode!
        Terminal.switch_mode!.must_equal(:raw)
      end
    end

    describe '.mode' do
      before do
        Configuration.stubs(:terminal_mode).returns(:raw)
        Terminal.switch_mode! if Terminal.mode == :cooked
      end

      it 'returns the configured terminal mode' do
        Terminal.mode.must_be_instance_of(Symbol)
        Terminal.mode.must_equal(:raw)
      end
    end

    describe '.centre' do
      it 'returns the centre point on the terminal' do
        Terminal.centre.must_be_instance_of(Array)
        Terminal.centre.must_equal([12, 40])
      end
    end

    describe '.centre_y' do
      it 'returns the centre `y` point on the terminal' do
        Terminal.centre_y.must_be_instance_of(Fixnum)
        Terminal.centre_y.must_equal(12)
      end
    end

    describe '.centre_x' do
      it 'returns the centre `x` point on the terminal' do
        Terminal.centre_x.must_be_instance_of(Fixnum)
        Terminal.centre_x.must_equal(40)
      end
    end

    describe '.origin' do
      it 'returns 1' do
        Terminal.origin.must_be_instance_of(Fixnum)
        Terminal.origin.must_equal(1)
      end

      context 'alias_methods' do
        it 'returns 1' do
          Terminal.x.must_equal(1)
        end

        it 'returns 1' do
          Terminal.y.must_equal(1)
        end
      end
    end

    describe '.width' do
      context 'via method' do
        it 'returns the width of the terminal' do
          Terminal.width.must_be_instance_of(Fixnum)
          Terminal.width.must_equal(80)
        end
      end

      context 'via API' do
        it 'returns the width of the terminal' do
          Vedeu.width.must_equal(80)
        end
      end

      context 'alias_methods' do
        it 'returns the xn coordinate of the terminal' do
          Terminal.xn.must_equal(80)
        end
      end
    end

    describe '.height' do
      context 'via method' do
        it 'returns the height of the terminal' do
          Terminal.height.must_be_instance_of(Fixnum)
          Terminal.height.must_equal(25)
        end
      end

      context 'via API' do
        it 'returns the height of the terminal' do
          Vedeu.height.must_equal(25)
        end
      end

      context 'alias_methods' do
        it 'returns the yn coordinate of the terminal' do
          Terminal.yn.must_equal(25)
        end
      end
    end

    describe '.size' do
      it 'returns the width and height of the terminal' do
        Terminal.size.must_be_instance_of(Array)
        Terminal.size.must_equal([25, 80])
      end
    end

    describe '.console' do
      it 'returns the console' do
        Terminal.console.must_equal(console)
      end
    end

  end # Terminal

end # Vedeu
