require './lib/11/space_police'

RSpec.describe SpacePolice do
  context 'with sample data' do
    let(:police) { described_class.new('./spec/fixtures/11s.txt') }

    describe '#part_one' do
      it 'counts panels in problem example' do
        expect(police.part_one).to eq(6)
      end
    end
  end

  context 'with old problem data' do
    let(:police) { described_class.new('./spec/fixtures/11s2.txt') }

    describe '#part one' do
      it 'counts the panels painted at least once by the hull painting robot' do
        expect(police.part_one).to eq(1934)
      end
    end
  end

  context 'with problem data' do
    let(:police) { described_class.new('./spec/fixtures/11.txt') }

    describe '#part one' do
      it 'counts the panels painted at least once by the hull painting robot' do
        expect(police.part_one).to eq(2276)
      end
    end

    describe '#part two' do
      it 'solves part two by drawing out the message on the hull' do
        expect(police.part_two)
        .to eq([
          [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], 
          [".", ".", "#", "#", ".", ".", "#", "#", "#", ".", ".", "#", "#", "#", "#", ".", "#", ".", ".", ".", ".", ".", "#", "#", ".", ".", "#", "#", "#", "#", ".", ".", "#", "#", ".", ".", ".", "#", "#", ".", "."], 
          [".", "#", ".", ".", "#", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "#", ".", ".", "#", "."], 
          [".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", "#", "#", "#", ".", ".", ".", ".", ".", "#", ".", ".", "#", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", "."], 
          [".", "#", ".", ".", ".", ".", "#", "#", "#", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", "#", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", ".", "."], 
          [".", "#", ".", ".", "#", ".", "#", ".", ".", "#", ".", "#", ".", ".", ".", ".", "#", ".", ".", "#", ".", ".", ".", ".", "#", ".", ".", ".", ".", "#", ".", "#", ".", ".", "#", ".", "#", ".", ".", "#", ".", ".", "."], 
          [".", ".", "#", "#", ".", ".", "#", "#", "#", ".", ".", "#", ".", ".", ".", ".", "#", "#", "#", ".", ".", ".", ".", "#", "#", ".", "#", "#", "#", "#", ".", ".", "#", "#", ".", ".", "#", ".", ".", "#", ".", "."]
        ])
      end
    end
  end
end
