class Generators::Rates

  attr_reader :begin_with, :end_with

  def initialize(part=nil)
    if part
      @begin_with = (part-1) * 333
      @end_with   = part * 333
    end
  end

  def generate
    (begin_with..end_with).each do |i|
      Rate.create!(made_on: Date.today - i, currency_code: "MDL", value: (0.1 + i/100 ))
    end
  end

  def generate_with_cache
    1000.times do |i|
      next if Rate.exists?(made_on: Date.today - i)
      Rate.create!(made_on: Date.today - i, currency_code: "MDL", value: (0.1 + i/100 ))
    end
  end
end
