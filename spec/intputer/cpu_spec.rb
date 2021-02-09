require './lib/intputer/cpu'

RSpec.describe Cpu do
  context 'with malformed input' do
    describe '#initialize' do
      it 'raises an ArgumentError' do
        expect { Cpu.new(70909) }
        .to raise_error(ArgumentError, "Program must be of type Array but is an Integer")
      end
    end

    describe '#compute' do
      it 'raises InvalidOpcodeException with invalid program' do
        expect { Cpu.new([1, 2, 3, 0, 0, 8, 99, 0]).compute }
        .to raise_error(InvalidOpcodeException, "0 is not a valid opcode")

        expect { Cpu.new([3111, 2, 3, 5, 0, 8, 99, 0]).compute }
        .to raise_error(InvalidOpcodeException, "3111 is not a valid opcode")

        expect { Cpu.new([30001, 2, 3, 0, 5, 8, 99, 0]).compute }
        .to raise_error(InvalidOpcodeException, "Invalid opcode parameter 3")

        expect { Cpu.new([301, 2, 3, 0, 5, 8, 99, 0]).compute }
        .to raise_error(InvalidOpcodeException, "301 is not a valid opcode")

        expect { Cpu.new([40101, 2, 3, 0, 5, 8, 99, 0]).compute }
        .to raise_error(InvalidOpcodeException, "Invalid opcode parameter 4")
      end
    end

    describe '#compute' do
      it 'raises InvalidPositionException if positional params are OOB' do
        expect { Cpu.new([1, -38, 23, 0, 3, 1, 99, 0]).compute }
        .to raise_error(InvalidPositionException, "Invalid program position: -38 with opcode: 1")
      end

      it 'raises InvalidPositionException if positional params are OOB' do
        expect { Cpu.new([2, -23, 56, 0, 3, 1, 99, 0]).compute }
        .to raise_error(InvalidPositionException, "Invalid program position: -23 with opcode: 2")
      end
    end
  end


  context 'with other incorrect parameters' do
    describe '#initialize' do
      it 'should raise an ArgumentError with int as diagnostic flag' do
        expect { Cpu.new([1, 2, 3], 1, true) }
        .to raise_error(ArgumentError, 'Diagnostic flag must be a boolean')
      end

      it 'should raise an ArgumentError with quantum fluctuating input not an int' do
        expect { Cpu.new([1, 2, 3], true, "I shouldn't be here") }
        .to raise_error(ArgumentError, 'quantum_fluctuating_input must be an Integer')
      end

      it 'should raise an ArgumentError with phase setting not an int' do
        expect { Cpu.new([1, 2, 3], true, 1, "blah") }
        .to raise_error(ArgumentError, 'phase_setting must be an Integer')
      end
    end
  end

  context 'with memory pointer out of bounds of input' do
    describe '#compute' do
      it 'raises an PointerOutOfBoundsException' do
        expect {
          Cpu.new([1,9,10,3,2,3,11,0,99,30,40,50], true, 1).tap do |cpu|
            cpu.ind = -50
            cpu.compute
          end
        }.to raise_error(
          PointerOutOfBoundsException,
          "-50 is not within program opcode bounds"
        )
      end
    end
  end

  context 'with regular opcodes (no parameters)' do
    describe '#compute' do
      it 'adds if opcode is 1' do
        expect(Cpu.new([1,9,10,3,2,3,11,0,99,30,40,50], true, 1).compute)
          .to eq([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])

        expect(Cpu.new([1,0,0,0,99], true, 1).compute)
          .to eq([2,0,0,0,99])

        expect(Cpu.new([1,1,1,4,99,5,6,0,99], true).compute)
          .to eq([30,1,1,4,2,5,6,0,99])
      end

      it 'multiplies if opcode is 2' do
        expect(Cpu.new([2,3,0,3,99], true).compute)
          .to eq([2,3,0,6,99])

        expect(Cpu.new([2,4,4,5,99,0], true).compute)
          .to eq([2,4,4,5,99,9801])
      end
    end
  end

  context 'with parameter mode on' do
    describe '#compute' do
      it 'adds with parameterised opcode' do
        expect(Cpu.new([1101,100,-1,4,0], true).compute)
          .to eq([1101,100,-1,4,99])
      end

      it 'multiplies with parameterised opcode' do
        expect(Cpu.new([1002,4,3,4,33], true).compute)
          .to eq([1002,4,3,4,99])
      end

      it 'accepts new opcodes and correctly computes them' do
        expect(Cpu.new([3,5,1101,100,-1,4,99], true).compute)
          .to eq([3,99,1101,100,-1,1,99])

        expect(Cpu.new([3,0,4,0,99], true).compute)
          .to eq([1,0,4,0,99])
      end
    end
  end

  context 'with D5P2 new opcodes' do
    describe '#compute with position mode' do
      it '''if input (opcode 3 takes input and places at 9) is 1,
            opcode 8 should compare 1 and 8 in indices 9 and 10.
            If they are equal a 1 gets placed at store position (9).
            1 != 8 so 0 gets placed at index 9''' do
        expect(Cpu.new([3,9,8,9,10,9,4,9,99,-1,8], true).compute)
          .to eq([3,9,8,9,10,9,4,9,99,0,8])
      end

      it '''same as above but opcode 7 checks if index 9 is less
            than index 10''' do
        expect(Cpu.new([3,9,7,9,10,9,4,9,99,-1,8], true).compute)
          .to eq([3,9,7,9,10,9,4,9,99,1,8])
      end
    end

    describe '#compute with immediate mode' do
      it '''opcode 8 now compares the two immediate params but
            still places them in position mode.
            -1 != 8 so 0 gets placed at index 3''' do
          expect(Cpu.new([3,3,1108,-1,8,3,4,3,99], true).compute)
            .to eq([3,3,1108,0,8,3,4,3,99])
      end

      it '''7 in immediate mode checks if param 1 is < param 2,
            then places 1 (true) or 0 (false) in pos of param 3''' do
          expect(Cpu.new([3,3,1107,-1,8,3,4,3,99], true).compute)
            .to eq([3,3,1107,1,8,3,4,3,99])
      end
    end

    describe '#compute with position mode' do
      it 'opcode 6 jumps correctly - outputs 0 if input was 0 or 1 if non-zero' do
        expect(Cpu.new([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]).compute)
          .to eq(1)
      end

      it 'opcode 5 jumps in immediate mode' do
        expect(Cpu.new([3,3,1105,-1,9,1101,0,0,12,4,12,99,1]).compute)
          .to eq(1)
      end
    end
  end

  context 'with larger input' do
    let(:input) { [
      3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
      1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
      999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    ] }

    describe 'with input value below 8' do
      it 'should output 999' do
        expect(Cpu.new(input, false, 7).compute).to eq(999)
      end
    end

    describe 'with input value of 8' do
      it 'should output 1000' do
        expect(Cpu.new(input, false, 8).compute).to eq(1000)
      end
    end

    describe 'with input value of > 8' do
      it 'should output 1001' do
        expect(Cpu.new(input, false, 11).compute).to eq(1001)
      end
    end
  end

  context 'with relative base' do
    describe 'it handles opcode 9, which will add the one parameter to opcode 9
              (in position, immediate or relative mode) to the relative base' do
      it 'handles opcode 9' do
        expect(Cpu.new([109, -1, 104, 1, 99]).compute).to eq(1)
        expect(Cpu.new([109, -1, 204, 1, 99]).compute).to eq(109)
        expect(Cpu.new([109, 1, 9, 2, 204, -6, 99]).compute).to eq(204)
        expect(Cpu.new([109, 1, 109, 9, 204, -6, 99]).compute).to eq(204)
        expect(Cpu.new([109, 1, 209, -1, 204, -106, 99]).compute).to eq(204)
        expect(Cpu.new([109, 1, 3, 3, 204, 2, 99], false, 6).compute).to eq(6)
        expect(Cpu.new([109, 1, 203, 2, 204, 2, 99], false, 7).compute).to eq(7)
      end
    end
  end
end