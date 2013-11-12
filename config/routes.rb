OpenDataCertificate::Application.routes.draw do

  mount Surveyor::Engine => "/surveys", :as => "surveyor"
  Surveyor::Engine.routes.draw do
    match '/:survey_code/:response_set_code/requirements', :to => 'surveyor#requirements', :as => 'view_my_survey_requirements', :via => :get
    match '/:survey_code/:response_set_code/continue', :to => 'surveyor#continue', :as => 'continue_my_survey', :via => :get
    match '/:survey_code/:response_set_code/repeater_field/:question_id/:response_index/:response_group', :to => 'surveyor#repeater_field', :as => 'repeater_field', :via => :get
    get '/:survey_code/:response_set_code/save_and_finish', :to => 'surveyor#force_save_questionnaire', :as => 'force_save_questionnaire'

    resources :jurisdictions, :only => :index

    # have a response_set resource for deleting for now, have
    # a feeling that this could include a couple of the other
    # routes,  though try it out for now
    resources :response_sets, :only => :destroy do
      post :publish, on: :member
      post :autofill, on: :member
      post :resolve, on: :member
    end

  end
  post 'surveys', :to => 'main#start_questionnaire', :as => 'non_authenticated_start_questionnaire'
  get 'start_certificate', :to => 'main#start_questionnaire', :as => 'authenticated_start_questionnaire'

  resources :datasets do
    put 'start_questionnaire'
    get 'certificates/latest', to: 'certificates#latest', as: 'latest'
    get 'certificates/latest/:type', to: 'certificates#latest', as: 'latest'
    get :typeahead, on: :collection
    get :admin, on: :collection

    resources :certificates, :only => [:show] do
       member do
         get 'improvements', to: 'certificates#improvements', as: 'improvements'
         get 'embed', to: 'certificates#embed', as: 'embed'
         get 'badge', to: 'certificates#badge', as: 'badge'
         post 'verify'
       end
    end
  end

  resources :transfers, :only => [:create, :destroy] do
    get :claim,  on: :member
    put :accept, on: :member
  end

  # Certificate legacy redirects
  get '/certificates/:id', to: 'certificates#legacy_show'
  get '/certificates/:id/:type', to: 'certificates#legacy_show'

  # User dashboard
  get 'users/dashboard', to: 'datasets#dashboard', as: 'dashboard'
  get 'dashboard', to: redirect('/users/dashboard')

  devise_for :users, skip: :registration, :controllers => {sessions: 'sessions'}
  devise_scope :user do
    get '/users/:id/edit', to: 'registrations#edit', as: 'edit_user_registration'
    get '/users/edit', to: 'registrations#redirect'
    resource :registration,
             only: [:new, :create, :update],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'registrations',
             as: :user_registration do
      get :cancel
    end
  end

  # Get badge for a url
  get 'get_badge' => 'certificates#get_badge'

  # 'Static' pages managed by HighVoltage here...
  get 'about' => 'pages#show', :id => 'about'
  get 'contact' => 'pages#show', :id => 'contact'
  get 'terms' => 'pages#show', :id => 'terms'
  get 'markdown' => 'pages#show', :id => 'markdown_help', as: :markdown_help

  # comment pages
  get 'comment' => 'main#comment', as: :comment
  get 'discussion' => 'main#discussion', as: :discussion # general/site-wide

  get 'has_js' => 'main#has_js'

  # temporary measure - until #397 is resolved
  get 'clear_cache' => 'main#clear_cache', :via => :post

  # (public) stats about the application
  get 'status.csv' => 'main#status_csv'
  get 'status' => 'main#status'
  get 'status/response_sets' => 'main#status_response_sets'
  get 'status/events' => 'main#status_events'

  root :to => 'main#home'

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
