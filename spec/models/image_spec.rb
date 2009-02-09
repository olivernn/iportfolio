require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Image do
  before(:each) do
    @valid_attributes = {
        :position => 1,
        :name => 'my amazing piece of art',
        :description => 'my very painting',
        :date => Date.today.to_s,
        :created_at => Time.now,
        :updated_at => Time.now,
        :photo => fixtures_file_upload
    }
    @image = Image.new
  end

  it "should create a new instance given valid attributes" do
    Image.create!(@valid_attributes)
  end
  
  # below are all tests that are inherited from the Item class,
  # testing them here as well as on the item spec as they all
  # describe the behaviour of the Image
  
  # test that the required validations are present
  it "should be invalid without a name" do
    @image.attributes = @valid_attributes.except(:name)
    @image.should_not be_valid
  end
  
  it "should have a valid date if date is populated" do
    @image.attributes = @valid_attributes.except(:date)
    @image.date = "not a date"
    @image.should_not be_valid
  end
  
  # test that the associations are as they should be
  it "should belong to a project" do
    association = image.reflect_on_association(:project)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
  
  # test that the image is listable - probably using acts_as_list
  it "should have list methods"
  
  it "should have the lists scoped to the project"
  
  # testing the re-sort method
  it "should receive update on the position"
  
end
