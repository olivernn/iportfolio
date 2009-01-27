require File.expand_path(File.dirname(__FILE__) + '<%= '/..' * class_nesting_depth %>/../spec_helper')

describe <%= controller_class_name %>Controller do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "<%= table_name %>", :action => "index", :<%= nesting_owner %>_id => 1).should == "/<%= nesting_owner.pluralize %>/1/<%= table_name %>"
    end
  
    it "should map #new" do
      route_for(:controller => "<%= table_name %>", :action => "new", :<%= nesting_owner %>_id => 1).should == "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/new"
    end
  
    it "should map #show" do
      route_for(:controller => "<%= table_name %>", :action => "show", :id => 1, :<%= nesting_owner %>_id => 1).should == "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "<%= table_name %>", :action => "edit", :id => 1, :<%= nesting_owner %>_id => 1).should == "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1<%= resource_edit_path %>"
    end
  
    it "should map #update" do
      route_for(:controller => "<%= table_name %>", :action => "update", :id => 1, :<%= nesting_owner %>_id => 1).should == "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "<%= table_name %>", :action => "destroy", :id => 1, :<%= nesting_owner %>_id => 1).should == "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>").should == {:controller => "<%= table_name %>", :action => "index", :<%= nesting_owner %>_id => "1"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/new").should == {:controller => "<%= table_name %>", :action => "new", :<%= nesting_owner %>_id => "1"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>").should == {:controller => "<%= table_name %>", :action => "create", :<%= nesting_owner %>_id => "1"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1").should == {:controller => "<%= table_name %>", :action => "show", :id => "1", :<%= nesting_owner %>_id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1<%= resource_edit_path %>").should == {:controller => "<%= table_name %>", :action => "edit", :id => "1", :<%= nesting_owner %>_id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1").should == {:controller => "<%= table_name %>", :action => "update", :id => "1", :<%= nesting_owner %>_id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/<%= nesting_owner.pluralize %>/1/<%= table_name %>/1").should == {:controller => "<%= table_name %>", :action => "destroy", :id => "1", :<%= nesting_owner %>_id => "1"}
    end
  end
end
