class ProjectsController < ApplicationController
  # filters
  before_filter :login_required, :only => [:edit, :create, :update, :destroy]
  
  # caching statements
  caches_action :index, :show, :if => Proc.new {|controller| controller.send(:do_caching?) }
  cache_sweeper :project_sweeper, :only => [:create, :update, :destroy]
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.active

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @items = @project.items # TODO: how does this fit in with the XML that is being generated?
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  # def new
  #   @project = Project.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @project }
  #   end
  # end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  # def create
  #   @project = Project.new(params[:project])
  # 
  #   respond_to do |format|
  #     if @project.save
  #       flash[:notice] = 'Project was successfully created.'
  #       format.html { redirect_to(@project) }
  #       format.xml  { render :xml => @project, :status => :created, :location => @project }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  
  # POST /projects
  # POST /projects.xml
  def create
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

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
