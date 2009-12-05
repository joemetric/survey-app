ActionController::Routing::Routes.draw do |map|

  map.resources :maintenances
  map.resources :pictures
  map.resources :completions
  map.resources :answers
  map.resources :surveys, 
    :member => {:reward => :get, :progress_graph => :get},
    :collection => { :copy => :post, :pricing => :get, :activate => :post, :progress => :get, :reports => :get, :update_pricing => :any } do |survey|
    survey.resources :questions
    survey.resources :restrictions
    survey.resources :replies
  end
  map.resources :reports, :member => {:csv => :get}
  map.resources :questions, :collection => { :choose_type => :post } do |questions|
    questions.resources :answers
  end
  map.resources :restrictions, :collection => { :choose_type => :post }
  map.resource :user_session

  map.current_user_formatted "/users/current.:format", :controller => "users", :action => "show_current"
  map.resources :users, :member => { :not_active => :get }, :collection => { :forgot_password => :get, :send_reset => :post, :reset_password => :get, :incomes => :get, :races => :get, :educations => :get, :occupations => :get, :martial_statuses => :get } do |user|
    user.resources :transfers, :collection => { :pending => :get, :paid => :get }
  end

  map.namespace(:admin) do |admin|
    admin.resource  :admin_session
    admin.resources :surveys, :member => { :publish => :put, :reject => :put }, :collection => { :pending => :get } 
    admin.resources :packages
    admin.resources  :clients, :collection => { :warn => :post}
    admin.resources :users,
      :member => {:reset_password => :any, :change_type => :post},
      :collection => {:blacklist => :put}
    admin.resources :maintenances
  end
  
  map.resources :dashboard, :path_prefix => 'survey', :controller => "admin/dashboards",
    :collection => { :demographic_distribution => :post, :survey_distribution => :post, :financial_distribution => :post} 
  
  map.resources :payments,
    :member => {:authorize => :get, :capture => :get, :cancel => :get, :refund => :get}
  
  map.with_options :controller => 'payments' do |p|
    p.account_history '/account-history', :action => 'index'
  end
  
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
