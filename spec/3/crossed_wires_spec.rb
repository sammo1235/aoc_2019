require './lib/3/crossed_wires'

RSpec.describe CrossedWires do
  let(:sample_wires) { described_class.new('./spec/fixtures/sample_day_3.txt') }
  let(:sample_wires_2) { described_class.new('./spec/fixtures/sample_2_day_3.txt') }
  let(:actual_wires) { described_class.new('./spec/fixtures/data_day_3.txt') }

  context 'with sample data' do
    describe '#part_one' do
      it 'finds the closest crossed wire to the origin' do
        expect(sample_wires.part_one).to eq(6)
        expect(sample_wires_2.part_one).to eq(159)
      end
    end

    describe '#part_two' do
      it 'solves part two of the problem' do
        expect(sample_wires.part_two).to eq(30)
        expect(sample_wires_2.part_two).to eq(610)
      end
    end
  end

  context 'with actual data' do
    describe '#part_one' do
      it 'finds the closest crossed wire to the origin' do
        expect(actual_wires.part_one).to eq(221)
      end
    end

    describe '#part_two' do
      it 'solves part two of the problem' do
        expect(actual_wires.part_two).to eq(18542)
      end
    end
  end
end