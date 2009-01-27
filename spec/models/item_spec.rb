require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Item do
  before(:each) do
    @valid_attributes = {
      :position => 1,
      :name => 'my amazing piece of art',
      :description => 'my very painting',
      :date => Date.today.to_s,
      :created_at => Time.now,
      :updated_at => Time.now
    }
    @item = Item.new
  end
  
  # test that the required validations are present
  it "should be invalid without a name" do
    @item.attributes = @valid_attributes.except(:name)
    @item.should_not be_valid
  end
  
  it "should have a valid date if date is populated" do
    @item.attributes = @valid_attributes.except(:date)
    @item.date = "not a date"
    @item.should_not be_valid
  end
  
  # test that the associations are as they should be
  it "should belong to a project" do
    association = Item.reflect_on_association(:project)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
  
  # test that the item is listable - probably using acts_as_list
  it "should have list methods"
    # not sure how to test this?
  
  it "should have the lists scoped to the project"
    # again not sure how to test
  
  # testing the re-sort method
  it "should receive update on the position"
    # not sure how to test this method
end
