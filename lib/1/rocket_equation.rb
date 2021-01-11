class RocketEquation
  attr_reader :data

  def initialize(file)
    @data = File.open(file, 'r').readlines
  end

  def part_one
    data.reduce(0) { |memo, i| memo += fuel_required(i.chomp.to_i); memo }
  end

  def part_two
    data.reduce(0) {|memo, i| memo += fuel_mass(i.chomp.to_i); memo }
  end

  def fuel_required(m)
    m / 3 - 2
  end

  def fuel_mass(i)
    memo = 0
    fuel = fuel_required(i)
    memo += fuel
    while true
      fuel = fuel_required(fuel)
      if fuel > 0
        memo += fuel
      else
        break
      end
    end
    memo
  end
end
