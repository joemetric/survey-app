ActionController::Routing::Routes.draw do |map|

  map.resources :pictures
  map.resources :completions
  map.resources :answers
  map.resources :surveys do |survey|
    survey.resources :questions
  end
  map.resource :user_session
  map.resources :users, :member => { :not_active => :get }

  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activation 'users/:id/activate/:key', :controller => "users", :action => "activate"

  map.root :controller => 'surveys'


  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
