require './lib/intputer/cpu'

class SensorBoost
  attr_accessor :input, :diagnostic_mode
  def initialize(input, diagnostic_mode, options = {})
    @input = File.open(input, 'r').readlines[0].split(',').map(&:to_i)
    @diagnostic_mode = diagnostic_mode
    if options[:extra_memory]
      10000.times do
        @input << 0
      end
    end
  end

  def part_one
    Cpu.new(input, diagnostic_mode).compute
  end
end