require './lib/5/asteroids'

RSpec.describe Asteroids do
  let(:asteroids) { described_class.new('./spec/fixtures/data_day_5.txt') }

  # context 'with sample data' do
  #   let(:asteroids) { described_class.new('./spec/fixtures/sample_day_5.txt') }

  #   describe '#part_one' do
  #     it 'solves part one' do
  #       expect(asteroids.part_one).to eq(1002)
  #     end
  #   end
  # end

  context 'with problem data' do
    describe '#part one' do
      it 'solves part one' do
        expect(asteroids.part_one).to eq(6745903)
      end
    end

    # describe '#part two' do
    #   it 'solves part two' do
    #     expect(real_alarm.part_two).to eq(8226)
    #   end
    # end
  end
end