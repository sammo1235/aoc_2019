class Alarm
  attr_reader :data, :file

  def initialize(file)
    @file = file
  end

  def get_input
    File.open(file, 'r').readlines[0].split(',').map(&:to_i)
  end

  def compute(arr)
    i = 0
    while true
      f = arr[i+1]
      s = arr[i+2]
      store = arr[i+3]
      if arr[i] == 1
        val = arr[f] + arr[s]
        arr[store] = val
      elsif arr[i] == 2
        val = arr[f] * arr[s]
        arr[store] = val
      elsif arr[i] == 99
        return arr[0]
      else
        break
      end
      i += 4
    end
  end

  def part_one
    compute(get_input)
  end

  def part_two
    (0..99).each do |a|
      (0..99).each do |b|
        arr = get_input
        arr[1] = a
        arr[2] = b
        if compute(arr) == 19690720
          return 100 * a + b
        end
      end
    end
    false
  end
end