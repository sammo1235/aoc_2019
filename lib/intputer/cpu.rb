require 'byebug'

class Cpu
  attr_accessor :ind, :input, :params

  def initialize(input)
    @input = input
    @ind = 0
    @params = {}
  end


  def compute(parameter_mode: false, diagnostic_mode: false)
    while true
      opcode = input[ind]
      store_position = input[ind+3]

      if diagnostic_mode
        return input if input[ind+1].nil? || opcode.nil? || opcode == 99
      end

      return input[0] if opcode == 99

      if parameter_mode && opcode > 4
        parameter_interpreter(opcode)
        opcode = opcode.digits.first
      else
        parameter_interpreter
      end

      out = run_opcode(opcode, store_position)
      return out if out && out > 3 && opcode == 4

      [3, 4].include?(opcode) ? self.ind += 2 : self.ind += 4
    end
  end

  def run_opcode(opcode, store_position)
    case opcode
    when 1
      input[store_position] = params.values.reduce(&:+)
    when 2
      input[store_position] = params.values.reduce(&:*)
    when 3
      input[input[ind+1]] = 1
    when 4
      input[input[ind+1]]
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
