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
    # expire the entire cache since the changes to page headings are displayed everywhere!
    expire_fragment(%r{.})
  end
end