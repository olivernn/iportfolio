require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do

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

  describe "responding to GET show" do
    it "should expose the requested item as @item" do
      mock_project.items.should_receive(:find).with("37").and_return(mock_item)
      get :show, :id => "37", :project_id => "1"
      assigns[:item].should equal(mock_item)
    end
    
    describe "with mime type of xml" do
      it "should render the requested item as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_project.items.should_receive(:find).with("37").and_return(mock_item)
        mock_item.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :project_id => "1"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET new" do
    it "should expose a new item as @item" do
      mock_project.items.should_receive(:build).and_return(mock_item)
      get :new, :project_id => "1"
      assigns[:item].should equal(mock_item)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested item as @item" do
      mock_project.items.should_receive(:find).with("37").and_return(mock_item)
      get :edit, :id => "37", :project_id => "1"
      assigns[:item].should equal(mock_item)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created item as @item" do
        mock_project.items.should_receive(:build).with({'these' => 'params'}).and_return(mock_item(:save => true))
        post :create, :item => {:these => 'params'}, :project_id => "1"
        assigns(:item).should equal(mock_item)
      end

      it "should redirect to the created item" do
        mock_project.items.stub!(:build).and_return(mock_item(:save => true))
        post :create, :item => {}, :project_id => "1"
        response.should redirect_to(project_item_url(mock_project, mock_item))
      end
    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved item as @item" do
        mock_project.items.stub!(:build).with({'these' => 'params'}).and_return(mock_item(:save => false))
        post :create, :item => {:these => 'params'}, :project_id => "1"
        assigns(:item).should equal(mock_item)
      end

      it "should re-render the 'new' template" do
        mock_project.items.stub!(:build).and_return(mock_item(:save => false))
        post :create, :item => {}, :project_id => "1"
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested item" do
        mock_project.items.should_receive(:find).with("37").and_return(mock_item)
        mock_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :item => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the requested item as @item" do
        mock_project.items.stub!(:find).and_return(mock_item(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        assigns(:item).should equal(mock_item)
      end

      it "should redirect to the item" do
        mock_project.items.stub!(:find).and_return(mock_item(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        response.should redirect_to(project_item_url(mock_project, mock_item))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested item" do
        mock_project.items.should_receive(:find).with("37").and_return(mock_item)
        mock_item.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :item => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the item as @item" do
        mock_project.items.stub!(:find).and_return(mock_item(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        assigns(:item).should equal(mock_item)
      end

      it "should re-render the 'edit' template" do
        mock_project.items.stub!(:find).and_return(mock_item(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        response.should render_template('edit')
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
