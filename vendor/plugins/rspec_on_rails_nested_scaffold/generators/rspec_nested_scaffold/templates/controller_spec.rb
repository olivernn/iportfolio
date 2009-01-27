require File.expand_path(File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper')

describe <%= controller_class_name %>Controller do

  def mock_<%= file_name %>(stubs={})
    @mock_<%= file_name %> ||= mock_model(<%= class_name %>, stubs)
  end
  
  def mock_<%= nesting_owner %>(stubs={})
    @mock_<%= nesting_owner %> ||= mock_model(<%= nesting_owner_class %>, stubs.reverse_merge(:<%= table_name %> => mock('Array of <%= class_name.pluralize %>')))
  end
  
  before(:each) do
    <%= nesting_owner_class %>.stub!(:find).with("1").and_return(mock_<%= nesting_owner %>)
  end
    
  describe "responding to GET index" do

    it "should expose all <%= table_name.pluralize %> as @<%= table_name.pluralize %>" do
      mock_<%= nesting_owner %>.should_receive(:<%= table_name %>).with(no_args).and_return([mock_<%= file_name %>])
      get :index, :<%= nesting_owner %>_id => "1"
      assigns[:<%= table_name %>].should == [mock_<%= file_name %>]
    end

    describe "with mime type of xml" do
  
      it "should render all <%= table_name.pluralize %> as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_<%= nesting_owner %>.should_receive(:<%= table_name %>).with(no_args).and_return(<%= file_name.pluralize %> = mock("Array of <%= class_name.pluralize %>"))
        <%= table_name %>.should_receive(:to_xml).and_return("generated XML")
        get :index, :<%= nesting_owner %>_id => "1"
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested <%= file_name %> as @<%= file_name %>" do
      mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:find).with("37").and_return(mock_<%= file_name %>)
      get :show, :id => "37", :<%= nesting_owner %>_id => "1"
      assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
    end
    
    describe "with mime type of xml" do

      it "should render the requested <%= file_name %> as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:find).with("37").and_return(mock_<%= file_name %>)
        mock_<%= file_name %>.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37", :<%= nesting_owner %>_id => "1"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new <%= file_name %> as @<%= file_name %>" do
      mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:build).and_return(mock_<%= file_name %>)
      get :new, :<%= nesting_owner %>_id => "1"
      assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested <%= file_name %> as @<%= file_name %>" do
      mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:find).with("37").and_return(mock_<%= file_name %>)
      get :edit, :id => "37", :<%= nesting_owner %>_id => "1"
      assigns[:<%= file_name %>].should equal(mock_<%= file_name %>)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created <%= file_name %> as @<%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:build).with({'these' => 'params'}).and_return(mock_<%= file_name %>(:save => true))
        post :create, :<%= file_name %> => {:these => 'params'}, :<%= nesting_owner %>_id => "1"
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "should redirect to the created <%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:build).and_return(mock_<%= file_name %>(:save => true))
        post :create, :<%= file_name %> => {}, :<%= nesting_owner %>_id => "1"
        response.should redirect_to(<%= nesting_owner %>_<%= file_name %>_url(mock_<%= nesting_owner %>, mock_<%= file_name %>))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved <%= file_name %> as @<%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:build).with({'these' => 'params'}).and_return(mock_<%= file_name %>(:save => false))
        post :create, :<%= file_name %> => {:these => 'params'}, :<%= nesting_owner %>_id => "1"
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "should re-render the 'new' template" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:build).and_return(mock_<%= file_name %>(:save => false))
        post :create, :<%= file_name %> => {}, :<%= nesting_owner %>_id => "1"
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested <%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:find).with("37").and_return(mock_<%= file_name %>)
        mock_<%= file_name %>.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :<%= file_name %> => {:these => 'params'}, :<%= nesting_owner %>_id => "1"
      end

      it "should expose the requested <%= file_name %> as @<%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:find).and_return(mock_<%= file_name %>(:update_attributes => true))
        put :update, :id => "1", :<%= nesting_owner %>_id => "1"
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "should redirect to the <%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:find).and_return(mock_<%= file_name %>(:update_attributes => true))
        put :update, :id => "1", :<%= nesting_owner %>_id => "1"
        response.should redirect_to(<%= nesting_owner %>_<%= file_name %>_url(mock_<%= nesting_owner %>, mock_<%= file_name %>))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested <%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:find).with("37").and_return(mock_<%= file_name %>)
        mock_<%= file_name %>.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :<%= file_name %> => {:these => 'params'}, :<%= nesting_owner %>_id => "1"
      end

      it "should expose the <%= file_name %> as @<%= file_name %>" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:find).and_return(mock_<%= file_name %>(:update_attributes => false))
        put :update, :id => "1", :<%= nesting_owner %>_id => "1"
        assigns(:<%= file_name %>).should equal(mock_<%= file_name %>)
      end

      it "should re-render the 'edit' template" do
        mock_<%= nesting_owner %>.<%= table_name %>.stub!(:find).and_return(mock_<%= file_name %>(:update_attributes => false))
        put :update, :id => "1", :<%= nesting_owner %>_id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested <%= file_name %>" do
      mock_<%= nesting_owner %>.<%= table_name %>.should_receive(:find).with("37").and_return(mock_<%= file_name %>)
      mock_<%= file_name %>.should_receive(:destroy)
      delete :destroy, :id => "37", :<%= nesting_owner %>_id => "1"
    end
  
    it "should redirect to the <%= table_name %> list" do
      mock_<%= nesting_owner %>.<%= table_name %>.stub!(:find).and_return(mock_<%= file_name %>(:destroy => true))
      delete :destroy, :id => "1", :<%= nesting_owner %>_id => "1"
      response.should redirect_to(<%= nesting_owner %>_<%= table_name %>_url(mock_<%= nesting_owner %>))
    end

  end

end
