require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/videos/new.html.erb" do
  include VideosHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:video] = stub_model(Video,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/videos/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", project_videos_path(@project)) do
    end
  end
end


