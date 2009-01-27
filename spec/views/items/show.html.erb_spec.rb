require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/show.html.erb" do
  include ItemsHelper
  
  before(:each) do
    assigns[:project] = stub_model(Project)
    assigns[:item] = @item = stub_model(Item)
  end

  it "should render attributes in <p>" do
    render "/items/show.html.erb"
  end
end

