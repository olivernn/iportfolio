require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/images/index.html.erb" do
  include ImagesHelper
  
  before(:each) do
    assigns[:images] = [
      stub_model(Image),
      stub_model(Image)
    ]
  end

  it "should render list of images" do
    render "/images/index.html.erb"
  end
end

