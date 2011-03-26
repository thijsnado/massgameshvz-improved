class Admin::UsersController < AdminController
  before_filter :find_user, :except => ['index', 'get_creatures', 'new', 'create']
  
  def index
    @order = params[:order] || 'id'
    @descasc = params[:descasc] || 'asc'
    @users = User.paginate(:all, :page => params[:page], :order =>  @order+ ' ' + @descasc)
    if @descasc == 'asc'
      @descasc = 'desc'
    else
      @descasc = 'asc'
    end
  end

  def edit
    @user = User.find(params[:id])
    @game_participation = @user.current_participation ? @user.current_participation : Game.current.game_participations.new rescue nil
    @living_areas = LivingArea.all
    @creatures = @game_participation.creature.class.all rescue []
  end
  
  def new
    @user = User.new
    @game_participation =  Game.current.game_participations.new rescue nil
    @living_areas = LivingArea.all
    @creatures = []
  end

  def update
    @user = User.find(params[:id])
    set_zombie_expires_at = false
    if @user.current_participation && @user.current_participation.human? && params[:game_participation][:creature_type] == 'Zombie'
      zombie =  Zombie.find_by_id(params[:game_participation][:creature_id])
      unless zombie.immortal || !params[:game_participation][:zombie_expires_at].blank?
        set_zombie_expires_at = true
      end
    end
    @user.confirmed = true
    @user.attributes = params[:user]
    @game_participation = @user.current_participation ? @user.current_participation : Game.current.game_participations.new rescue nil
    @game_participation.attributes = params[:game_participation] if @game_participation
    @game_participation.user_id = @user.id if @game_participation
    @game_participation.set_zombie_expires_at if set_zombie_expires_at
    respond_to do |format|
      @user.save(:validate => false)
      @game_participation.save(:validate => false) if @game_participation
      format.html { redirect_to(admin_user_url(@user), :notice => 'User was successfully updated.') }
      format.xml  { head :ok }
    end
  end
  
  def create
    @user = User.new(params[:user])
    @user.confirmed = true
    @game_participation = Game.current.game_participations.new rescue nil
    @game_participation.attributes = params[:game_participation] if @game_participation
    @game_participation.user = @user if @game_participation
    respond_to do |format|
      @user.save(:validate => false)
      @game_participation.save(:validate => false) if @game_participation
      format.html { redirect_to(admin_user_url(@user), :notice => 'User was successfully created.') }
      format.xml  { head :ok }
    end
  end
  


  def show
    @current_participation = @user.current_participation
    if @current_participation
      if @current_participation.creature_type == 'Human'
        @status = :human
      elsif @current_participation.creature_type == 'Zombie'
        if @current_participation.creature.immortal
          @status = :immortal_zombie
        else
          if @current_participation.dead?
            @status = :dead
          else
            @status = :mortal_zombie
          end
        end
      end
    else
      @status = :no_participation
    end
    @events = Event.belongs_to_game_participation(@current_participation).order(:occured_at) rescue []
  end
  
  def destroy
    @user.destroy
    redirect_to admin_users_url()
  end
  
  def get_creatures
    if params.has_key? :Human
      @creatures = Human.all
    elsif params.has_key? :Zombie
      @creatures = Zombie.all
    end
  end

  private 
  
  def find_user
    @user = User.find(params[:id])
  end
end
