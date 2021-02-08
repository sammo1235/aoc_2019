require './lib/8/space_image_format'

RSpec.describe SpaceImageFormat do
  context 'with test data and image size of 3x2' do
    describe '#part one' do
      it 'finds picture layer with least number of 0 values
          and multiplies number of 1s by number of 2s' do
          expect(SpaceImageFormat.new("./spec/fixtures/sample_day_8.txt", 3, 2).part_one)
          .to eq(2)
      end
    end
  end

  context 'with problem data' do
    describe '#part one' do
      it 'finds picture layer with least number of 0 values
          and multiplies number of 1s by number of 2s' do
          expect(SpaceImageFormat.new('./spec/fixtures/data_day_8.txt', 25, 6).part_one)
          .to eq(1584)
      end
    end
  end

  context 'with test data and image size of 2x2' do
    describe '#part two' do
      it 'decodes the image and returns only white or black pixels' do
          expect(SpaceImageFormat.new('./spec/fixtures/sample_2_day_8.txt', 2, 2).part_two)
          .to eq("01\n10\n")
      end
    end
  end

  context 'with test data and image size of 2x2' do
    describe '#part two' do
      it 'decodes the image and returns only white or black pixels' do
          expect(SpaceImageFormat.new('./spec/fixtures/data_day_8.txt', 25, 6).part_two)
          .to eq("1001001100011001111001100\n1010010010100101000010010\n1100010000100001110010000\n1010010000101101000010000\n1010010010100101000010010\n1001001100011101111001100\n")
      end
    end
  end
end
