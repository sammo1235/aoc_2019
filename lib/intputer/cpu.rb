require 'byebug'

class Cpu
  attr_accessor :input

  def initialize(input)
    @input = input
  end


  def compute(parameter_mode: false, diagnostic_mode: false)
    index = 0
    while true
      major_skip = true

      params = {}

      opcode = input[index]

      if diagnostic_mode
        return input if input[index+1].nil? || opcode.nil? || opcode == 99
      end

      begin
        # parameter_mode
        if parameter_mode && opcode.digits.size > 1
          param_codes = opcode.digits[2..-1].map(&:zero?) # 0 == position mode
          opcode = opcode.digits.first
          while param_codes.size < 3
            param_codes << true
          end
          (1..2).each do |position|
            if param_codes[position-1] # position mode
              params[position.to_s] = input[input[index+position]]
            else # immediate_mode
              params[position.to_s] = input[index+position]
            end
          end
          store_position = input[index+3]
        elsif [3, 4].include? opcode
          # params are handled below if code is 3 or 4
        else
          (1..2).each do |pos| # all positional
            params[pos.to_s] = input[input[index+pos]]
          end
          store_position = input[index+3]
        end
      rescue => exception
        puts exception
        debugger
        break
      end

      # debugger
      if opcode == 1
        val = params["1"] + params["2"]
        input[store_position] = val
      elsif opcode == 2
        val = params["1"] * params["2"]
        input[store_position] = val
      elsif opcode == 3
        input[input[index+1]] = 1
        major_skip = false
      elsif opcode == 4
        # this should always output zero until the final diagnostic code
        output = input[input[index+1]]
        return output if output > 3
        major_skip = false
      elsif opcode == 99
        return input[0]
      else # catch other opcodes
        # do nothing
      end
      if major_skip
        index += 4
      else
        index += 2
      end
    end
  end

  def parameter_iterpreter(opcode)

  end
end

class OpcodeInterpreter
  def initialize(opcode)

  end
end