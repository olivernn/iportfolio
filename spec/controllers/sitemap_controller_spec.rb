require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SitemapController do
  
  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end
  
  def mock_item(stubs={})
    @mock_item ||= mock_model(Item, stubs)    
  end
  
  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, stubs)    
  end
  
  describe "responding to a get request" do
    it "should expose all active projects as @projects" do
      Project.should_receive(:active).and_return([mock_project])
      get :sitemap
      assigns[:projects].should == [mock_project]
    end
    
    it "should expose all pages as @pages" do
      Page.should_receive(:find).with(:all).and_return([mock_page])
      get :sitemap
      assigns[:pages].should == [mock_page]
    end
  end
end