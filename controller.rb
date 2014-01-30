require_relative "fibonacci"
require_relative "view"

View.greet
nr1, nr2 = gets.chomp.gsub(" ", "").split(",")
View.show_users_input(nr1, nr2)
numbers = Fibonacci.new(nr1.to_i, nr2.to_i).get_all_numbers
if numbers.empty?
  View.tell_no_numbers_present
else
  View.give_numbers(numbers)
end
