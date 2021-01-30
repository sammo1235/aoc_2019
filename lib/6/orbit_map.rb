class OrbitMap
  attr_accessor :input, :map

  def initialize(input)
    @input = File.open(input, 'r').readlines.map { |i| i.chomp }
    @map = {}
    create_orbit_map
  end

  def part_one
    oc = 0

    map.each do |orbiter, center|
      oc += steps_to_center(orbiter)
    end

    oc
  end

  def part_two
    you = orbits_to_center('YOU')
    san = orbits_to_center('SAN')
    ((you | san) - (you & san)).size - 2
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

  def orbits_to_center(orbiter)
    orbits = []
    while true
      orbits << orbiter
      if map[orbiter] == 'COM'
        return orbits
      else
        orbiter = map[orbiter]
      end
    end
  end

  def create_orbit_map
    input.each do |line|
      pieces = line.split(/\)/)
      center = pieces.first
      orbiter = pieces.last

      map[orbiter] = center
    end
  end
end