VisibleTweets::Application.routes.draw do
  resources :subscriptions
  root to: "subscriptions#index"
end
