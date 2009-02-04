class ProfilesController < ApplicationController
  
  before_filter :load_user
  
  protected
  
  def load_user
    @user = User.find(params[:user_id])
  end
  
  public
  
  # since this is a singleton resource there will be no index action
  #
  # GET /users/:user_id/profiles
  # GET /users/:user_id/profiles.xml
  # def index
  #   @profiles = @user.profiles
  #   
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @profiles }
  #   end
  # end

  # GET /users/:user_id/profile
  # GET /users/:user_id/profile.xml
  def show
    @profile = @user.profile

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /users/:user_id/profile/new
  # GET /users/:user_id/profile/new.xml
  def new
    @profile = @user.build_profile

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profile }
    end
  end

  # GET /users/:user_id/profile/edit
  def edit
    @profile = @user.profile
  end

  # POST /users/:user_id/profile
  # POST /users/:user_id/profile.xml
  def create
    @profile = @user.build_profile(params[:profile])

    respond_to do |format|
      if @profile.save
        flash[:notice] = 'Profile was successfully created.'
        logger.debug root_path
        format.html { redirect_to(root_path) }
        format.xml  { render :xml => @profile, :status => :created, :location => user_profile_path(user, @profile) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/:user_id/profile
  # PUT /users/:user_id/profile.xml
  def update
    @profile = @user.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  # you cannot destroy your profile
  # DELETE /users/:user_id/profile
  # DELETE /users/:user_id/profile.xml
  # def destroy
  #   @profile = @user.profile
  #   @profile.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(user_profiles_path(@user)) }
  #     format.xml  { head :ok }
  #   end
  # end
end
