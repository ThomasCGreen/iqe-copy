Rails.application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'iqe#index'
  get 'create' => 'create#index'
  post 'create' => 'create#save'
  patch 'create' => 'create#save'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  get 'taketest/:license_key' => 'qtest#index', as: :qtest
  patch 'taketest/:license_key' => 'qtest#save'

  get 'taketest' => 'license#no_license'
  post 'taketest' => 'license#license'

  get 'invalid_license' => 'qtest#invalid'
  get 'multi_license_finished' => 'qtest#multi_license_finished'
  get 'path0' => 'qtest#path0'

  get 'promo' => 'promo#index'
  post 'promo' => 'promo#save'
  patch 'promo' => 'promo#save'

  get 'group' => 'iqe#group'
  get 'about' => 'iqe#about'
  get 'contact' => 'iqe#contact'

  get 'report/:password' => 'report#index'
  get 'invalid_password' => 'report#invalid_password'

  get 'question' => 'question#index'

  get 'trigger' => 'trigger#index'

  get 'weight' => 'weight#index'

  get 'innovation' => 'innovation#index'

  get 'version' => 'version#index'

  get 'dump/:password' => 'dump#index'

  get '*path' => 'iqe#unknown'

  # Example of named route that can be invoked with
  # purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to
  # controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
