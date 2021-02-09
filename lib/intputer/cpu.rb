require 'byebug'
require_relative 'error_checker'

class Cpu
  attr_reader :diagnostic_mode
  attr_accessor :ind, :input, :quantum_fluctuating_input, :phase_setting, :relative_base, :params

  VALID_OPCODES = (1..9).to_a.freeze

  def initialize(input, diagnostic_mode = false, quantum_fluctuating_input = nil, phase_setting = nil)
    @input = input
    @ind = 0
    @params = {}
    @diagnostic_mode = diagnostic_mode
    @quantum_fluctuating_input = quantum_fluctuating_input
    @phase_setting = phase_setting
    @relative_base = 0
    ErrorChecker.new(self)
  end

  def compute
    while true
      if ind < 0
        raise PointerOutOfBoundsException.new("#{ind} is not within program opcode bounds")
      end

      opcode = input[ind]

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

      out = run_opcode(opcode)

      if opcode == 4
        return input if @diagnostic_mode
        return out if out > 0
      end

      memory_position_discombobulator(opcode, out)
    end
  end

  private

  def run_opcode(opcode)
    case opcode
    when 1
      # debugger if store_position != params['store']
      input[params['store']] = params.values[0..1].reduce(&:+)
    when 2
      input[params['store']] = params.values[0..1].reduce(&:*)
    when 3
      input[params.values.first] = if phase_setting
        phase_setting
      elsif quantum_fluctuating_input
        quantum_fluctuating_input
      else
        1
      end
      @phase_setting = nil
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
        input[params['store']] = 1
      else
        input[params['store']] = 0
      end
    when 8
      if params.values[0] == params.values[1]
        input[params['store']] = 1
      else
        input[params['store']] = 0
      end
    when 9
      @relative_base += params.values[0]
    end
  end

  def parameter_interpreter(opcode)
    param_codes = opcode.to_s.rjust(5, "0")[0..2].each_char.map(&:to_i).reverse
    opcode_check(opcode.digits.first)

    (1..2).each do |position|
      case param_codes[position-1] # position mode
      when 0
        if input[ind+position] < 0
          raise InvalidPositionException.new("Invalid program position: #{input[ind+position]} with opcode: #{opcode}")
        end

        params[position.to_s] = input[input[ind+position]|| 0]
      when 1 # immediate_mode
        params[position.to_s] = input[ind+position]
      when 2
        params[position.to_s] = input[input[ind+position] + relative_base]
      end
    end

    opcode = opcode.digits.first
    if [1, 2, 7, 8].include? opcode
      # third param must be positional or relative base
      case param_codes[2]
      when 0
        params["store"] = input[ind+3]
      when 2
        params["store"] = input[ind+3] + relative_base
      else
        raise InvalidOpcodeException.new("invalid opcode parameter")
      end
    elsif opcode == 3
      # for input/output we want the index not the value at that index
      case param_codes[0]
      when 0
        params["1"] = input[ind+1]
      when 2
        params["1"] = input[ind+1] + relative_base
      end
    elsif opcode == 4
      case param_codes[0]
      when 0
        params["1"] = input[input[ind+1]]
      when 1
        params["1"] = input[ind+1]
      when 2
        params["1"] = input[ind+1] + relative_base
      end
    end
  end

  def memory_position_discombobulator(opcode, output)
    case
    when [5, 6].include?(opcode) && output
      @ind += 3
    when [3, 4, 9].include?(opcode)
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
end
