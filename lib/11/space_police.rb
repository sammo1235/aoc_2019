require './lib/intputer/cpu'

class SpacePolice
  attr_accessor :input, :dir, :x, :y

  def initialize(input)
    @input = File.open(input, 'r').readlines[0].split(',').map(&:to_i)
    @dir = 0
    @x = 0
    @y = 0
  end

  def part_one
    panels = {}
    cpu = Cpu.new(@input, false, 0, nil, painting_mode: true)
    moves = 0
    already_painted = 0
    loop do
      # if new panel is white, input = 1
      cpu.quantum_fluctuating_input = if panels["x#{@x}y#{@y}"] == '#'
        1
      else
        0
      end


      paint = if moves < 1
        cpu.compute
      else
        cpu.continue
      end

      if paint.is_a? Array
        break
      elsif paint == 0
        panels["x#{@x}y#{@y}"] = '.'
      elsif paint == 1
        panels["x#{@x}y#{@y}"] = '#'
      else
        raise StandardError => e
      end

      direction = cpu.continue
      # output = left 90 if 0, right 90 if 1
      if direction.is_a? Array
        break
      elsif direction == 0
        @dir -= 90
        @dir += 360 if @dir < 0
      elsif direction == 1
        @dir += 90
        @dir -= 360 if @dir >= 360
      else
        raise StandardError => e
      end

      # move robot
      case @dir
      when 0 # up
        @y += 1
      when 90
        @x += 1
      when 180
        @y -= 1
      when 270
        @x -= 1
      else
        raise StandardError => e
      end
      moves += 1
      # debugger
    end
    panels.keys.size
  end
end