require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/profiles/index.html.erb" do
  include ProfilesHelper
  
  before(:each) do
    assigns[:user] = stub_model(User)
    assigns[:profiles] = [
      stub_model(Profile),
      stub_model(Profile)
    ]
  end

  it "should render list of profiles" do
    render "/profiles/index.html.erb"
  end
end
