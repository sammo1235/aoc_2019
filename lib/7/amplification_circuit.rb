require './lib/intputer/cpu'

class AmplificationCircuit
  attr_accessor :file, :phase_setting_sequence, :final_signals

  def initialize(file, phase_setting_sequence = nil)
    @file = file
    @phase_setting_sequence = phase_setting_sequence
    @final_signals = []
  end

  def part_one
    input_signal = 0
    if phase_setting_sequence
      run_sequential_phase_permutation(phase_setting_sequence)
    else
      (0..4).to_a.permutation.each do |phase_setting_sequence|
        run_sequential_phase_permutation(phase_setting_sequence)
      end
    end

    final_signals.max
  end

  def run_sequential_phase_permutation(phase_setting_sequence)
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

  def part_two
    if phase_setting_sequence
      run_concurrent_phase_permutation(phase_setting_sequence)
    else
      (5..9).to_a.permutation.each do |phase_setting_sequence|
        run_concurrent_phase_permutation(phase_setting_sequence)
      end
    end

    final_signals.max
  end

  def run_concurrent_phase_permutation(phase_setting_sequence)
    amps = {}
    input_signal = 0
    while true
      phase_setting_sequence.each_with_index do |phase_setting, index|
        amp = amps[index.to_s] || Cpu.new(get_input, false, input_signal, phase_setting)
        amp.ind += 2 if amp.phase_setting.nil? # continue the program
        amp.quantum_fluctuating_input = input_signal

        output = amp.compute

        if output.is_a?(Array)
          final_signals << input_signal
          return
        else
          input_signal = output
        end
        amps[index.to_s] = amp
      end
    end
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end
end