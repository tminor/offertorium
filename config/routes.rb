Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get 'users' => 'users#show'
      resources :users

      resources :offers

      resources :demographics
    end
  end
end
