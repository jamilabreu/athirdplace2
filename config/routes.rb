Athirdplace::Application.routes.draw do 
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks", registrations: "registrations", sessions: "sessions"}
  devise_scope :user do
    match "/users/sign_out" => "sessions#destroy"
  end  
  resources :users, only: [:index, :show]
  resources :communities, only: [:index]
  resources :posts
  resources :links
  resources :events
  match 'posts/new/preview', to: 'posts#preview', as: "preview_post"
  match 'posts/new/show_tags', to: 'posts#show_tags', as: "show_tags"
  resources :comments, only: [:new, :create, :show]
  resources :conversations, only: [:index, :show]
  resources :messages, only: [:new, :create]
  resources :subscriptions, only: [:index, :new, :create]
  match "", to: "users#index", constraints: lambda { |r| r.subdomain.present? && r.subdomain != "www" }
  root to: "users#home"
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
