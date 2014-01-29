class RatesController < ApplicationController
  def index
    @time = params[:time]
  end

  def generate_rates
    Rate.destroy_all
    time_now = Time.now
    1000.times do |i|
      Rate.create!(made_on: Date.today - i, currency_code: "MDL", value: (0.1 + i/100 ))
    end
    time_then = Time.now
    redirect_to rates_path(time: (time_then - time_now).seconds)
  end

  def generate_rates_with_proxy
    Rate.destroy_all
    time_now = Time.now
    Generators::Rates.new(params[:part].to_i).generate
    time_then = Time.now
    redirect_to rates_path(time: (time_then - time_now).seconds)
  end

  def generate_caching_rates
    time_now = Time.now
    Generators::Rates.new.generate_with_cache
    time_then = Time.now
    redirect_to rates_path(time: (time_then - time_now).seconds)
  end
end
