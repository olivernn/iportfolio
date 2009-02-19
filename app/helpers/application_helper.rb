module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = "Anna Cole - " + str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  
  def render_item(item, project)
    if item.class.to_s == "Image"
      render :partial => 'images/image', :locals => {:image => item, :project => project}
    else
      # it must be a video
      render :partial => 'videos/video', :locals => {:video => item, :project => project}
    end
  end
  
  # this method will display the profile attributes if they exist
  def display_populated_attributes(profile)
    html = String.new
    ['location', 'phone', 'freelance', 'skills'].each do |field|
      if profile.attributes[field]
        html << "<li><strong>#{field.humanize}:</strong> #{profile.attributes[field]}</li>" unless profile.attributes[field].empty?
      end
    end
    html
  end
    
  # methods that set the meta tags for the page
  #displays a nice page title easily
  def meta_title(text)
    content_for(:title) { text }
  end
  
  #allows us to specify the keywords for a page
  def meta_keywords(keywords)
    content_for(:keywords) { keywords }
  end
  
  #allows us to specify the description for a page
  def meta_description(description)
    content_for(:description) { description }
  end
end
