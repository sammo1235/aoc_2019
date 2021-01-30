require 'byebug'
class OrbitMap
  attr_accessor :input, :map

  def initialize(input)
    @input = File.open(input, 'r').readlines.map { |i| i.chomp }
    @map = {}
  end

  def part_one
    input.each do |line|
      pieces = line.split(/\)/)
      center = pieces.first
      orbiter = pieces.last

      map[orbiter] = center
    end

    oc = 0

    map.each do |orbiter, center|
      oc += steps_to_center(orbiter)
    end

    oc
  end

  def steps_to_center(orbiter)
    steps = 0
    while true
      steps += 1
      if map[orbiter] == 'COM'
        return steps
      else
        orbiter = map[orbiter]
      end
    end
  end
end