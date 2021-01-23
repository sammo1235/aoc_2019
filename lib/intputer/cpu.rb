require 'byebug'

class Cpu
  attr_accessor :ind, :input, :params, :extend_thermal_radiators, :quantum_fluctuating_input

  def initialize(input, quantum_fluctuating_input = nil, extend_thermal_radiators: false)
    @input = input
    @ind = 0
    @params = {}
    @extend_thermal_radiators = extend_thermal_radiators
    @quantum_fluctuating_input = quantum_fluctuating_input
  end


  def compute(parameter_mode: false, diagnostic_mode: false)
    while true
      opcode = input[ind]
      store_position = input[ind+3]

      if diagnostic_mode
        return input if input[ind+1].nil? || opcode.nil? || opcode == 99
      end

      return input[0] if opcode == 99

      if parameter_mode && opcode > 4 && opcode.digits.size > 1
        parameter_interpreter(opcode)
        opcode = opcode.digits.first
      else
        parameter_interpreter
      end

      # puts "opcode: #{opcode}, index: #{ind}, params: #{params}"

      out = run_opcode(opcode, store_position)

      if out.is_a? Integer
        return input if opcode == 4 && diagnostic_mode # for testing, we want the whole output
        return out if opcode == 4 && out > 0
      end

      case
      when [5, 6].include?(opcode) && out
        self.ind += 3
      when [3, 4].include?(opcode)
        self.ind += 2
      when [1, 2, 7, 8].include?(opcode)
        self.ind += 4
      end
    end
  end

  def run_opcode(opcode, store_position)
    case opcode
    when 1
      input[store_position] = params.values.reduce(&:+)
    when 2
      input[store_position] = params.values.reduce(&:*)
    when 3
      input[input[ind+1]] = if extend_thermal_radiators
        5
      elsif quantum_fluctuating_input
        quantum_fluctuating_input
      else
        1
      end
    when 4
      # when 104, output immediate next value
      # when 4, output index of next value
      params.values.first
    when 5
      if !params.values[0].zero?
        self.ind = params.values[1]
        return false
      else
        return true # jump 3 / ignore
      end
    when 6
      if params.values[0].zero?
        self.ind = params.values[1]
        return false
      else
        return true # jump 3 / ingore
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

  def parameter_interpreter(opcode = nil)
    param_codes = if opcode
      opcode.digits[2..-1].map(&:zero?) << true
    else
      [true]*2
    end

    (1..2).each do |position|
      if param_codes[position-1] # position mode
        params[position.to_s] = input[input[ind+position]]
      else # immediate_mode
        params[position.to_s] = input[ind+position]
      end
    end
  end
end
