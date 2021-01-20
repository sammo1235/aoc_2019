require './lib/intputer/cpu'

class Asteroids
  attr_accessor :file, :diagnostic_mode

  def initialize(file, diagnostic_mode = false)
    @file = file
    @diagnostic_mode = diagnostic_mode
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end

  def part_one
    Cpu.new(
      get_input
    ).compute(
      parameter_mode: true,
      diagnostic_mode: diagnostic_mode
    )
  end

  def part_two
    # todo
  end
end