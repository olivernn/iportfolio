class ItemsController < ApplicationController
  
  before_filter :load_project
  
  protected
  
  def load_project
    @project = Project.find(params[:project_id])
  end
  
  public
  
  # GET /projects/:project_id/items
  # GET /projects/:project_id/items.xml
  def index
    @items = @project.items
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /projects/:project_id/items/1
  # GET /projects/:project_id/items/1.xml
  def show
    @item = @project.items.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /projects/:project_id/items/new
  # GET /projects/:project_id/items/new.xml
  def new
    @item = @project.items.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /projects/:project_id/items/edit
  def edit
    @item = @project.items.find(params[:id])
  end

  # POST /projects/:project_id/items
  # POST /projects/:project_id/items.xml
  def create
    @item = @project.items.build(params[:item])

    respond_to do |format|
      if @item.save
        flash[:notice] = 'Item was successfully created.'
        format.html { redirect_to([@project, @item]) }
        format.xml  { render :xml => @item, :status => :created, :location => project_item_path(project, @item) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/:project_id/items/1
  # PUT /projects/:project_id/items/1.xml
  def update
    @item = @project.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to([@project, @item]) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/:project_id/items/1
  # DELETE /projects/:project_id/items/1.xml
  def destroy
    @item = @project.items.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(project_items_path(@project)) }
      format.xml  { head :ok }
    end
  end
  
  def sort
    @project.items.order(params[:item])
    flash[:notice] = "Items succesfully sorted"
  end
end
