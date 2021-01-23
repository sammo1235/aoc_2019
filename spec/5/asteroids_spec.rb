require './lib/5/asteroids'

RSpec.describe Asteroids do
  let(:asteroids) { described_class.new('./spec/fixtures/data_day_5.txt') }

  context 'with sample data' do
    let(:asteroids) { described_class.new('./spec/fixtures/sample_day_5.txt', diagnostic_mode: true) }

    describe '#part_one' do
      it 'solves part one' do
        expect(asteroids.part_one).to eq([1101,100,-1,4,99])
      end
    end
  end

  context 'with problem data' do
    describe '#part one' do
      it 'solves part one' do
        expect(asteroids.part_one).to eq(6745903)
      end
    end

    describe '#part two' do
      it 'solves part two' do
        expect(asteroids.part_two).to eq(9168267)
      end
    end
  end
end