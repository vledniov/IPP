IPP::Application.routes.draw do
  root to: "rates#index"
  resources :rates, only: :index do
    collection do
      [:generate_rates, :generate_rates_with_proxy, :generate_caching_rates].each do |route|
        post route
      end
    end
  end

  resources :games, only: :index do
    collection do
      post :score
      get  :results
    end
  end
end
