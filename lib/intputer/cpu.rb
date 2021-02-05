require 'byebug'
require_relative 'error_checker'

class Cpu
  attr_reader :diagnostic_mode
  attr_accessor :ind, :input, :quantum_fluctuating_input, :phase_setting

  VALID_OPCODES = (1..8).to_a.freeze

  def initialize(input, diagnostic_mode = false, quantum_fluctuating_input = nil, phase_setting = nil)
    @input = input
    @ind = 0
    @params = {}
    @diagnostic_mode = diagnostic_mode
    @quantum_fluctuating_input = quantum_fluctuating_input
    @phase_setting = phase_setting
    ErrorChecker.new(self)
  end

  def compute
    while true
      if ind < 0 || ind > input.size - 1
        raise PointerOutOfBoundsException.new("#{ind} is not within program opcode bounds")
      end

      opcode = input[ind]
      store_position = input[ind+3]

      if opcode == 99
        if @diagnostic_mode
          return input
        else
          return [true, input[0]]
        end
      end

      parameter_interpreter(opcode)
      opcode = opcode.digits.first

      opcode_check(opcode)

      out = run_opcode(opcode, store_position)

      if opcode == 4
        return input if @diagnostic_mode
        return out if out > 0
      end

      memory_position_discombobulator(opcode, out)
    end
  end

  private

  def run_opcode(opcode, store_position)
    case opcode
    when 1
      input[store_position] = params.values.reduce(&:+)
    when 2
      input[store_position] = params.values.reduce(&:*)
    when 3
      input[input[ind+1]] = if phase_setting
        phase_setting
      elsif quantum_fluctuating_input
        quantum_fluctuating_input
      else
        1
      end
      @phase_setting = nil if @phase_setting
    when 4
      params.values.first
    when 5
      if !params.values[0].zero?
        @ind = params.values[1]
        return false
      else
        return true
      end
    when 6
      if params.values[0].zero?
        @ind = params.values[1]
        return false
      else
        return true
      end
    when 7
      if params.values[0] < params.values[1]
        input[store_position] = 1
      else
        input[store_position] = 0
      end
    when 8
      if params.values[0] == params.values[1]
        input[store_position] = 1
      else
        input[store_position] = 0
      end
    end
  end

  def parameter_interpreter(opcode)
    param_codes = opcode.to_s.rjust(5, "0")[0..2].each_char.map(&:to_i).map(&:zero?).reverse
    opcode_check(opcode.digits.first)

    (1..2).each do |position|
      if param_codes[position-1] # position mode
        unless input[input[ind+position]] || [104, 4, 3].include?(opcode)
          raise InvalidPositionException.new("Invalid program position: #{input[ind+position]} with opcode: #{opcode}")
        end

        params[position.to_s] = input[input[ind+position]]
      else # immediate_mode
        params[position.to_s] = input[ind+position]
      end
    end
  end

  def memory_position_discombobulator(opcode, output)
    case
    when [5, 6].include?(opcode) && output
      @ind += 3
    when [3, 4].include?(opcode)
      @ind += 2
    when [1, 2, 7, 8].include?(opcode)
      @ind += 4
    end
  end

  def opcode_check(opcode)
    unless VALID_OPCODES.include? opcode
      raise InvalidOpcodeException.new("#{opcode} is not a valid opcode")
    end
  end

  attr_accessor :params
end
