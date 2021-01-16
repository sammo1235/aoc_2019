require 'byebug'
class SecureContainer
  attr_accessor :ir
  def initialize(input)
    @ir = input
  end

  def part_one
    c = 0
    ir.each do |pw|
      c += 1 if has_two_adj_ints?(pw) && never_decrease?(pw)
    end
    c
  end

  def part_two
    c = 0
    ir.each do |pw|
      c += 1 if has_two_but_not_three?(pw) && never_decrease?(pw)
    end
    c
  end

  def has_two_adj_ints?(pw)
    str = pw.to_s
    (1..(pw.digits.size-2)).each do |i|
      return true if str[i] == str[i-1] || str[i] == str[i+1]
    end
    false
  end

  def has_two_but_not_three?(pw)
    str = pw.to_s
    (1..(pw.digits.size-2)).each do |i|
      if str[i] == str[i-1] && str[i] != str[i+1]
        if i == 1
          return true
        else
          if str[i] != str[i-2]
            return true
          end
        end
      end

      return true if str[i] == str[i+1] && str[i] != str[i-1] && i == 4
    end
    false
  end

  def never_decrease?(pw)
    str = pw.to_s
    (0..4).each do |i|
      return false if str[i] > str[i+1]
    end
    true
  end
end