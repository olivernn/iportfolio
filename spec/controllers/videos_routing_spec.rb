require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideosController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "videos", :action => "index", :project_id => 1).should == "/projects/1/videos"
    end
  
    it "should map #new" do
      route_for(:controller => "videos", :action => "new", :project_id => 1).should == "/projects/1/videos/new"
    end
  
    it "should map #show" do
      route_for(:controller => "videos", :action => "show", :id => 1, :project_id => 1).should == "/projects/1/videos/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "videos", :action => "edit", :id => 1, :project_id => 1).should == "/projects/1/videos/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "videos", :action => "update", :id => 1, :project_id => 1).should == "/projects/1/videos/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "videos", :action => "destroy", :id => 1, :project_id => 1).should == "/projects/1/videos/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/projects/1/videos").should == {:controller => "videos", :action => "index", :project_id => "1"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/projects/1/videos/new").should == {:controller => "videos", :action => "new", :project_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/projects/1/videos").should == {:controller => "videos", :action => "create", :project_id => "1"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/projects/1/videos/1").should == {:controller => "videos", :action => "show", :id => "1", :project_id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/projects/1/videos/1/edit").should == {:controller => "videos", :action => "edit", :id => "1", :project_id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/projects/1/videos/1").should == {:controller => "videos", :action => "update", :id => "1", :project_id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/projects/1/videos/1").should == {:controller => "videos", :action => "destroy", :id => "1", :project_id => "1"}
    end
  end
end
