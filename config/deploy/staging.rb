#############################################################
#	Application
#############################################################

set :application, "annacole.co.uk"
set :deploy_to, "/home/admin/public_html/#{application}"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:keys] = %w(~/.ssh/saturn)
ssh_options[:port] = 40000
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production"

#############################################################
#	Servers
#############################################################

set :user, "admin"
set :domain, "206.253.168.144"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Git
#############################################################

set :scm, :git
set :branch, "movies"
# set :scm_user, 'bort'
# set :scm_passphrase, "PASSWORD"
set :repository, "git@github.com:olivernn/iportfolio.git"
set :deploy_via, :copy
set :runner, user
set :use_sudo, true

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
    production:    
      adapter: mysql
      encoding: utf8
      username: iportfolio
      password: computer
      database: iportfolio_production
      host: localhost
    EOF
    
    put db_config, "#{release_path}/config/database.yml"

    #########################################################
    # Uncomment the following to symlink an uploads directory.
    # Just change the paths to whatever you need.
    #########################################################
    
    desc "Create symlink to shared folder"
    task :create_symlink do
      run "ln -nfs #{shared_path}/sources #{release_path}/public/system/sources"
    end
  end
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  after "deploy", "deploy:cleanup"
end
