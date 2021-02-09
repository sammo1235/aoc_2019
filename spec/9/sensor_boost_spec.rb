require './lib/9/sensor_boost'

RSpec.describe SensorBoost do
  let(:boost) { described_class.new('./spec/fixtures/9.txt', false, extra_memory: true) }

  context 'with sample data' do
    let(:boost) { described_class.new('./spec/fixtures/9s.txt', true, extra_memory: true) }
    let(:boost2) { described_class.new('./spec/fixtures/9s2.txt', false) }
    let(:boost3) { described_class.new('./spec/fixtures/9s3.txt', false) }

    describe '#part_one' do
      it 'should output a copy of itself' do
        expect(boost.part_one[0..15]).to eq([109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
      end
    end

    describe '#part_one' do
      it 'should output a 16 digit number' do
        expect(boost2.part_one).to eq(1219070632396864)
      end
    end

    describe '#part_one' do
      it 'should output the long middle number' do
        expect(boost3.part_one).to eq(1125899906842624)
      end
    end
  end

  context 'with problem data' do
    describe '#part one' do
      it 'solves part one' do
        expect(boost.part_one).to eq(2350741403)
      end
    end

    # describe '#part two' do
    #   it 'solves part two' do
    #     expect(boost.part_two).to eq(9168267)
    #   end
    # end
  end
end