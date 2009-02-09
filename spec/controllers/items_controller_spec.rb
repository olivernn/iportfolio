require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do

  before(:each) do
    controller.stub!(:login_required).and_return(true)
    controller.stub!(:sidebar).and_return(true)
  end

  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs.reverse_merge(:items => mock('Array of Items')))
  end
  
  before(:each) do
    Project.stub!(:find).with("1").and_return(mock_project)
  end
  
  describe "scoping the actions to a project" do
    it "should expose the project as @project" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      get :index, :project_id => "37"
      assigns[:project].should == mock_project
    end
    
    describe "handling a un-recognized project id" do
      it "should issue a warning and redirect to projects index" do
        Project.stub!(:find).with("99").and_raise(ActiveRecord::RecordNotFound)
        get :index, :project_id => "99"
        response.should redirect_to(projects_url)
      end
    end
  end
    
  describe "responding to GET index" do
    it "should expose all items as @items" do
      mock_project.should_receive(:items).with(no_args).and_return([mock_item])
      get :index, :project_id => "1"
      assigns[:items].should == [mock_item]
    end

    describe "with mime type of xml" do
      it "should render all items as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_project.should_receive(:items).with(no_args).and_return(items = mock("Array of Items"))
        items.should_receive(:to_xml).and_return("generated XML")
        get :index, :project_id => "1"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested item" do
      mock_project.items.should_receive(:find).with("37").and_return(mock_item)
      mock_item.should_receive(:destroy)
      delete :destroy, :id => "37", :project_id => "1"
    end
  
    it "should redirect to the items list" do
      mock_project.items.stub!(:find).and_return(mock_item(:destroy => true))
      delete :destroy, :id => "1", :project_id => "1"
      response.should redirect_to(project_items_url(mock_project))
    end
  end
  
  describe "responding to PUT sort" do
    it "should order the items" do
      mock_project.items.should_receive(:order).and_return([mock_item])
      put :sort, :project_id => "1", :item => ["2","1"]
    end
  end
end
