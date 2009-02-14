require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/videos/index.html.erb" do
  include VideosHelper
  
  before(:each) do
    assigns[:project] = stub_model(Project)
    assigns[:videos] = [
      stub_model(Video),
      stub_model(Video)
    ]
  end

  it "should render list of videos" do
    render "/videos/index.html.erb"
  end
end
