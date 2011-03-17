class Admin::SquadsController < AdminController
  # GET /squads
  # GET /squads.xml
  def index
    @squads = Squad.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @squads }
    end
  end

  # GET /squads/1
  # GET /squads/1.xml
  def show
    @squad = Squad.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @squad }
    end
  end

  # GET /squads/new
  # GET /squads/new.xml
  def new
    @squad = Squad.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @squad }
    end
  end

  # GET /squads/1/edit
  def edit
    @squad = Squad.find(params[:id])
  end

  # POST /squads
  # POST /squads.xml
  def create
    @squad = Squad.new(params[:squad])

    respond_to do |format|
      if @squad.save
        format.html { redirect_to(admin_squad_url(@squad), :notice => 'Squad was successfully created.') }
        format.xml  { render :xml => @squad, :status => :created, :location => @squad }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @squad.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /squads/1
  # PUT /squads/1.xml
  def update
    @squad = Squad.find(params[:id])

    respond_to do |format|
      if @squad.update_attributes(params[:squad])
        format.html { redirect_to(admin_squad_url(@squad), :notice => 'Squad was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @squad.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /squads/1
  # DELETE /squads/1.xml
  def destroy
    @squad = Squad.find(params[:id])
    @squad.destroy

    respond_to do |format|
      format.html { redirect_to(admin_squads_url) }
      format.xml  { head :ok }
    end
  end
  
  def usernames
    @usernames = Game.current.game_participations.includes(:user).where("users.id is not null").map{|gp| gp.user.username }
    render :layout => false
  end
end
