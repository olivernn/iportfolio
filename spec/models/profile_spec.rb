require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Profile do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :location => "London",
      :email => 'anna@mail.co.uk',
      :phone => '01978820343',
      :freelance => true,
      :skills => "lots and lots and lots",
      :created_at => Time.now,
      :updated_at => Time.now
      #:photo => fixtures_file_upload
    }
    @profile = Profile.new
  end
  
  it "should be invalid without an email address" do
    @profile.attributes = @valid_attributes.except(:email)
    @profile.should_not be_valid
  end
  
  it "should be invalid with an invalid email address" do
    @profile.attributes = @valid_attributes.except(:email)
    @profile.email = "any old rubbish" # just checking that it wont except any old rubbish, not testing the whole pattern matching
    @profile.should_not be_valid
  end
  
  # only checking that there is a number input, not checking format since it could be any!
  it "should have a contact number that only contains numbers" do
    @profile.attributes = @valid_attributes.except(:phone)
    @profile.phone = "any old rubbish"
    @profile.should_not be_valid
  end
  
  it "should be valid without a contact number" do
    @profile.attributes = @valid_attributes.except(:phone)
    @profile.should be_valid
  end
  
  it "should belong to a user" do
    association = Profile.reflect_on_association(:user)
    association.should_not be_nil
    association.macro.should == :belongs_to
  end
end
