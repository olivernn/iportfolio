class ContactController < ApplicationController
  
  # caching statements
  caches_page :new
  
  # GET /contact/new
  # GET /contact/new.xml
  def new
    @contact_form = ContactForm.new

    respond_to do |format|
      format.html # new.html.erb
      #format.xml  { render :xml => @item }
    end
  end
  
  # POST /contact
  # POST /contact.xml
  def create
    @contact_form = ContactForm.new(params[:contact_form])
    
    respond_to do |format|
      if @contact_form.valid?
        Contact.deliver_contact(@contact_form)
        flash[:notice] = 'Message succesfully sent.'
        format.html { redirect_to(root_path) }
        #format.xml  { render :xml => @contact_form, :status => :created, :location => project_item_path(project, @item) }
      else
        format.html { render :action => "new" }
        #format.xml  { render :xml => @contact_form.errors, :status => :unprocessable_entity }
      end
    end
  end
end
