require './lib/intputer/cpu'

class SpacePolice
  attr_accessor :input, :dir, :x, :y, :panels

  def initialize(input)
    @input = File.open(input, 'r').readlines[0].split(',').map(&:to_i)
    @dir = 0
    @x = 0
    @y = 0
    @panels = {}
  end

  def part_one
    cpu = Cpu.new(@input, false, 0, nil, painting_mode: true)
    move_robot(cpu)
    panels.keys.size
  end

  def part_two
    cpu = Cpu.new(@input, false, 0, 1, painting_mode: true)
    move_robot(cpu)
    hull = Array.new(7) {Array.new(['.']*40) }
    panels.each do |coord, colour|
      yc = coord.split('y')[1].to_i + 6
      xc = coord.scan(/^x([0-9]{1,})/)[0][0].to_i 
      hull[yc][xc] = colour
    end
    # print this to see message
    # hull.map {|line| line.join }.join("\n")
    hull
  end

  def move_robot(cpu)
    moves = 0
    loop do
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

      case @dir
      when 0
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
    end
  end
end