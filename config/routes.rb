IPP::Application.routes.draw do

  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get '/' => "downloads#index"
    get '/second_page' => "downloads#second_page"
  end

  match "*path", to: redirect("/#{I18n.default_locale}/%{path}"), via: [:get, :post]
  match "", to: redirect("/#{I18n.default_locale}"), via: [:get, :post]
end
