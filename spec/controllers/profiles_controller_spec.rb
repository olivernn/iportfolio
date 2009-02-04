require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProfilesController do

  def mock_profile(stubs={})
    @mock_profile ||= mock_model(Profile, stubs)
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs.reverse_merge(:profiles => mock('Array of Profiles')))
  end
  
  before(:each) do
    User.stub!(:find).with("1").and_return(mock_user)
  end
  
  # since this is a singleton resource there will only be one profile and therefore the index is not needed
  #
  # describe "responding to GET index" do
  # 
  #     it "should expose all profiles as @profiles" do
  #       mock_user.should_receive(:profiles).with(no_args).and_return([mock_profile])
  #       get :index, :user_id => "1"
  #       assigns[:profiles].should == [mock_profile]
  #     end
  # 
  #     describe "with mime type of xml" do
  #   
  #       it "should render all profiles as xml" do
  #         request.env["HTTP_ACCEPT"] = "application/xml"
  #         mock_user.should_receive(:profiles).with(no_args).and_return(profiles = mock("Array of Profiles"))
  #         profiles.should_receive(:to_xml).and_return("generated XML")
  #         get :index, :user_id => "1"
  #         response.body.should == "generated XML"
  #       end
  #     
  #     end
  # 
  #   end

  describe "responding to GET show" do

    it "should expose the requested profile as @profile" do
      #mock_user.profiles.should_receive(:find).with("37").and_return(mock_profile)
      mock_user.should_receive(:profile).and_return(mock_profile)
      get :show, :user_id => "1"
      assigns[:profile].should equal(mock_profile)
    end
    
    describe "with mime type of xml" do

      it "should render the requested profile as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        #mock_user.profiles.should_receive(:find).with("37").and_return(mock_profile)
        mock_user.should_receive(:profile).and_return(mock_profile)
        mock_profile.should_receive(:to_xml).and_return("generated XML")
        get :show, :user_id => "1"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
    it "should expose a new profile as @profile" do
      mock_user.should_receive(:build_profile).and_return(mock_profile)
      get :new, :user_id => "1"
      assigns[:profile].should equal(mock_profile)
    end
  end

  describe "responding to GET edit" do
    it "should expose the requested profile as @profile" do
      mock_user.should_receive(:profile).and_return(mock_profile)
      get :edit, :user_id => "1"
      assigns[:profile].should equal(mock_profile)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created profile as @profile" do
        mock_user.should_receive(:build_profile)..with({'these' => 'params'}).and_return(mock_profile(:save => true))
        post :create, :profile => {:these => 'params'}, :user_id => "1"
        assigns(:profile).should equal(mock_profile)
      end

      it "should redirect to the created profile" do
        mock_user.should_receive(:build_profile).and_return(mock_profile)
        mock_profile.stub!(:new).and_return(mock_profile(:save => true))
        post :create, :profile => {}, :user_id => "1"
        response.should redirect_to(root_path)
      end
    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved profile as @profile" do
        mock_user.should_receive(:build_profile)..with({'these' => 'params'}).and_return(mock_profile(:save => false))
        post :create, :profile => {:these => 'params'}, :user_id => "1"
        assigns(:profile).should equal(mock_profile)
      end

      it "should re-render the 'new' template" do
        mock_user.should_receive(:build_profile)..with({'these' => 'params'}).and_return(mock_profile(:save => false))
        post :create, :profile => {}, :user_id => "1"
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested profile" do
        mock_user.should_receive(:profile).and_return(mock_profile)
        mock_profile.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :profile => {:these => 'params'}, :user_id => "1"
      end

      it "should expose the requested profile as @profile" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => true))
        put :update, :user_id => "1"
        assigns(:profile).should equal(mock_profile)
      end

      it "should redirect to home page" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => true))
        put :update, :user_id => "1"
        response.should redirect_to(root_path)
      end
    end
    
    describe "with invalid params" do
      it "should update the requested profile" do
        mock_user.should_receive(:profile).and_return(mock_profile)
        mock_profile.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :profile => {:these => 'params'}, :user_id => "1"
      end

      it "should expose the profile as @profile" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => false))
        put :update, :user_id => "1"
        assigns(:profile).should equal(mock_profile)
      end

      it "should re-render the 'edit' template" do
        mock_user.stub!(:profile).and_return(mock_profile(:update_attributes => false))
        put :update, :user_id => "1"
        response.should render_template('edit')
      end
    end
  end

  # it isn't possible to destroy your profile
  # describe "responding to DELETE destroy" do
  #   it "should destroy the requested profile" do
  #     mock_user.profiles.should_receive(:find).with("37").and_return(mock_profile)
  #     mock_profile.should_receive(:destroy)
  #     delete :destroy, :id => "37", :user_id => "1"
  #   end
  # 
  #   it "should redirect to the profiles list" do
  #     mock_user.profiles.stub!(:find).and_return(mock_profile(:destroy => true))
  #     delete :destroy, :id => "1", :user_id => "1"
  #     response.should redirect_to(user_profiles_url(mock_user))
  #   end
  # end

end
