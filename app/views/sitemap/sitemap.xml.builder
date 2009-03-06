xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  unless @projects.empty?
    @projects.each do |project|
      xml.url  do
        xml.loc project_url(project)
        xml.lastmod project.updated_at.to_date
      end
      project.items.each do |item|
        xml.url do
          xml.loc project_item_url(project, item)
          xml.lastmod item.updated_at.to_date
        end
      end
    end
  end
  
  @pages.each do |page|
    xml.url do
      xml.loc page_url(page)
      xml.lastmod page.updated_at.to_date
    end
  end
  
  xml.url do
    xml.loc root_url
  end
end