VisibleTweets::Application.routes.draw do
  resources :subscriptions, :except => [:update, :edit, :show] do
    resources :tweets, :only => [:index] do
      collection do
        get :export
      end
    end
  end
  root to: "subscriptions#index"
end
