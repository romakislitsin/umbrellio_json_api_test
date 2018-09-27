Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/new_post', to: 'posts#create'
      post '/estimate', to: 'posts#estimate'
      get  '/index',    to: 'posts#index'
      get  '/by_ip',    to: 'posts#by_ip'
    end
  end
end
