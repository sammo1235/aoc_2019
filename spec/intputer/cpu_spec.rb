require './lib/intputer/cpu'

RSpec.describe Cpu do
  let(:cpu) { described_class }
  context 'with parameter mode off' do
    let(:addition_opcode) { [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50] }
    describe '#compute' do
      it 'adds if opcode is 1' do
        expect(cpu.new(addition_opcode).compute(parameter_mode: false, diagnostic_mode: true)).to eq([3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50])
        expect(cpu.new([1,0,0,0,99]).compute(parameter_mode: false, diagnostic_mode: true)).to eq([2,0,0,0,99])
        expect(cpu.new([1,1,1,4,99,5,6,0,99]).compute(parameter_mode: false, diagnostic_mode: true)).to eq([30,1,1,4,2,5,6,0,99])
      end

      it 'multiplies if opcode is 2' do
        expect(cpu.new([2,3,0,3,99]).compute(parameter_mode: false, diagnostic_mode: true)).to eq([2,3,0,6,99])
        expect(cpu.new([2,4,4,5,99,0]).compute(parameter_mode: false, diagnostic_mode: true)).to eq([2,4,4,5,99,9801])
      end
    end
  end

  context 'with parameter mode on' do
    describe '#compute' do
      it 'adds with parameterised opcode' do
        expect(cpu.new([1101,100,-1,4,0]).compute(parameter_mode: true, diagnostic_mode: true)).to eq([1101,100,-1,4,99])
      end

      it 'multiplies with parameterised opcode' do
        expect(cpu.new([1002,4,3,4,33]).compute(parameter_mode: true, diagnostic_mode: true)).to eq([1002,4,3,4,99])
      end

      it 'accepts new opcodes and correctly computes them' do
        expect(cpu.new([3,5,1101,100,-1,4,99])
          .compute(parameter_mode: true, diagnostic_mode: true))
          .to eq([3,99,1101,100,-1,1,99])

        expect(cpu.new([3,0,4,0,99])
          .compute(parameter_mode: true, diagnostic_mode: true))
          .to eq([1,0,4,0,99])
      end
    end
  end
end