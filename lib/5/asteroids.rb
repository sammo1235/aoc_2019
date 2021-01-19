require './lib/intputer/cpu'

class Asteroids
  attr_accessor :file

  def initialize(file)
    @file = file
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end

  def part_one
    Cpu.new(get_input).compute(parameter_mode: true)
  end

  def part_two

  end
end