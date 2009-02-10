class ImagesController < ApplicationController
  # filters
  before_filter :load_project
  before_filter :login_required, :only => [:new, :edit, :create, :update, :destroy]
  
  # this method will scope this controller to the project matching the project id passed
  protected
  
  def load_project
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url
    end
  end
  
  # the following methods will respond to public requests
  public

  # GET /projects/:project_id/images/new
  # GET /projects/:project_id/images/new.xml
  def new
    @image = @project.images.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /projects/:project_id/images/edit
  def edit
    @image = @project.images.find(params[:id])
  end

  # POST /projects/:project_id/images
  # POST /projects/:project_id/images.xml
  def create
    @image = @project.images.build(params[:image])

    respond_to do |format|
      if @image.save
        flash[:notice] = 'image was successfully created.'
        format.html { redirect_to(project_item_path(@project, @image)) }
        format.xml  { render :xml => @image, :status => :created, :location => project_image_path(project, @image) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/:project_id/images/1
  # PUT /projects/:project_id/images/1.xml
  def update
    @image = @project.images.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        flash[:notice] = 'image was successfully updated.'
        format.html { redirect_to(project_item_path(@project, @image)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/:project_id/images/1
  # DELETE /projects/:project_id/images/1.xml
  def destroy
    @image = @project.images.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to(project_images_path(@project)) }
      format.xml  { head :ok }
    end
  end
end
