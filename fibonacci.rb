class Fibonacci
  attr_reader :nr1, :nr2

  def initialize(nr1, nr2)
    @nr1 = nr1
    @nr2 = nr2
  end

  def get_all_numbers
    array = []
    (nr1..nr2).each do |num|
      array << num if is_fibonacci?(num)
    end
    array
  end

private

  def is_fibonacci?(num)
    arr = [0, 1]
    while num > arr.last
      x, y = arr.pop(2)
      arr.push(x, y, x + y)
    end

    return true if num == arr.last
    return false
  end
end
