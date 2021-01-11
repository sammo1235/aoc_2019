require 'byebug'
class CrossedWires
  attr_reader :data, :wires

  def initialize(file)
    @data = File.open(file, 'r').readlines
    @wires = { "1" => [], "2" => [] }
  end

  def part_one
    wire = 1
    data.each do |line|
      c = 0
      r = 0
      # debugger
      line.chomp.split(',').each do |ins|
        dir = ins.scan(/\D/)[0]
        q = ins.scan(/\d/).join.to_i
        case dir
        when 'U'
          (c..c+q).each {|i| wires[wire.to_s] << [i, r] }
          c+=q
        when 'D'
          c.downto(c-q).each {|i| wires[wire.to_s] << [i, r] }
          c-=q
        when 'R'
          (r..r+q).each {|i| wires[wire.to_s] << [c, i] }
          r+=q
        when 'L'
          r.downto(r-q).each {|i| wires[wire.to_s] << [c, i] }
          r-=q
        end
      end
      wire += 1
    end
    (wires["1"] & wires["2"]).map {|coord| coord.map {|i| i.abs }}.map(&:sum).map(&:abs).uniq.sort[1]
  end
end
