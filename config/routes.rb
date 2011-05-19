ResearchMatch::Application.routes.draw do

  get  'courses_json'    => 'courses#json'
  get  'categories_json' => 'categories#json'
  get  'proglangs'       => 'proglangs#json'

  resources :pictures

  # Jobs
  scope '/jobs', :as => :jobs do
    get  '/activate/:id' => 'jobs#activate', :as => :activate
    get  '/search' => 'jobs#index', :as => :search
  end
  resources :jobs

  # Applics
  scope :applics do
    get  '/jobs/:job_id/apply' => 'applics#new', :as => :new_job_applic
    get  '/jobs/:job_id/doapply' => 'applics#create', :method => 'post', :as => :create_job_applic
    get  '/jobs/:job_id/applications' => 'applics#index', :as => :list_jobs_applics
    get  '/applications/:id' => 'applics#show', :as => :applic
    get  '/applications/:id/withdraw' => 'applics#destroy', :as => :destroy_applic
    get  '/applications/:id/resume' => 'applics#resume', :as => :applic_resume
    get  '/applications/:id/transcript'=>'applics#transcript', :as => :applic_transcript
  end # applics

  # Categories
  resources :categories

  # Documents
  resources :documents

  # Access control
  match '/logout' => 'sessions#destroy'
  match '/login'  => 'sessions#new'
  resources :session

  # Users
  resources :users
  get  '/dashboard' => 'dashboard#index'

  # Home
  get  '/' => 'home#index'


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
