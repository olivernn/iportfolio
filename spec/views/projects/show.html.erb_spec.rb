require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/show.html.erb" do
  include ProjectsHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
  end

  it "should render attributes in <p>" do
    render "/projects/show.html.erb"
  end
end

