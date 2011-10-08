class SquadsController < ApplicationController
  before_filter :must_control_squad, :only => ['edit', 'update']
  before_filter :is_squad_leader, :only => ['edit', 'update', 'show']

  def index
    @game = Game.find_by_id(params[:game_id]) || current_game
    @squads = @game.squads if @game
    @squads ||= []
    @games = Game.order('end_at desc')
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
  
  # GET /squads/1/edit
  def edit
    @squad.add_squad_members
  end
  
  # PUT /squads/1
  # PUT /squads/1.xml
  def update
    params[:squad].delete :squad_leader_username

    respond_to do |format|
      if @squad.update_attributes(params[:squad])
        format.html { redirect_to(squad_url(@squad), :notice => 'Squad was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @squad.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def usernames
    username = params[:squad][:squad_member_usernames].first
    logger.debug "the username is #{username}"
    @usernames = Game.current.game_participations.includes(:user).where("users.id is not null and users.username like ? and game_participations.creature_type = ?", "%#{username}%", 'Human').map{|gp| gp.user.username }
    render :partial => 'layouts/usernames_autocomplete'
  end
  
  private 
  
  def is_squad_leader
    @squad ||= Squad.find(params[:id])
    @is_squad_leader||= current_user && current_user.current_participation == @squad.current_leader
  end
  
  def must_control_squad
    if is_squad_leader
      return true
    end
    redirect_to root_url
  end

end
