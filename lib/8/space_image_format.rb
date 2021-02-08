require 'byebug'

class SpaceImageFormat
  attr_accessor :input, :image, :width, :height

  def initialize(input, width, height)
    @input = File.open(input).readlines.map(&:chomp).join
    @image = Hash.new {|h, k| h[k] = [] }
    @width = width
    @height = height
    layers
  end

  def part_one
    zero_counts = {}

    image.map do |k, v|
      zero_counts[k] = v.flatten.count(0)
    end

    key = zero_counts.sort_by {|k, v| v}.first[0]
    ones = image[key].flatten.count(1)
    twos = image[key].flatten.count(2)
    ones * twos
  end

  def part_two
    final_image = []

    image.values_at("1").each do |layer|
      layer.each_with_index do |line, row|
        line.each_with_index do |pixel, col|
          final_image << get_pixel(1, row, col).to_s
        end
        final_image << "\n"
      end
    end

    final_image.join
  end

  private

  def get_pixel(layer, row, column)
    if image[layer.to_s][row][column] < 2
      image[layer.to_s][row][column]
    else
      get_pixel(layer+1, row, column)
    end
  end

  def layers
    count = 1
    layer = 1
    input.split(//).each_slice(width) do |slice|
      image[layer.to_s] << slice.map(&:to_i)
      if count == height
        count = 1
        layer += 1
      else
        count += 1
      end
    end
  end
end