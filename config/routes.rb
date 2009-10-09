ActionController::Routing::Routes.draw do |map|
  map.resources :maintenances


  map.resources :pictures
  map.resources :completions
  map.resources :answers
  map.resources :surveys, :collection => { :pricing => :get, :activate => :post, :progress => :get } do |survey|
    survey.resources :questions
    survey.resources :restrictions
  end
  map.resources :questions, :collection => { :choose_type => :post }
  map.resources :restrictions
  map.resource :user_session

  map.current_user_formatted "/users/current.:format", :controller => "users", :action => "show_current"
  map.resources :users,
    :member => { :not_active => :get },
    :collection => { :forgot_password => :get, :send_reset => :post, :reset_password => :get }

  map.namespace(:admin) do |admin|
    admin.resource :admin_session
    admin.resources :surveys, :member => { :publish => :put, :reject => :put }, :collection => { :pending => :get } 
    admin.resources :packages
    admin.resources :users
    admin.resources :maintenances
  end
  
  map.resources :payments, 
    :member => {:authorize => :get, :capture => :get, :cancel => :get, :refund => :get}

  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.activation 'users/:id/activate/:key', :controller => "users", :action => "activate"
  map.reset_password 'users/:id/reset_password/:key', :controller => "users", :action => "reset_password"

  map.root :controller => 'surveys'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
