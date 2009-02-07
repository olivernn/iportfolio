require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactController do

  before(:each) do
    controller.stub!(:sidebar).and_return(true)
  end

  def mock_contact_form(stubs={})
    @mock_contact_form ||= mock_model(ContactForm, stubs)
  end
  
  describe "responding to GET new" do
    it "should expose a new contact form as @contact_form" do
      ContactForm.should_receive(:new).and_return(mock_contact_form)
      get :new
      assigns[:contact_form].should equal(mock_contact_form)
    end
  end
  
  describe "responding to POST create" do
    describe "with valid params" do
      it "should validate the contact form and deliver the contact" do
        ContactForm.should_receive(:new).with({'these' => 'params'}).and_return(mock_contact_form(:valid? => true))
        Contact.should_receive(:deliver_contact).with(mock_contact_form).and_return(true)
        post :create, :contact_form => {:these => 'params'}
        assigns(:contact_form).should equal(mock_contact_form)
      end
      
      it "should redirect to root page" do
        ContactForm.stub!(:new).and_return(mock_contact_form(:valid? => true))
        Contact.stub!(:deliver_contact).and_return(true)
        post :create, :contact_form => {:these => 'params'}
        response.should redirect_to(root_url)
      end
    end
    
    describe "with invalid parameters" do  
      it "should expose a newly created but unsaved contact_form as @contact_form" do
        ContactForm.stub!(:new).with({'these' => 'params'}).and_return(mock_contact_form(:valid? => false))
        post :create, :contact_form => {:these => 'params'}
        assigns(:contact_form).should equal(mock_contact_form)
      end

      it "should re-render the 'new' template" do
        ContactForm.stub!(:new).and_return(mock_contact_form(:valid? => false))
        post :create, :contact_form => {}
        response.should render_template('new')
      end    
    end
  end
end
