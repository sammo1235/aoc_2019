require './lib/intputer/cpu'

class Asteroids
  def initialize(file, diagnostic_mode = false)
    @file = file
    @diagnostic_mode = diagnostic_mode
  end

  def get_input
    File.open(@file, 'r').readlines[0].split(',').map(&:to_i)
  end

  def part_one
    Cpu.new(get_input, @diagnostic_mode, 1).compute
  end

  def part_two
    Cpu.new(get_input, @diagnostic_mode, 5).compute
  end
end