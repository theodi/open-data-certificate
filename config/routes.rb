OpenDataCertificate::Application.routes.draw do

  mount Surveyor::Engine => "/surveys", :as => "surveyor"
  Surveyor::Engine.routes.draw do
    match '/:response_set_code/attained_level', :to => 'surveyor#attained_level', :as => 'view_my_survey_attained_level', :via => :get
    match '/:response_set_code/requirements', :to => 'surveyor#requirements', :as => 'view_my_survey_requirements', :via => :get
    match '/:survey_code/:response_set_code/continue', :to => 'surveyor#continue', :as => 'continue_my_survey', :via => :get
  end
  post 'surveys', :to => 'application#start_questionnaire', :as => 'non_authenticated_start_questionnaire'

  resources :datasets do
    put 'start_questionnaire'
  end

  resources :certificates
  post '/certificates/search', :to => 'certificates#search', :as => 'search_certificates'

  devise_for :users, skip: :registration
  devise_scope :user do
    resource :registration,
             only: [:new, :create, :edit, :update],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'devise/registrations',
             as: :user_registration do
      get :cancel
    end
  end

  # 'Static' pages managed by HighVoltage here...
  get 'about' => 'high_voltage/pages#show', :id => 'about'
  get 'contact' => 'high_voltage/pages#show', :id => 'contact'
  get 'terms' => 'high_voltage/pages#show', :id => 'terms'

  root :to => 'application#home'

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
