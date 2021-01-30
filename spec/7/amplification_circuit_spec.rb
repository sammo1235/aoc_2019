require './lib/7/amplification_circuit'

RSpec.describe AmplificationCircuit do
  let(:amp) { described_class.new('./spec/fixtures/data_day_7.txt') }

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

  # context 'with sample part two data' do
  #   let(:orbits) { described_class.new('./spec/fixtures/sample_2_day_6.txt') }

  #   describe '#part_two' do
  #     it 'returns hops between you and SAN' do
  #       expect(orbits.part_two).to eq(4)
  #     end
  #   end
  # end

  context 'with problem data' do
    describe '#part one' do
      it 'returns max signal that can be sent to thrusters' do
        expect(amp.part_one).to eq(880726)
      end
    end

    # describe '#part two' do
    #   it '''counts number of hops between object you are orbiting
    #         and the object SAN is orbiting''' do
    #     expect(orbits.part_two).to eq(550)
    #   end
    # end
  end
end