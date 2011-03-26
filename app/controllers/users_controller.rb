class UsersController < ApplicationController
  before_filter :must_be_signupable, :only => [:new, :create]
  before_filter :can_only_view_edit_delete_self, :only => [:show, :edit, :update]
  
  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @game_participation = @user.current_participation rescue nil
    @events = Event.belongs_to_game_participation(@game_participation).order(:occured_at) rescue []

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @game_participation = Game.current.game_participations.new
    @living_areas = LivingArea.all

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @game_participation = @user.current_participation rescue nil
    @living_areas = LivingArea.all
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @game_participation = Game.current.game_participations.new(params[:game_participation])
    @living_areas = LivingArea.all

    respond_to do |format|
      if @user.valid? && @game_participation.valid?
        @user.save
        @game_participation.user_id = @user.id
        @game_participation.save
        format.html { redirect_to(root_url, :notice => 'You have registered, please check email for confirmation') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    @game_participation = @user.current_participation rescue nil
    @living_areas = LivingArea.all
    if @user.update_attributes(params[:user])
      @game_participation.save if @game_participation
      flash[:notice] = 'updated profile'
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
  def confirm
    @user = User.find(params[:id])
    if @user.confirmation_hash == params[:confirmation]
      @user.update_attribute :confirmed, true
    else
      render :text => 'invalid confirmation'
    end
  end

  def can_only_view_edit_delete_self
    if current_user.id != params[:id].to_i
      redirect_to root_url 
    end
  end
end
