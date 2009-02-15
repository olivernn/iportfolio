class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  include RoleRequirementSystem
  
  # including everything that is needed for the sidebar
  before_filter :sidebar
  
  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06', :except => :sort
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  
  protected
  
  # check whether we should be using the cached action or not
  def do_caching?
    !logged_in? && flash.empty?
  end
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
  
  def sidebar
    unless request.xhr?
      unless fragment_exist?(:controller => request.parameters[:controller],
                             :action => request.parameters[:action],
                             :id => request.parameters[:id])  
        @user = Role.find_by_name('owner').users.first
        @profile = @user.profile unless @user.nil?
        @pages = Page.find(:all)
      end
    end
  end
end

