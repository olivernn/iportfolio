require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/videos/show.html.erb" do
  include VideosHelper
  
  before(:each) do
    assigns[:project] = stub_model(Project)
    assigns[:video] = @video = stub_model(Video)
  end

  it "should render attributes in <p>" do
    render "/videos/show.html.erb"
  end
end

