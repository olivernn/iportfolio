require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/new.html.erb" do
  include ItemsHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:item] = stub_model(Item,
      :new_record? => true
    )
  end

  it "should render new form" do
    render "/items/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", project_items_path(@project)) do
    end
  end
end


