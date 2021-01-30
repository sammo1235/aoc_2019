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

  def part_two
    amps = {}
    input_signal = 0

    if phase_setting_sequence # for diagnosis
      first_run = true
      while true
        phase_setting_sequence.each_with_index do |phase_setting, index|
          amp = amps[index.to_s] || Cpu.new(get_input, false, input_signal, phase_setting)
          amp.ind += 2 unless first_run # continue the program
          amp.quantum_fluctuating_input = input_signal
          amp.phase_setting = nil unless first_run

          output = amp.compute

          if output.is_a?(Array)
            return input_signal
          else
            if output > input_signal
              input_signal = output
            end
          end
          amps[index.to_s] = amp
        end
        first_run = false
      end
    else # run actual data
      final_signals = []
      (5..9).to_a.permutation.each do |phase_setting_sequence|
        first_run = true
        amps = {}
        input_signal = 0
        do_break = false
        while true
          phase_setting_sequence.each_with_index do |phase_setting, index|
            amp = amps[index.to_s] || Cpu.new(get_input, false, input_signal, phase_setting)
            amp.ind += 2 unless first_run # continue the program
            amp.quantum_fluctuating_input = input_signal
            amp.phase_setting = nil unless first_run

            output = amp.compute

            if output.is_a? Array
              final_signals << input_signal
              do_break = true
              break
            else
              if output > input_signal
                input_signal = output
              end
            end
            amps[index.to_s] = amp
          end
          break if do_break
          first_run = false
        end
      end
    end
    final_signals.max
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end
end