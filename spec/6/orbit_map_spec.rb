require './lib/6/orbit_map'

RSpec.describe OrbitMap do
  let(:orbits) { described_class.new('./spec/fixtures/6.txt') }

  context 'with sample data' do
    let(:orbits) { described_class.new('./spec/fixtures/sample_day_6.txt') }

    describe '#part_one' do
      it 'solves part one' do
        expect(orbits.part_one).to eq(42)
      end
    end
  end

  context 'with sample part two data' do
    let(:orbits) { described_class.new('./spec/fixtures/sample_2_day_6.txt') }

    describe '#part_two' do
      it 'returns hops between you and SAN' do
        expect(orbits.part_two).to eq(4)
      end
    end
  end

  context 'with problem data' do
    describe '#part one' do
      it 'counts total numebr of orbits' do
        expect(orbits.part_one).to eq(621125)
      end
    end

    describe '#part two' do
      it '''counts number of hops between object you are orbiting
            and the object SAN is orbiting''' do
        expect(orbits.part_two).to eq(550)
      end
    end
  end
end