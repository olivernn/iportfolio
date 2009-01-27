require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/index.html.erb" do
  include ItemsHelper
  
  before(:each) do
    assigns[:project] = stub_model(Project)
    assigns[:items] = [
      stub_model(Item),
      stub_model(Item)
    ]
  end

  it "should render list of items" do
    render "/items/index.html.erb"
  end
end
