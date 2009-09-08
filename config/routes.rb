ActionController::Routing::Routes.draw do |map|

  map.resources :pictures
  map.resources :completions
  map.resources :answers
  map.resources :surveys do |survey|
    survey.resources :questions
  end
  map.resource :user_session

  map.resources :users, 
    :member => { :not_active => :get }, 
    :collection => { :forgot_password => :get, :send_reset => :post, :reset_password => :get }

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
