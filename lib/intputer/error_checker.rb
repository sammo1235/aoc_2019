require 'forwardable'
require 'byebug'

class InputException < StandardError; end
class PointerOutOfBoundsException < StandardError; end

class ErrorChecker
  extend Forwardable

  def_delegators :@cpu, :input, :diagnostic_mode, :quantum_fluctuating_input, :phase_setting

  def initialize(cpu)
    @cpu = cpu
    check_errors
  end

  def check_errors
    raise InputException.new("Program must be of type Array but is an #{input.class}") unless input.is_a? Array

    unless [true, false].include? diagnostic_mode
      raise ArgumentError, 'Diagnostic flag must be a boolean'
    end

    [quantum_fluctuating_input, phase_setting].each do |setting|
      next if setting.nil?
      raise ArgumentError, "#{setting_name(setting)} must be an Integer" unless setting.is_a? Integer
    end
  end

  def setting_name(value)
    @cpu.instance_variables.each do |ivar_name|
      if @cpu.instance_variable_get(ivar_name) == value
        return ivar_name.to_s.sub(/^@/, '')
      end
    end
    nil
  end
end