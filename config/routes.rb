Blog::Application.routes.draw do
  root :to=> "serviceexecution/startup#index"

  match 'index' => 'serviceexecution/startup#index'
  match 'registration' => 'serviceexecution/registration', :as => :registration
  match 'auth_complete/:format' => 'serviceexecution/account#showuser', :as => :auth_complete

  namespace :uploader do
    resources :pictures do
      member do
        match :upload, :via=>[:get, :post]
        match :ischecked, :via=>[:get, :post]
        match :destroy_by_name, :via=>[:get, :post]
      end
    end
  end

  namespace :serviceexecution do
    match 'web_giude' => 'menu#web_guide', :as => :web
    match 'android_giude' => 'menu#android_guide', :as => :android
    match 'fordevelopers' => 'menu#fordevelopers'
    match 'encrypt' => 'menu#encrypt'
    match 'author' => 'menu#author'
    resources :startup
    resources :account do
      member do
        match :request_file_size, :via=>[:get, :post]
        match :download, :via=>[:get, :post]
        match :showuser, :via=>[:get, :post]
        match :showprogress, :via=>[:get, :post]
      end
    end
  end

  resources :posts do
    match :showfirst, :via=>[:get, :post], :on=>:member
  end
  resources :users
  resources :user_sessions do
    member do
      match :logout, :via=>[:get, :post]
      match :create_android, :via=>[:get, :post]
    end
  end
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
  # match ':controller(/:action(/:id(.:format)))'
end
