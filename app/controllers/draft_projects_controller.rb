class DraftProjectsController < ApplicationController
  # filters
  before_filter :login_required
  
  # caching statements
  caches_action :index
  cache_sweeper :project_sweeper, :only => [:publish, :destroy]
  
  # GET /draft_projects
  # GET /draft_projects.xml
  def index
    @projects = Project.drafts

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end
  
  # GET /draft_projects/new
  # GET /draft_projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end
  
  # POST /draft_projects
  # POST /draft_projects.xml
  def create
    @project = Project.new(params[:project])
    
    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /draft_projects/:id/publish
  # PUT /draft_projects/:id/publish.xml
  def publish
    @project = Project.find(params[:id])
    
    respond_to do |format|
      if @project.publish!
        flash[:notice] = "Project was succesfully published."
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        flash[:notice] = "Project could not be published."
        format.html { redirect_to(@project) }
        # TODO: need to make sure the xml returned for a failed create shows the correct error
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end 
  end
  
end
