OpenDataCertificate::Application.routes.draw do
  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  scope '/:locale', constraints: {locale: Regexp.union(I18n.available_locales.map(&:to_s))} do
    root :to => 'main#home'

    # 'Static' pages managed by HighVoltage here...
    get 'privacy-policy' => 'pages#show', id: 'privacy_policy', as: 'privacy_policy'
    get 'cookie-policy' => 'pages#show', id: 'cookie_policy', as: 'cookie_policy'
    get 'terms' => 'pages#show', id: 'terms', as: 'terms_page'
    get 'about' => 'pages#show', id: 'about', as: 'about_page'
    get 'about/how' => 'pages#show', id: 'how_to_get_certificates', as: 'how_to_get_certificates'
    get 'about/badgelevels' => 'pages#show', id: 'badge_levels', as: 'badge_levels_page'
    get 'about/whatyouneed' => 'pages#show', id: 'what_you_need', as: 'what_you_need_page'
    get 'overview', to: redirect('/%{locale}/about/whatyouneed')
    get 'faq', to: 'pages#show', id: 'faq', as: 'faq_page'
    get 'contact' => 'pages#show', id: 'contact', as: 'contact_page'
    get 'markdown' => 'pages#show', id: 'markdown_help', as: 'markdown_help'
    get 'using-the-marks' => 'pages#show', id: 'branding', as: 'branding_page'
    get 'autocertification' => 'pages#show', id: 'autocertification', as: 'autocertification'

    scope '/surveys' do
      # Redirect old URLs that include a jurisdiction (survey_code)
      match '/:survey_code/:response_set_code/(*path)', to: redirect('/%{locale}/surveys/%{response_set_code}/%{path}'), constraints: {survey_code: /[a-z]{2}/}

      get '/:response_set_code/take', to: 'surveyor#edit', as: 'edit_my_survey'
      put '/:response_set_code', to: 'surveyor#update', as: 'update_my_survey'

      get '/:response_set_code/requirements', :to => 'surveyor#requirements', :as => 'view_my_survey_requirements'
      post '/:response_set_code/continue', :to => 'surveyor#continue', :as => 'continue_my_survey'
      get '/:response_set_code/repeater_field/:question_id/:response_index/:response_group', :to => 'surveyor#repeater_field', :as => 'repeater_field'

      get '/:response_set_code/start', :to => 'surveyor#start', as: 'survey_start'

      resources :jurisdictions, :only => :index

      # have a response_set resource for deleting for now, have
      # a feeling that this could include a couple of the other
      # routes,  though try it out for now
      resources :response_sets, only: :destroy do
        post :publish, on: :member
        post :autofill, on: :member
        post :resolve, on: :member
        put  :start, on: :member
      end

      # Moved as the last rule in the scope so it doesn't catch 'jurisdictions#index', for example.
      get '/:response_set_code', :to => redirect('/%{locale}/surveys/%{response_set_code}/take', status: 302)
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
    get '/users/sign_out', to: redirect('/')
  end

  # Get badge for a url
  get 'get_badge' => 'certificates#certificate_from_dataset_url'

  # comment pages
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

  put 'campaigns/endpoint_check', to: 'campaigns#endpoint_check', as: 'campaign_endpoint_check'
  put 'campaigns/precheck', to: 'campaigns#precheck', as: 'campaign_precheck'
  get 'campaigns/template_typeahead', to: 'campaigns#template_typeahead', as: 'template_typeahead'

  resources :campaigns do
    post 'rerun', to: 'campaigns#rerun', as: 'rerun'
    post 'schedule', to: 'campaigns#schedule', as: 'scheduled_rerun'
    post 'queue_update', to: 'campaigns#queue_update', as: 'queue_update'
  end

  # private stats
  get 'status/published_certificates.csv' => 'main#published_certificates'
  get 'status/all_certificates.csv' => 'main#all_certificates'

  # Admin section
  get 'admin' => 'admin#index'
  get 'admin/users/:user_id' => 'admin#users', as: 'admin_users'
  get 'admin/typeahead' => 'admin#typeahead'

  # Certificate legacy redirects
  get '/certificates/:id', to: 'certificates#legacy_show'
  get '/certificates/:id/:type', to: 'certificates#legacy_show'

  # Flowchart
  get 'flowchart' => 'flowcharts#show'

  get 'status/ping' => 'main#ping'

  post :change_locale, to: 'locale#change_locale'

  match '(*path)', to: 'locale#redirect_to_locale', constraints: ->(request) {
    !request.params[:path] || !request.params[:path].start_with?(*I18n.available_locales.map(&:to_s))
  }
end
