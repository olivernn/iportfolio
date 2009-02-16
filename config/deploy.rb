set :application, "annacole.co.uk"
set :user, "admin"
# this is the old source on svn, now using github
# set :repository,  "http://onightin.svn.beanstalkapp.com/rails_projects/flatshare/"
set :repository, "git@github.com:olivernn/iportfolio.git"
set :branch, "movies"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git

set :runner, user
set :use_sudo, true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :port, 30000
set :deploy_to, "/home/admin/public_html/#{application}"


#makes sure only the workstation can connect to the repository
set :deploy_via, :copy

#this points to the ssh key since we called it something different
ssh_options[:keys] = %w(~/.ssh/key)
ssh_options[:port] = 30000

role :app, application
role :web, application
role :db, application, :primary => true

desc "Reload Nginx"
task :reload_nginx do
  sudo "/etc/init.d/nginx reload"
end
 
desc "Restart Thin"
task :restart_thin do
  sudo "/etc/init.d/thin restart"
end

desc "Create symlink to shared folder"
task :create_symlink do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  run "ln -nfs #{shared_path}/sources #{release_path}/public/system/sources"
end

desc "Backup the remote database and pictures to local"
namespace :backup do
  task :db do  
    filename = "iportfolio_production_#{Time.now.to_s.gsub(/ /, "_")}.sql.gz"
    server_filename = "/home/admin/tmp/#{filename}"
    local_filename = "/Users/Oliver/Documents/iportfolio/annacole.co.uk/db_backups/#{filename}"

    on_rollback { run "rm #{server_filename}" }

    run "mysqldump -u iportfolio -p iportfolio_production | gzip > #{server_filename}" do |ch, stream, out|
      ch.send_data "computer\n" if out =~ /^Enter password:/
    end
    #system `rsync #{user}@#{application}:#{filename} /Users/Oliver/Documents/rails_projects/LondonFlatmate.net`
    get server_filename, local_filename
    sudo "rm #{server_filename}"
  end
end

after "deploy:update_code", "create_symlink"
after "deploy", "deploy:cleanup"
after "deploy:cleanup", "reload_nginx"
after "reload_nginx", "restart_thin"