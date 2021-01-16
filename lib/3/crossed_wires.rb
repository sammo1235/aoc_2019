require 'byebug'
class CrossedWires
  attr_reader :data, :wires

  def initialize(file)
    @data = File.open(file, 'r').readlines
    @wires = [[], []]
  end

  def part_one
    wire_path
  end

  def part_two
    wire_path(false)
  end

  def wire_path(p1 = true)
    wire = 0
    data.each do |line|
      c = 0
      r = 0
      # debugger
      line.chomp.split(',').each do |ins|
        dir = ins.scan(/\D/)[0]
        q = ins.scan(/\d/).join.to_i
        case dir
        when 'U'
          c+=1
          (c..c+(q-1)).each {|i| wires[wire] << [i, r] }
          c+=(q-1)
        when 'D'
          c-=1
          c.downto(c-(q-1)).each {|i| wires[wire] << [i, r] }
          c-=(q-1)
        when 'R'
          r+=1
          (r..r+(q-1)).each {|i| wires[wire] << [c, i] }
          r+=(q-1)
        when 'L'
          r-=1
          r.downto(r-(q-1)).each {|i| wires[wire] << [c, i] }
          r-=(q-1)
        end
      end
      wire += 1
    end
    p1 ? closest_crossing : fewest_steps_to_crossing
  end

  def closest_crossing
    (wires[0] & wires[1]).map { |coord| coord.map(&:abs) }.map(&:sum).uniq.sort.first
  end

  def fewest_steps_to_crossing
    crossings = wires[0] & wires[1]
    crossings.each_with_object([]) do |c, obj|
      obj << (wires[0].index(c)+1) + (wires[1].index(c)+1)
    end.min
  end
end
