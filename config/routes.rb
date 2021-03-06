ActionController::Routing::Routes.draw do |map|
  map.resources :profiles
  map.resources :contact
  
  # mapping items to project
  map.resources :projects do |project|
    project.resources :items, :collection =>  {:sort => :put}
  end
  
  map.resources :draft_projects, :member => {:publish => :put}
  map.resources :pages
 
  # Restful Authentication Rewrites
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.open_id_complete '/opensession', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.open_id_create '/opencreate', :controller => "users", :action => "create", :requirements => { :method => :get }
  
  # Restful Authentication Resources
  map.resources :users, :has_one => :profile
  
  map.resources :passwords
  map.resource :session
  
  # Home Page
  map.root :controller => 'projects', :action => 'index'
  
  # these will go to the pages controller, will be for /about or /cv etc
  map.static ':permalink', :controller => 'pages', :action => 'show'
  
  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
