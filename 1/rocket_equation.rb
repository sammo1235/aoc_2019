def fuel_required(m)
  m / 3 - 2
end

# part 1
p File.open('./data.txt', 'r').readlines.reduce(0) { |memo, i| memo += fuel_required(i.chomp.to_i); memo }

# part 2
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

p File.open('./data.txt', 'r').readlines.reduce(0) {|memo, i| memo += fuel_mass(i.chomp.to_i); memo }
