require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Video do
  before(:each) do
    @valid_attributes = {
        :position => 1,
        :project_id => 1,
        :name => 'my amazing piece of art',
        :description => 'my very painting',
        :date => Date.today.to_s,
        :created_at => Time.now,
        :updated_at => Time.now,
        :status => 'converted'
        #:source => fixtures_file_upload
    }
    @video = Video.new
  end

  it "should create a new instance given valid attributes" do
    Video.create!(@valid_attributes)
  end
  
  # test that the required validations are present
  it "should be invalid without a name" do
    @video.attributes = @valid_attributes.except(:name)
    @video.should_not be_valid
  end
  
  it "should have a valid date if date is populated" do
    @video.attributes = @valid_attributes.except(:date)
    @video.date = "not a date"
    @video.should_not be_valid
  end
  
  # test that the image is listable - probably using acts_as_list
  it "should have list methods"
  
  it "should have the lists scoped to the project"
  
  # testing the re-sort method
  it "should receive update on the position"
  
  # the different states of the video to indicate whether or not the file has been converted
  it "should have an initial status of pending" do
    @video.attributes = @valid_attributes.except(:status)
    @video.save
    @video.status.should eql('pending')
  end
  
  it "should have a state of converting during conversion" do
    @video.attributes = @valid_attributes.except(:status)
    @video.status = 'pending'
    @video.convert!
    @video.status.should eql('converting')
  end
  
  it "should have a state of converted after the conversion has taken place" do
    @video.attributes = @valid_attributes.except(:status)
    @video.status = 'converting'
    @video.converted!
    @video.status.should eql('converted')
  end
  
  it "should have a state of error if the conversion process failed" do
    @video.attributes = @valid_attributes.except(:status)
    @video.status = 'converting'
    @video.failed!
    @video.status.should eql('error')
  end
end
