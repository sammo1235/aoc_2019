require './lib/intputer/cpu'

class AmplificationCircuit
  attr_accessor :file, :phase_setting_sequence

  def initialize(file, phase_setting_sequence = nil)
    @file = file
    @phase_setting_sequence = phase_setting_sequence
  end

  def part_one
    input_signal = 0
    if phase_setting_sequence
      phase_setting_sequence.each do |phase_setting|
        output = Cpu.new(get_input, false, input_signal, phase_setting).compute
        input_signal = output
      end
    else
      # find maximum signal that can be sent to thrusters
      final_signals = []
      (0..4).to_a.permutation.each do |phase_setting_sequence|
        input_signal = 0
        phase_setting_sequence.each_with_index do |phase_setting, index|
          output = Cpu.new(get_input, false, input_signal, phase_setting).compute
          if index < 4
            input_signal = output
          else
            final_signals << output
          end
        end
      end
    end
    if final_signals
      final_signals.max
    else
      input_signal
    end
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end
end