class PageSweeper < ActionController::Caching::Sweeper
  observe Page
  
  def after_update(page)
    expire_page_cache(page)
  end
  
  def after_create(page)
    expire_page_cache(page)
  end
  
  def after_destroy(page)
    expire_page_cache(page)
  end
  
  private
  def expire_page_cache(page)
    # expire the index page action cache
    expire_fragment(%r{index.cache})
    
    expire_action :controller => :page, :action => :show, :id => page 
  end
end