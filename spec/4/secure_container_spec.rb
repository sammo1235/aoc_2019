require './lib/4/secure_container'

RSpec.describe SecureContainer do
  let(:test_range) { described_class.new([111111, 223450, 123789])}
  let(:actual_range) { described_class.new((265275..781584))}

  describe '#part_one' do
    it 'gives number of valid passwords in range' do
      expect(test_range.part_one).to eq(1)
      expect(actual_range.part_one).to eq(960)
    end
  end
end