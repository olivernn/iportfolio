require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProfilesController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "profiles", :action => "index", :user_id => 1).should == "/users/1/profiles"
    end
  
    it "should map #new" do
      route_for(:controller => "profiles", :action => "new", :user_id => 1).should == "/users/1/profiles/new"
    end
  
    it "should map #show" do
      route_for(:controller => "profiles", :action => "show", :id => 1, :user_id => 1).should == "/users/1/profiles/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "profiles", :action => "edit", :id => 1, :user_id => 1).should == "/users/1/profiles/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "profiles", :action => "update", :id => 1, :user_id => 1).should == "/users/1/profiles/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "profiles", :action => "destroy", :id => 1, :user_id => 1).should == "/users/1/profiles/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/users/1/profiles").should == {:controller => "profiles", :action => "index", :user_id => "1"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/users/1/profiles/new").should == {:controller => "profiles", :action => "new", :user_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/users/1/profiles").should == {:controller => "profiles", :action => "create", :user_id => "1"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/users/1/profiles/1").should == {:controller => "profiles", :action => "show", :id => "1", :user_id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/users/1/profiles/1/edit").should == {:controller => "profiles", :action => "edit", :id => "1", :user_id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/users/1/profiles/1").should == {:controller => "profiles", :action => "update", :id => "1", :user_id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/users/1/profiles/1").should == {:controller => "profiles", :action => "destroy", :id => "1", :user_id => "1"}
    end
  end
end
