class VideosController < ApplicationController
  
  before_filter :load_project
  
  protected
  
  def load_project
    begin
      @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to projects_url
    end
  end
  
  public

  # GET /projects/:project_id/videos/new
  # GET /projects/:project_id/videos/new.xml
  def new
    @video = @project.videos.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /projects/:project_id/videos/edit
  def edit
    @video = @project.videos.find(params[:id])
  end

  # POST /projects/:project_id/videos
  # POST /projects/:project_id/videos.xml
  def create
    @video = @project.videos.build(params[:video])

    respond_to do |format|
      if @video.save
        @video.convert_video
        flash[:notice] = 'Video was successfully created.'
        format.html { redirect_to( project_item_path(@project, @video)) }
        format.xml  { render :xml => @video, :status => :created, :location => project_item_path(project, @video) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/:project_id/videos/1
  # PUT /projects/:project_id/videos/1.xml
  def update
    @video = @project.videos.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to( project_item_path(@project, @video)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end
end
