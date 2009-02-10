class ItemsController < ApplicationController
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
      format.js
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
  
  # PUT /projects/:project_id/items/items/sort
  def sort
    # @project.items.order(params[:item])
    # render :nothing => true, :status => 200
    @project.items.each do |item|
      if position = params[:items].index(item.id.to_s)
        item.update_attribute(:position, position + 1) unless item.position == position + 1
      end
    end
    render :nothing => true, :status => 200
  end
end
