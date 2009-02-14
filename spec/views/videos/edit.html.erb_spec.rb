require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/videos/edit.html.erb" do
  include VideosHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:video] = @video = stub_model(Video,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/videos/edit.html.erb"
    
    response.should have_tag("form[action=#{project_video_path(@project, @video)}][method=post]") do
    end
  end
end


