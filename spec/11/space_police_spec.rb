require './lib/11/space_police'

RSpec.describe SpacePolice do
  context 'with sample data' do
    let(:police) { described_class.new('./spec/fixtures/11s.txt') }

    describe '#part_one' do
      it 'should output a copy of itself' do
        expect(police.part_one).to eq(6)
      end
    end
  end

  context 'with old problem data' do
    let(:police) { described_class.new('./spec/fixtures/11s2.txt') }

    describe '#part one' do
      it 'solves part one' do
        expect(police.part_one).to eq(1934)
      end
    end
  end

  context 'with problem data' do
    let(:police) { described_class.new('./spec/fixtures/11.txt') }

    describe '#part one' do
      it 'solves part one' do
        expect(police.part_one).to eq(2276)
      end
    end
  end
end
