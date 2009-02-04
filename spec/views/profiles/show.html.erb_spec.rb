require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/profiles/show.html.erb" do
  include ProfilesHelper
  
  before(:each) do
    assigns[:user] = stub_model(User)
    assigns[:profile] = @profile = stub_model(Profile)
  end

  it "should render attributes in <p>" do
    render "/profiles/show.html.erb"
  end
end

