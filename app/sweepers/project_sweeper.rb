class ProjectSweeper < ActionController::Caching::Sweeper
  observe Project
  
  def after_update(project)
    expire_project_cache(project)
  end
  
  def after_create(project)
    expire_project_cache(project)
  end
  
  def after_destroy(project)
    expire_project_cache(project)
  end
  
  private
  def expire_project_cache(project)
    # expire the index page action cache
    expire_fragment(%r{index.cache})
    
    expire_action :controller => :project, :action => :index
    expire_action :controller => :project, :action => :show, :id => project 
    expire_action :controller => :draft_project, :action => :index
  end
end