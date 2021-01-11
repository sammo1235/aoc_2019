require './lib/2/alarm'

RSpec.describe Alarm do
  let(:sample_alarm) { described_class.new('./spec/fixtures/sample_day_2.txt') }
  let(:real_alarm) { described_class.new('./spec/fixtures/data_day_2.txt') }

  context 'with sample data' do
    describe '#part one' do
      it 'solves part one' do
        expect(sample_alarm.part_one).to eq(3500)
      end
    end
  end

  context 'with problem data' do
    describe '#part one' do
      it 'solves part one' do
        expect(real_alarm.part_one).to eq(2890696)
      end
    end

    describe '#part two' do
      it 'solves part two' do
        expect(real_alarm.part_two).to eq(8226)
      end
    end
  end
end