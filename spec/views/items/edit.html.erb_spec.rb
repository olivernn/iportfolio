require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/edit.html.erb" do
  include ItemsHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project)
    assigns[:item] = @item = stub_model(Item,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/items/edit.html.erb"
    
    response.should have_tag("form[action=#{project_item_path(@project, @item)}][method=post]") do
    end
  end
end


