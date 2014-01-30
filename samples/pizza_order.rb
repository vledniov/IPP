class Pizza < Shoes
  $name        = ""
  $cheese_list = ["Feta", "Parmesan", "Mozarella", "Dor Blue", "Edam", "Branza"]
  $meat_list   = ["Bacon", "Prosciutto", "Salami", "Chicken Breasts", "Ham"]
  $veggie_list = ["Fresh Mushrooms", "Smoked Mushrooms", "Red onion", "Tomatoes", "Garlic", "Rucola", "Marinated Gogoshars", "Corn", "Parsley", "Chilli pepper"]
  $price       = 0

  url "/",         :index
  url "/order",    :make_order
  url "/confirm",  :confirm
  url "/finalize", :finalize

  def index
    caption "Input name: ", stroke: black
    username = edit_line
    button("Order Pizza!") do
      $name = username.text
      visit "/order"
    end
  end

  def make_order
    $price = 0
    cheese = $cheese_list
    meat   = $meat_list
    veggie = $veggie_list
    stack do
      para "Welcome, #{$name}, here are the engredients you can choose from"
      para "The cheese list:"

      cheese.map! do |name|
        flow { @c = check; para name }
        [@c, Math.sqrt(name.size)*12]
      end

      para "The meat list:"
      meat.map! do |name|
        flow { @m = check; para name }
        [@m, Math.sqrt(name.size)*42]
      end

      para "The vegetables list:"
      veggie.map! do |name|
        flow { @v = check; para name }
        [@v, Math.sqrt(name.size)*9]
      end

      button "See price" do
        if cheese.map{|v,price| v.checked? }.count(true) > 3
          alert("More than 3 cheeses were selected")
          next
        end

        if meat.map{|v,price| v.checked? }.count(true) > 2
          alert("More than 2 meat pieces were selected")
          next
        end

        if veggie.map{|v,price| v.checked? }.count(true) > 5
          alert("More than 5 vegetables were selected")
          next
        end

        $price += cheese.map{|v,price| price if v.checked?}.reject{|v| v.nil?}.inject(:+).to_f
        $price +=   meat.map{|v,price| price if v.checked?}.reject{|v| v.nil?}.inject(:+).to_f
        $price += veggie.map{|v,price| price if v.checked?}.reject{|v| v.nil?}.inject(:+).to_f
        visit "/confirm"
      end
    end
  end

  def confirm
    stack do
      para "So, here is your result, #{$name}:"
      para "The price you will have to pay is: #{$price}"
      button("Back")    {visit "/order"}
      button("Finalize"){visit "/finalize"}
    end
  end

  def finalize
    para "Your order ID is: #{($name * 1024).length % 1000}"
  end
end

Shoes.app width: 640, height: 700, title: "Pizza Adriano"
