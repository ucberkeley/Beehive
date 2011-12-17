ResearchMatch::Application.routes.draw do


  get "contact_us/contact", :as => :contact_us
  post "contact_us/send_email", :as => :feedback_email_link

  resources :pictures

  # Jobs
  scope '/jobs', :as => :jobs do
    get  '/search' => 'jobs#index', :as => :search
  end

  resources :jobs do
    member do 
      get 'activate'
      get 'delete'
      get 'resend_activation_email'
      get 'watch'
      get 'unwatch'
    end
  end

  # Applics
  scope :applics do
    get  '/jobs/:job_id/apply' => 'applics#new', :as => :new_job_applic
    post '/jobs/:job_id/apply' => 'applics#create', :as => :create_job_applic
    get  '/jobs/:job_id/applications' => 'applics#index', :as => :list_jobs_applics
    get  '/applications/:id' => 'applics#show', :as => :applic
    get  '/applications/:id/withdraw' => 'applics#destroy', :as => :destroy_applic
    #get  '/applications/:id/resume' => 'applics#resume', :as => :applic_resume
    #get  '/applications/:id/transcript'=>'applics#transcript', :as => :applic_transcript
  end # applics

  # Documents
  match '/documents/:id/destroy' => 'documents#destroy', :as => :destroy_document
  resources :documents

  # Access control
  match '/logout' => 'user_sessions#destroy'
  match '/login'  => 'user_sessions#new'

  # Users
  resources :users
  get  '/dashboard' => 'dashboard#index', :as => :dashboard
  get  '/profile'   => 'users#profile', :as => :profile

  # Home
  get  '/' => 'home#index', :as => :home

  # Autocomplete routes
  get '/categories/json' => 'categories#json', :as => :categories_json
  get '/courses/json' => 'courses#json', :as => :courses_json
  get '/proglangs/json' => 'proglangs#json', :as => :proglangs_json

  namespace :admin do
    scope 'faculties', :as => :faculties do
      get  '/' => 'faculties#index', :as => ''
      put  '/:id' => 'faculties#update', :as => :update
      delete '/:id' => 'faculties#destroy', :as => :destroy
      post '/' => 'faculties#create', :as => :create
    end
  end

  root :to => 'home#index'

  match '/test_error(/:code)' => 'application#test_exception_notification'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
