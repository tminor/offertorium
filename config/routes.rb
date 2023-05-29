Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get 'users'        => 'users#show'
      get 'users/offers' => 'users#offers'
      resources :users

      resources :offers

      resources :demographics
    end
  end
end
