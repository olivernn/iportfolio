class SitemapController < ApplicationController
  # responds to a GET /sitemap.xml

  def sitemap
    @projects = Project.active
    @pages = Page.find(:all)
    
    respond_to do |format|
      format.xml # { render :xml => [@pages, @projects], :layout => false }
    end
  end
end