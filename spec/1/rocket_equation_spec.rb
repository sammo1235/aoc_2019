require './lib/1/rocket_equation'

RSpec.describe RocketEquation do
  let(:equation) { described_class.new('./spec/fixtures/data_day_1.txt') }

  describe '#part_one' do
    it 'solves part one of the problem' do
      expect(equation.part_one).to eq(3406342)
    end
  end

  describe '#part two' do
    it 'solves part two of the problem' do
      expect(equation.part_two).to eq(5106629)
    end
  end
end