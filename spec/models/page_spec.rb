require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  fixtures :pages
  
  before(:each) do
    @valid_attributes = {
      :name => 'about me',
      :permalink => 'about_me',
      :content => 'I am completley amazing!',
      :created_at => Time.now,
      :updated_at => Time.now
    }
    
    @search_param = {
      :permalink => 'about_me',
      :id => '1'
    }
    
    @page = Page.new
  end
  
  # testing the validations
  it "should be invalid without a name" do
    @page.attributes = @valid_attributes.except(:name)
    @page.should_not be_valid
  end
  
  it "should be invalid without a permalink" do
    @page.attributes = @valid_attributes.except(:permalink, :name)
    @page.should_not be_valid
  end
  
  it "should be invalid with a duplicate permalink" do
    @page.attributes = @valid_attributes
    @page.save
    @another_page = Page.new
    @another_page.attributes = @valid_attributes
    @another_page.should_not be_valid
  end
  
  it "should be invalid without any content" do
    @page.attributes = @valid_attributes.except(:content)
    @page.should_not be_valid
  end
  
  # formatting the page content
  it "should call acts_as_textiled on the content"
    # not sure how to test this
  
  # creating the permalink
  describe "generating the permalink" do
    it "should not contain spaces" do
      @page.attributes = @valid_attributes.except(:permalink)
      @page.save
      @page.permalink.include?(" ").should_not eql(true)
    end
    
    it "should have been escaped" do
      @page.attributes = @valid_attributes.except(:permalink, :name)
      @page.name = "& This shouldn't be a permalink"
      @page.save
      @page.permalink.should eql(CGI.escape(@page.name.gsub(' ','_')))
    end
    
    it "should not change once created" do
      @page.attributes = @valid_attributes.except(:permalink)
      @page.save
      @page.update_attribute('name', "not about me")
      @page.permalink.should eql("about_me")
    end
  end
  
  # method that determines how to retreive the page for display
  describe "finding the page and its content" do
    it "should find by permalink if there is one" do
      Page.should_receive(:find_by_permalink).with(@search_param[:permalink]).and_return(mock_model(Page))
      Page.display(@search_param.except(:name))
    end
    
    it "should find by id if there is no permalink" do
      Page.should_receive(:find).with("1").and_return(mock_model(Page))
      Page.display({:id => "1"})
    end
    
    it "should raise an ActiverRecord::RecordNotFound exception if page not found"
      # this should live in the controller
  end
end
