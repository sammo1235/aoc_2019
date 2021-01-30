require './lib/intputer/cpu'

class Alarm
  attr_reader :data, :file

  def initialize(file)
    @file = file
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end

  def part_one
    Cpu.new(get_input).compute
  end

  def part_two
    (0..99).each do |a|
      (0..99).each do |b|
        arr = get_input
        arr[1] = a
        arr[2] = b
        if Cpu.new(arr).compute[1] == 19690720
          return 100 * a + b
        end
      end
    end
    false
  end
end