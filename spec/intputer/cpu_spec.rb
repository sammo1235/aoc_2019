require './lib/intputer/cpu'

RSpec.describe Cpu do
  let(:cpu) { described_class }
  let(:params_off) { { parameter_mode: false, diagnostic_mode: true } }
  let(:params_on) { { parameter_mode: true, diagnostic_mode: true } }

  context 'with parameter mode off' do
    describe '#compute' do
      it 'adds if opcode is 1' do
        expect(cpu.new([1,9,10,3,2,3,11,0,99,30,40,50])
          .compute(params_off))
          .to eq([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])

        expect(cpu.new([1,0,0,0,99])
          .compute(params_off))
          .to eq([2,0,0,0,99])

        expect(cpu.new([1,1,1,4,99,5,6,0,99])
          .compute(params_off))
          .to eq([30,1,1,4,2,5,6,0,99])
      end

      it 'multiplies if opcode is 2' do
        expect(cpu.new([2,3,0,3,99])
          .compute(params_off))
          .to eq([2,3,0,6,99])

        expect(cpu.new([2,4,4,5,99,0])
          .compute(params_off))
          .to eq([2,4,4,5,99,9801])
      end
    end
  end

  context 'with parameter mode on' do
    describe '#compute' do
      it 'adds with parameterised opcode' do
        expect(cpu.new([1101,100,-1,4,0])
          .compute(params_on))
          .to eq([1101,100,-1,4,99])
      end

      it 'multiplies with parameterised opcode' do
        expect(cpu.new([1002,4,3,4,33])
          .compute(params_on))
          .to eq([1002,4,3,4,99])
      end

      it 'accepts new opcodes and correctly computes them' do
        expect(cpu.new([3,5,1101,100,-1,4,99])
          .compute(params_on))
          .to eq([3,99,1101,100,-1,1,99])

        expect(cpu.new([3,0,4,0,99])
          .compute(params_on))
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
        expect(cpu.new([3,9,8,9,10,9,4,9,99,-1,8])
          .compute(params_on))
          .to eq([3,9,8,9,10,9,4,9,99,0,8])
      end

      it '''same as above but opcode 7 checks if index 9 is less
            than index 10''' do
        expect(cpu.new([3,9,7,9,10,9,4,9,99,-1,8])
          .compute(params_on))
          .to eq([3,9,7,9,10,9,4,9,99,1,8])
      end
    end

    describe '#compute with immediate mode' do
      it '''opcode 8 now compares the two immediate params but
            still places them in position mode.
            -1 != 8 so 0 gets placed at index 3''' do
          expect(cpu.new([3,3,1108,-1,8,3,4,3,99]) # input = 1
            .compute(params_on))
            .to eq([3,3,1108,0,8,3,4,3,99])
      end

      it '''7 in immediate mode checks if param 1 is < param 2,
            then places 1 (true) or 0 (false) in pos of param 3''' do
          expect(cpu.new([3,3,1107,-1,8,3,4,3,99]) # input = 1
            .compute(params_on))
            .to eq([3,3,1107,1,8,3,4,3,99])
      end
    end

    describe '#compute with position mode' do
      it 'opcode 6 jumps correctly - outputs 0 if input was 0 or 1 if non-zero' do
        expect(cpu.new([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]) # input = 1
          .compute(parameter_mode: true))
          .to eq(1)
      end

      it 'opcode 5 jumps in immediate mode' do
        expect(cpu.new([3,3,1105,-1,9,1101,0,0,12,4,12,99,1])
          .compute(parameter_mode: true))
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
        expect(cpu.new(
          input,
          7 # quantum input
        )
          .compute(parameter_mode: true))
          .to eq(999)
      end
    end

    describe 'with input value of 8' do
      it 'should output 1000' do
        expect(cpu.new(
          input,
          8
        )
          .compute(parameter_mode: true))
          .to eq(1000)
      end
    end

    describe 'with input value of > 8' do
      it 'should output 1001' do
        expect(cpu.new(
          input,
          11
        )
          .compute(parameter_mode: true))
          .to eq(1001)
      end
    end
  end
end