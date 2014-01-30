class View
  def self.greet
    puts "Please, enter 2 numbers separated by comma, and I will give you all the fibonacci numbers between them"
  end

  def self.show_users_input(nr1, nr2)
    puts "You introduced the number #{nr1} and #{nr2}. Please wait, processing data..."
  end

  def self.give_numbers(array)
    puts "So, the numbers you want are:"
    array.each{|num| puts num}
  end

  def self.tell_no_numbers_present
    puts "There are no fibonacci numbers in the sequence"
  end
end
