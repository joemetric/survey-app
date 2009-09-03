ActionController::Routing::Routes.draw do |map|

  map.resources :pictures
  map.resources :completions
  map.resources :answers

  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil

  map.resources :users, :member => { :not_active => :get }
  map.resource :user_session

  map.root :controller => 'surveys'

  map.resources :surveys do |survey|
    survey.resources :questions
  end

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
