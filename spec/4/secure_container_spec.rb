require './lib/4/secure_container'

RSpec.describe SecureContainer do
  let(:test_range) { described_class.new([111111, 223450, 123789])}
  let(:test_range_2) { described_class.new([112233, 123444, 111122])}
  let(:actual_range) { described_class.new((265275..781584))}

  describe '#part_one' do
    it 'gives number of valid passwords in range' do
      expect(test_range.part_one).to eq(1)
      expect(actual_range.part_one).to eq(960)
    end
  end

  describe '#part_two' do
    it 'gives valid passwords with new rule (has to have only 2 adj ints)' do
      expect(test_range_2.part_two).to eq(2)
      expect(actual_range.part_two).to eq(626)
    end
  end
end