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
      line.chomp.split(',').each do |ins|
        dir = ins.scan(/\D/)[0]
        q = ins.scan(/\d/).join.to_i
        case dir
        when 'U'
          ((c+1)..c+q).each {|i| wires[wire] << [i, r] }
          c+=q
        when 'D'
          (c-1).downto(c-q).each {|i| wires[wire] << [i, r] }
          c-=q
        when 'R'
          ((r+1)..r+q).each {|i| wires[wire] << [c, i] }
          r+=q
        when 'L'
          (r-1).downto(r-q).each {|i| wires[wire] << [c, i] }
          r-=q
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
