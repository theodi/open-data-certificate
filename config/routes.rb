OpenDataCertificate::Application.routes.draw do
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Surveyor::Engine => "/surveys", :as => "surveyor"
  Surveyor::Engine.routes.draw do
    get '/:survey_code/:response_set_code/requirements', :to => 'surveyor#requirements', :as => 'view_my_survey_requirements'
    post '/:survey_code/:response_set_code/continue', :to => 'surveyor#continue', :as => 'continue_my_survey'
    get '/:survey_code/:response_set_code/repeater_field/:question_id/:response_index/:response_group', :to => 'surveyor#repeater_field', :as => 'repeater_field'
    get '/:survey_code/:response_set_code/save_and_finish', :to => 'surveyor#force_save_questionnaire', :as => 'force_save_questionnaire'

    get  '/:survey_code/:response_set_code/start', :to => 'surveyor#start', as: 'start'
    get '/:survey_code/:response_set_code', :to => redirect('/surveys/%{survey_code}/%{response_set_code}/take', status: 302)

    resources :jurisdictions, :only => :index

    # have a response_set resource for deleting for now, have
    # a feeling that this could include a couple of the other
    # routes,  though try it out for now
    resources :response_sets, :only => :destroy do
      post :publish, on: :member
      post :autofill, on: :member
      post :resolve, on: :member
      put  :start, on: :member
    end

  end
  post 'surveys', :to => 'main#start_questionnaire', :as => 'non_authenticated_start_questionnaire'
  get 'start_certificate', :to => 'main#start_questionnaire', :as => 'authenticated_start_questionnaire'
  get 'jurisdictions', :to => 'jurisdictions#index'

  # Get certificate from dataset url
  get '/datasets(/:type)' => 'certificates#certificate_from_dataset_url',
                     :constraints => lambda { |request| request.params[:datasetUrl].present? }

  resources :datasets do
    put 'start_questionnaire'
    post 'certificates',  to: 'datasets#update_certificate', as: 'update_certificate'
    post 'regenerate', to: 'datasets#regenerate', as: 'regenerate_certificate'
    get :typeahead, on: :collection
    get :admin, on: :collection
    get :schema, on: :collection
    get :info, on: :collection

    collection do
      get 'status/:certificate_generator_id', to: 'datasets#import_status', as: 'status'
    end

    resource :certificate, as: 'latest_certificate', only: [:show] do
      get 'embed'
      get 'badge'
    end

    resources :certificates, :only => [:show, :update] do
       member do
         get 'improvements', to: 'certificates#improvements', as: 'improvements'
         get 'progress', to: 'certificates#progress'
         get 'embed', to: 'certificates#embed', as: 'embed'
         get 'badge', to: 'certificates#badge', as: 'badge'
         post 'verify'
         post :report
       end
    end
  end

  resources :transfers, :only => [:create, :destroy] do
    get :claim,  on: :member
    put :accept, on: :member
  end

  resources :claims, :except => :destroy do
    post :approve, on: :member
    post :deny, on: :member
  end

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
  get 'get_badge' => 'certificates#certificate_from_dataset_url'

  # 'Static' pages managed by HighVoltage here...
  get 'about' => 'pages#show', :id => 'about'
  get 'overview' => 'pages#show', :id => 'overview'
  get 'contact' => 'pages#show', :id => 'contact'
  get 'terms' => 'pages#show', :id => 'terms'
  get 'cookie-policy' => 'pages#show', :id => 'cookie_policy'
  get 'privacy-policy' => 'pages#show', :id => 'privacy_policy'
  get 'markdown' => 'pages#show', :id => 'markdown_help', as: :markdown_help
  get 'using-the-marks' => 'pages#show', :id => 'branding'

  # comment pages
  get 'comment' => 'main#comment', as: :comment
  get 'discussion' => 'main#discussion', as: :discussion # general/site-wide

  get 'has_js' => 'main#has_js'

  # temporary measure - until #397 is resolved
  get 'clear_cache' => 'main#clear_cache', :via => :post

  # (public) stats about the application
  get 'status' => 'main#status'
  get 'status/head' => 'main#git_head'
  get 'status/response_sets' => 'main#status_response_sets'
  get 'status/events' => 'main#status_events'
  get 'legacy_stats.csv' => 'main#legacy_stats', format: 'csv'
  get 'embed_stats.csv' => 'embed_stats#index', format: 'csv', as: :embed_stats

  resources :campaigns do
    post 'rerun', to: 'campaigns#rerun', as: 'rerun'
    post 'schedule', to: 'campaigns#schedule', as: 'scheduled_rerun'
  end

  # private stats
  get 'status/published_certificates.csv' => 'main#published_certificates'
  get 'status/all_certificates.csv' => 'main#all_certificates'

  # Admin section
  get 'admin' => 'admin#index'
  get 'admin/users/:user_id' => 'admin#users', as: 'admin_users'
  get 'admin/typeahead' => 'admin#typeahead'

  root :to => 'main#home'

  # Certificate legacy redirects
  get '/certificates/:id', to: 'certificates#legacy_show'
  get '/certificates/:id/:type', to: 'certificates#legacy_show'

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
