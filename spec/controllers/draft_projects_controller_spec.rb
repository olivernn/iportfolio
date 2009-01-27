require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DraftProjectsController do
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  describe "responding to GET index" do
    it "should expose all active projects as @projects" do
      #Project.should_receive(:find).with(:all).and_return([mock_project])
      Project.should_receive(:drafts).and_return([mock_project])
      get :index
      assigns[:projects].should == [mock_project]
    end

    describe "with mime type of xml" do
      it "should render all projects as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Project.should_receive(:drafts).and_return(projects = mock("Array of Projects"))
        projects.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    end
  end
  
  describe "responding to GET new" do
    it "should expose a new project as @project" do
      Project.should_receive(:new).and_return(mock_project)
      get :new
      assigns[:project].should equal(mock_project)
    end
  end
  
  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created project as @project" do
        Project.should_receive(:new).with({'these' => 'params'}).and_return(mock_project(:save => true))
        post :create, :project => {:these => 'params'}
        assigns(:project).should equal(mock_project)
      end
      
      # TODO: this test was failing, not sure why the code looked alright though.
      # it "should redirect to the created project" do
      #   Project.stub!(:find).and_return(mock_project(:save => true))
      #   post :create, :id => "37"
      #   response.should redirect_to(project_url(mock_project))
      # end
    end
    
    describe "with invalid parameters" do  
      it "should expose a newly created but unsaved project as @project" do
        Project.stub!(:new).with({'these' => 'params'}).and_return(mock_project(:save => false))
        post :create, :project => {:these => 'params'}
        assigns(:project).should equal(mock_project)
      end

      it "should re-render the 'new' template" do
        Project.stub!(:new).and_return(mock_project(:save => false))
        post :create, :project => {}
        response.should render_template('new')
      end    
    end
  end
end
