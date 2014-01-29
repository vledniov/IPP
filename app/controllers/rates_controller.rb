class RatesController < ApplicationController
  def index
  end

  def generate_rates
    Rate.destroy_all
    1000.times do |i|
      Rate.create!(made_on: Date.today - i, currency_code: "MDL", value: (0.1 + i/100 ))
    end
    redirect_to rates_path
  end

  def generate_rates_with_proxy
    Rate.destroy_all
    Generators::Rates.new(params[:part].to_i).generate
    redirect_to rates_path
  end

  def generate_caching_rates
    Generators::Rates.new.generate_with_cache
    redirect_to rates_path
  end
end
