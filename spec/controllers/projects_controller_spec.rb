require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  def mock_item(stubs={})
    @item ||= mock_model(Item, stubs)    
  end
  
  describe "responding to GET index" do
    it "should expose all active projects as @projects" do
      #Project.should_receive(:find).with(:all).and_return([mock_project])
      Project.should_receive(:active).and_return([mock_project])
      get :index
      assigns[:projects].should == [mock_project]
    end

    describe "with mime type of xml" do
      it "should render all projects as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Project.should_receive(:active).and_return(projects = mock("Array of Projects"))
        projects.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET show" do

    it "should expose the requested project as @project and each item belonging to the @project as @item" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      mock_project.should_receive(:items).and_return([mock_item])
      get :show, :id => "37"
      assigns[:project].should equal(mock_project)
      assigns[:items].should == [mock_item]
    end
    
    describe "with mime type of xml" do
      it "should render the requested project as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:items).and_return([mock_item]) # TODO: need to make sure that we put these into the xml
        mock_project.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end
    end
  end
  
  # The projects controller will not have a new action, this will have been done via a draft project.
  # projects are set up as draft projects and then later are published, this is the create method of
  # the projects controller
  #
  # describe "responding to GET new" do
  #   it "should expose a new project as @project" do
  #     Project.should_receive(:new).and_return(mock_project)
  #     get :new
  #     assigns[:project].should equal(mock_project)
  #   end
  # end

  describe "responding to GET edit" do
  
    it "should expose the requested project as @project" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      get :edit, :id => "37"
      assigns[:project].should equal(mock_project)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      # it "should expose a newly created project as @project" do
      #   Project.should_receive(:new).with({'these' => 'params'}).and_return(mock_project(:save => true))
      #   post :create, :project => {:these => 'params'}
      #   assigns(:project).should equal(mock_project)
      # end
      
      it "should find and publish a project with the given id" do
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:publish!)
        post :create, :id => "37"
        assigns[:project].should equal(mock_project)
      end
      
      it "should redirect to the created project" do
        Project.stub!(:find).and_return(mock_project(:publish! => true))
        post :create, :id => "37"
        response.should redirect_to(project_url(mock_project))
      end
        
    end
    
    describe "with an id of a project that is already active" do
      it "should redirect to the found project" do
        Project.stub!(:find).and_return(mock_project(:publish! => false))
        post :create, :id => "37"
        response.should redirect_to(project_url(mock_project))
      end
        
        
        
         # this is what was orginally here as part of the scaffold
         # it "should expose a newly created but unsaved project as @project" do
         #   Project.stub!(:new).with({'these' => 'params'}).and_return(mock_project(:save => false))
         #   post :create, :project => {:these => 'params'}
         #   assigns(:project).should equal(mock_project)
         # end
    
         # it "should re-render the 'new' template" do
         #   Project.stub!(:new).and_return(mock_project(:save => false))
         #   post :create, :project => {}
         #   response.should render_template('new')
         # end
         
       end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested project" do
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :project => {:these => 'params'}
      end

      it "should expose the requested project as @project" do
        Project.stub!(:find).and_return(mock_project(:update_attributes => true))
        put :update, :id => "1"
        assigns(:project).should equal(mock_project)
      end

      it "should redirect to the project" do
        Project.stub!(:find).and_return(mock_project(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(project_url(mock_project))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested project" do
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :project => {:these => 'params'}
      end

      it "should expose the project as @project" do
        Project.stub!(:find).and_return(mock_project(:update_attributes => false))
        put :update, :id => "1"
        assigns(:project).should equal(mock_project)
      end

      it "should re-render the 'edit' template" do
        Project.stub!(:find).and_return(mock_project(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do
    
    it "should remove the project" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      mock_project.should_receive(:destroy).and_return(true)
      delete :destroy, :id => "37"
    end

    # it "should destroy the requested project" do
    #   Project.should_receive(:find).with("37").and_return(mock_project)
    #   mock_project.should_receive(:destroy)
    #   delete :destroy, :id => "37"
    # end
  
    it "should redirect to the projects list" do
      Project.stub!(:find).and_return(mock_project(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(projects_url)
    end

  end

end
