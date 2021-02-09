require './lib/7/amplification_circuit'

RSpec.describe AmplificationCircuit do
  let(:amp) { described_class.new('./spec/fixtures/7.txt') }

  context 'with sample program and fixed phase setting sequence' do
    let(:amp) { described_class.new('./spec/fixtures/sample_day_7.txt', [4,3,2,1,0]) }

    describe '#part_one' do
      it 'solves part one' do
        expect(amp.part_one).to eq(43210)
      end
    end
  end

  context 'with sample program 2 and fixed phase setting sequence' do
    let(:amp) { described_class.new('./spec/fixtures/sample_2_day_7.txt', [0,1,2,3,4])}

    describe '#part_one' do
      it 'solves part one' do
        expect(amp.part_one).to eq(54321)
      end
    end
  end

  context 'with sample part two data' do
    let(:amp) { described_class.new('./spec/fixtures/sample_3_day_7.txt', [9,8,7,6,5]) }

    describe '#part_two' do
      it 'returns max thruster signal after sending the above sequence through the feedback loop' do
        expect(amp.part_two).to eq(139629729)
      end
    end
  end

  context 'with sample part two data' do
    let(:amp) { described_class.new('./spec/fixtures/sample_4_day_7.txt', [9,7,8,5,6]) }

    describe '#part_two' do
      it 'returns max thruster signal after sending the above sequence through the feedback loop' do
        expect(amp.part_two).to eq(18216)
      end
    end
  end

  context 'with problem data' do
    describe '#part one' do
      it 'returns max signal that can be sent to thrusters' do
        expect(amp.part_one).to eq(880726)
      end
    end

    describe '#part two' do
      it 'returns max thruster signal after sending the above sequence through the feedback loop' do
        expect(amp.part_two).to eq(4931744)
      end
    end
  end
end