require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideosController do
  
  before(:each) do
    controller.stub!(:login_required).and_return(true)
    controller.stub!(:sidebar).and_return(true)
  end
  
  def mock_video(stubs={})
    @mock_video ||= mock_model(Video, stubs)
  end
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs.reverse_merge(:videos => mock('Array of Videos')))
  end
  
  before(:each) do
    Project.stub!(:find).with("1").and_return(mock_project)
  end
  
  describe "scoping the actions to a project" do
    it "should expose the project as @project" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      get :new, :project_id => "37"
      assigns[:project].should == mock_project
    end
    
    describe "handling a un-recognized project id" do
      it "should issue a warning and redirect to projects index" do
        Project.stub!(:find).with("99").and_raise(ActiveRecord::RecordNotFound)
        get :new, :project_id => "99"
        response.should redirect_to(projects_url)
      end
    end
  end

  describe "responding to GET new" do
    it "should expose a new video as @video" do
      mock_project.videos.should_receive(:build).and_return(mock_video)
      get :new, :project_id => "1"
      assigns[:video].should equal(mock_video)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested video as @video" do
      mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
      get :edit, :id => "37", :project_id => "1"
      assigns[:video].should equal(mock_video)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created video as @video" do
        mock_project.videos.should_receive(:build).with({'these' => 'params'}).and_return(mock_video(:save => true))
        mock_video.should_receive(:convert)
        post :create, :video => {:these => 'params'}, :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should redirect to the created video" do
        mock_project.videos.stub!(:build).and_return(mock_video(:save => true))
        mock_video.should_receive(:convert)
        post :create, :video => {}, :project_id => "1"
        response.should redirect_to(project_item_url(mock_project, mock_video))
      end 
    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved video as @video" do
        mock_project.videos.stub!(:build).with({'these' => 'params'}).and_return(mock_video(:save => false))
        post :create, :video => {:these => 'params'}, :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should re-render the 'new' template" do
        mock_project.videos.stub!(:build).and_return(mock_video(:save => false))
        post :create, :video => {}, :project_id => "1"
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested video" do
        mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
        mock_video.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the requested video as @video" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should redirect to the video" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => true))
        put :update, :id => "1", :project_id => "1"
        response.should redirect_to(project_item_url(mock_project, mock_video))
      end
    end
    
    describe "with invalid params" do
      it "should update the requested video" do
        mock_project.videos.should_receive(:find).with("37").and_return(mock_video)
        mock_video.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :video => {:these => 'params'}, :project_id => "1"
      end

      it "should expose the video as @video" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        assigns(:video).should equal(mock_video)
      end

      it "should re-render the 'edit' template" do
        mock_project.videos.stub!(:find).and_return(mock_video(:update_attributes => false))
        put :update, :id => "1", :project_id => "1"
        response.should render_template('edit')
      end
    end
  end
end
